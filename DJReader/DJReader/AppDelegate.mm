//
//  AppDelegate.m
//  DJReader
//
//  Created by Andersen on 2020/3/4.
//  Copyright © 2020 Andersen. All rights reserved.

///自己的类
#import "AppDelegate.h"
#import "CSTabBarMainController.h"
#import "CSSnowIDFactory.h"
#import "DJReadUser.h"
#import "CSCoreDataManager.h"
#import "DJReadManager.h"
#import "CSLaunchView.h"
#import "LoginDistributionController.h"
#import "LoginViewController.h"
#import "ImageProgram.h"
#import "FileProgram.h"
#import "FileMergeProgram.h"
#import "PageManageProgram.h"
#import "FileConvertProgram.h"
#import <DJContents/DJContents.h>
///第三方SDK及系统的库
#import "BUAdSDK/BUSplashAdView.h"
#import "WXApi.h"
#import <libkern/OSAtomic.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import <StoreKit/StoreKit.h>
#import <BaiduMobStat.h>
#import "SubscribeController.h"
#import "BindPhoneController.h"
#import "DJReadNetManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()<BUSplashAdDelegate>
@property (nonatomic,strong) NSMutableArray * userFloders;
@property (nonatomic,strong) CSTabBarMainController *mainController;
@property (nonatomic,assign) CFTimeInterval startTime;
@property (nonatomic,strong) DJReaderConfig *config;
@property (nonatomic,assign) BOOL isBUAD;
@end

@implementation AppDelegate
- (CSTabBarMainController*)mainController
{
    if (!_mainController) {
        _mainController = [[CSTabBarMainController alloc]init];
        _mainController.tabBar.translucent = YES;
    }
    return _mainController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = CSBackgroundColor;
    self.shouldLandscape = 0;
    [self loadAttribute];
    return YES;
}
// 启动百度移动统计
- (void)startBaiduMobileStat{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"f184e5365e"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}
- (void)loadBUADLaunch
{
    if (_isBUAD)
        return;
    
    _isBUAD = YES;
    CSLaunchView *launchView = [[CSLaunchView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [launchView showIn:self.window];
}
- (void)loadDJSDK
{
    [DJContentView verify:@"INXT" verifylicFile:@"XSLSjA36jgtp5xM9qypF4SXqM0KOksF5z9FE+IsRZzo="];
    [DJContentView loginUser:@"Andersen" loadOtherNodes:YES];
}
- (void)getConfig
{
    NSString *appType = @"2";//1-andriod;2-iOS
    NSString *appKey = @"advert_status";
    NSString *appVersion = APP_VERSION;
    NSMutableDictionary *parms = [NSMutableDictionary new];
    [parms setValue:appType forKey:@"appType"];
    [parms setValue:appKey forKey:@"appKey"];
    [parms setValue:appVersion forKey:@"appVersion"];
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_GETConfig parameters:(NSDictionary*)parms showError:NO reponseResult:^(DJService *service) {
        NSDictionary *config = [service.dataResult lastObject];
        self.config = [DJReaderConfig yy_modelWithDictionary:config];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[CSCoreDataManager shareManager] fetchPrvUser:^(DJReadUser * _Nonnull user) {
                if (user){
                    [DJReadManager loginUser:user];
                    if (user.isvip != 1&&[self.config.appValue isEqualToString:@"1"]) {
                        [self loadBUADLaunch];
                    }
                }else{
                    if ([self.config.appValue isEqualToString:@"1"]) {
                        [self loadBUADLaunch];
                    }
                }
            }];
        });
    }];
}
- (void)loadAttribute
{
    if (@available(iOS 14, *)) {
        //申请权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"IDFA：%@----- %lu",[[ASIdentifierManager sharedManager] advertisingIdentifier],(unsigned long)status);
        }];
    }
    [self loadDJSDK];
    [self startBaiduMobileStat];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [DJReadManager loadFonts];//写入字体
        [WXApi registerApp:WeChat_APPID universalLink:@"https://bdz4.t4m.cn/OFD/"];///微信注册appID
    });
    [self getConfig];
}
- (void)fetchSnowID
{
    CSSnowIDFactory *snowFactory = [CSSnowIDFactory shareFactory];
    for (int i = 0; i<20; i++) {
        NSLog(@"snow ID: %ld",[snowFactory nextID]);
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_shouldLandscape == 0) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString containsString:WeChat_APPID]) {
        return [WXApi handleOpenURL:url delegate:[DJReadManager shareManager]];///微信登录打开
    }else{
        [self gotoMainRootControllerWith:url];///第三方文件登录打开
        return YES;
    }
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    if ([url.absoluteString containsString:WeChat_APPID]) {
        return [WXApi handleOpenURL:url delegate:[DJReadManager shareManager]];///微信登录打开
    }else{
        [self gotoMainRootControllerWith:url];///第三方文件登录打开
        return YES;
    }
}
#endif

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    return [WXApi handleOpenUniversalLink:userActivity delegate:nil];
}
- (void)gotoMainRootControllerWith:(NSURL*)url
{
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainController = nil;
    [self.window setRootViewController:self.mainController];
    self.mainController.shareFileURL = url;
    self.mainController.userFolders = self.userFloders;
}
- (void)gotoMainRootController
{
    CSTabBarMainController *root = [[CSTabBarMainController alloc]init];
    root.tabBar.translucent = YES;
    [self.window setRootViewController:root];
    [root setUserFolders:self.userFloders];
}
- (void)gotoLoginRootController
{
    [DJReadManager isProduct:^(BOOL isProduct) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isProduct) {
                LoginDistributionController *loginVC = [[LoginDistributionController alloc]init];
                [self.window setRootViewController:loginVC];
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.window setRootViewController:loginVC];
            }
        });
    }];
}
- (void)gotoLoginControllerFrom:(id)parentVC
{
    [DJReadManager isProduct:^(BOOL isProduct) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isProduct) {
                LoginDistributionController *loginVC = [[LoginDistributionController alloc]init];
                loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
                loginVC.originController = self.mainController;
                if ([parentVC isKindOfClass:[UIViewController class]]) {
                    [parentVC presentViewController:loginVC animated:YES completion:nil];
                }else if([parentVC isKindOfClass:[UINavigationController class]]){
                    [parentVC popViewControllerAnimated:YES];
                }
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
                loginVC.originController = self.mainController;

                if ([parentVC isKindOfClass:[UIViewController class]]) {
                    [parentVC presentViewController:loginVC animated:YES completion:nil];
                }else if([parentVC isKindOfClass:[UINavigationController class]]){
                    [parentVC popViewControllerAnimated:YES];
                }
            }
        });
    }];
}

- (void)gotoSubcribeControllerFrom:(id)parentVC
{
    SubscribeController *subscribeController = [SubscribeController new];
    subscribeController.originController = self.mainController;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:subscribeController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [parentVC presentViewController:nav animated:YES completion:nil];
}
- (void)gotoBindPhoneControllerFrom:(id)parentVC
{
    BindPhoneController *bindVC = [[BindPhoneController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:bindVC];
    navc.modalPresentationStyle = UIModalPresentationFullScreen;
    [parentVC presentViewController:navc animated:YES completion:nil];
}
- (void)launchingProgram:(NSString*)programName programSection:(NSString*)sectionName
{
    if ([sectionName isEqualToString:ProgramSection_imageOperation]) {
        if ([programName isEqualToString:ProgramName_imagesConvertOFD]|| [programName isEqualToString:ProgramName_imagesConvertPDF]) {
            ImageProgram *program = [[ImageProgram alloc]init];
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_images]){
            FileProgram *program = [[FileProgram alloc]init];
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.programColor = [UIColor colorWithRed:246/255.0 green:196/255.0 blue:67/255.0 alpha:1.0];
            program.descripts = @[@"● 将PDF、OFD文档指定页面输出图片，每一页一张图片"];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_longImage]){
            FileProgram *program = [[FileProgram alloc]init];
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将PDF、OFD文档指定页面输出为一张长图片"];;
            program.programColor = [UIColor colorWithRed:71/255.0 green:119/255.0 blue:246/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }
    }else if([sectionName isEqualToString:ProgramSection_PDFOperation]){
        if ([programName isEqualToString:ProgramName_PDFConvertOFD]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"pdf";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将PDF文档转换为OFD文件格式"];
            program.programColor = [UIColor colorWithRed:239/255.0 green:126/255.0 blue:121/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_PDFMerge]){
            FileMergeProgram *program = [[FileMergeProgram alloc]init];
            program.fileFilterCondition = @"pdf";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将多个PDF文件合并"];
            program.programColor = [UIColor colorWithRed:239/255.0 green:126/255.0 blue:121/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_PDFPageManager]){
            PageManageProgram *program = [[PageManageProgram alloc]init];
            program.fileFilterCondition = @"pdf";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 管理文件页面"];
            program.programColor = [UIColor colorWithRed:91/255.0 green:181/255.0 blue:249/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_WordConvertPDF]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"docx";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将Word文档转换为PDF文件格式"];
            program.programColor = [UIColor colorWithRed:251/255.0 green:201/255.0 blue:89/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_PDFConvertWord]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"pdf";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将pdf文档转换为Word文件格式"];;
            program.programColor = [UIColor colorWithRed:91/255.0 green:181/255.0 blue:249/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if([programName isEqualToString:ProgramName_HTMLConvertPDF]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"pdf";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将html页面转换为PDF文件格式"];;
            program.programColor = [UIColor colorWithRed:96/255.0 green:232/255.0 blue:234/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }
    }else if([sectionName isEqualToString:ProgramSection_OFDOperation]){
        if ([programName isEqualToString:ProgramName_OFDConvertPDF]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"ofd";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将OFD文档转换为PDF文件格式"];;
            program.programColor = [UIColor colorWithRed:96/255.0 green:232/255.0 blue:234/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_OFDMerge]){
            FileMergeProgram *program = [[FileMergeProgram alloc]init];
            program.fileFilterCondition = @"ofd";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将多个OFD文件合并"];
            program.programColor = [UIColor colorWithRed:79/255.0 green:129/255.0 blue:41/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_OFDPageManager]){
            PageManageProgram *program = [[PageManageProgram alloc]init];
            program.fileFilterCondition = @"ofd";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 管理文件页面"];
            program.programColor = [UIColor colorWithRed:239/255.0 green:126/255.0 blue:121/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_WordConvertOFD]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"docx";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将Word文档转换为OFD文件格式"];
            program.programColor = [UIColor colorWithRed:96/255.0 green:232/255.0 blue:234/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_OFDConvertWord]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"ofd";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将ofd文档转换为Word文件格式"];;
            program.programColor = [UIColor colorWithRed:251/255.0 green:201/255.0 blue:89/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }
    }else if([sectionName isEqualToString:ProgramSection_AIPOperation]){
        if ([programName isEqualToString:ProgramName_AIPConvertOFD]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"aip";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将PDF文档转换为OFD文件格式"];;
            program.programColor = [UIColor colorWithRed:236/255.0 green:69/255.0 blue:41/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }else if ([programName isEqualToString:ProgramName_AIPConvertPDF]){
            FileConvertProgram *program = [[FileConvertProgram alloc]init];
            program.fileFilterCondition = @"aip";
            program.modalPresentationStyle = UIModalPresentationFullScreen;
            program.descripts = @[@"● 将PDF文档转换为OFD文件格式"];;
            program.programColor = [UIColor colorWithRed:236/255.0 green:69/255.0 blue:41/255.0 alpha:1.0];
            program.programName = programName;
            [self.window.rootViewController presentViewController:program animated:YES completion:nil];
        }
    }
}
- (void)setRootController:(UIViewController*)VC
{
    [self.window.rootViewController presentViewController:VC animated:YES completion:nil];
}

@end
