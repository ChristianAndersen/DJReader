//
//  CSTabBarController.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTabBarMainController.h"
#import "DJFolderTableViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "DJFilesSearchController.h"
#import "FileEditorController.h"
#import "CSTabBarItem.h"
#import "MainController.h"
#import "SmallProgramMainController.h"
#import "UserController.h"
#import "DJFileManager.h"
#import "CSCoreDataManager.h"
#import "DJReadNetManager.h"
#import "CSSheetManager.h"
#import "SubscribeController.h"
#import "BindPhoneController.h"
#import "FileBrowseController.h"

@interface CSTabBarMainController()
@end

@implementation CSTabBarMainController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    #ifdef DEBUG
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    #endif
    [self setViewControllers];
}
- (void)setViewControllers{
    MainController * mainViewVc = [MainController new];
    mainViewVc.originController = self;
    UINavigationController *navMain = [[UINavigationController alloc]initWithRootViewController:mainViewVc];
    
    UserController * userViewVc = [UserController new];
    userViewVc.originController = self;
    UINavigationController *navUser = [[UINavigationController alloc]initWithRootViewController:userViewVc];
    
    SmallProgramMainController *programVc = [SmallProgramMainController new];
    programVc.originController = self;
    UINavigationController *navProgram = [[UINavigationController alloc]initWithRootViewController:programVc];
    
    DJFolderTableViewController * folderTableVc = [DJFolderTableViewController new];
    folderTableVc.originController = self;
    UINavigationController *navFolder = [[UINavigationController alloc]initWithRootViewController:folderTableVc];
    
    if (@available(iOS 13.0, *)) {
        navMain.navigationBar.backgroundColor = [UIColor systemBackgroundColor];
        navUser.navigationBar.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        navMain.navigationBar.backgroundColor = [UIColor whiteColor];
        navUser.navigationBar.backgroundColor = [UIColor whiteColor];
    }
    [self setViewControllers:@[navMain,navFolder,navProgram,navUser]];
    [self customizeTabBarForController];
    self.delegate = self;
}
- (void)customizeTabBarForController{
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"Main",@"Document",@"Program", @"Me"];
    NSArray *tabBarItemTitles = @[@"主页",@"文档",@"应用", @"我的"];
    
    NSInteger index = 0;
    for (CSTabBarItem *item in [[self tabBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        if (@available(iOS 13.0, *)) {
            [item setBadgeBackgroundColor:[UIColor systemBackgroundColor]];
        } else {
            [item setBadgeBackgroundColor:[UIColor blackColor]];
        }
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index ]];
        index++;
    }
}
- (void)setShareFileURL:(NSURL *)shareFileURL
{
    NSString *sourcePath = shareFileURL.path;
    DJFileDocument *file = [[CSCoreDataManager shareManager] writeSourceFile:sourcePath];
    [self openFile:file];
}
- (void)convertFile:(DJFileDocument*)file toFormat:(NSString*)format
{
    [DJFileManager judgeFile:file.filePath support:^{
        [self openFile:file];
    } unSupport:^{
        [[DJReadManager shareManager] judgeUser:^(BOOL isLogin) {
            if (!isLogin) {GotoLoginControllerFrom(self);}
        } bindIPhone:^(BOOL bind) {
            if (!bind) {
                BindPhoneController *bindVC = [[BindPhoneController alloc]init];
                UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:bindVC];
                navc.modalPresentationStyle = 0;
                [self presentViewController:navc animated:YES completion:nil];
                //showAlert(@"当前文件格式需要转换，是会员功能，需要绑定手机开通会员", self);
            }
        } isVIP:^(BOOL isVIP) {
            if (isVIP) {
                NSString *fileName = [[[file.filePath lastPathComponent] componentsSeparatedByString:@"#"]lastObject];
                fileName = [[[fileName componentsSeparatedByString:@"."] firstObject]stringByAppendingFormat:@".%@",format];
                //需要转换后才能打开的文件
                [CSSheetManager showHud:@"正在转换文件格式,请稍等" atView:self.view];
                [DJReadNetShare convertFile:file.filePath returnType:format complete:^(NSString *errMsg, NSString *fileBase64) {
                    [CSSheetManager hiddenHud];
                    if (errMsg) {
                        showAlert(errMsg, self);
                    }else{
                        NSData *fileData = [[NSData alloc] initWithBase64EncodedString:fileBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:fileName];
                        [fileData writeToFile:convertPath atomically:YES];
                        [self openFile:file];
                    }
                }];
            }else{
                SubscribeController *subscribeController = [SubscribeController new];
                subscribeController.originController = self;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:subscribeController];
                nav.modalPresentationStyle = 0;
                [self presentViewController:nav animated:YES completion:nil];
                //showAlert(@"当前文件格式需要转换，需要开通会员", self);
            }
        }];
    } unKnown:^{
        //不支持的文件
        NSString * str = @"不支持此格式文件";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}
- (void)openFile:(DJFileDocument *)file
{
    if ([file.filePath.pathExtension isEqualToString:OFDFileExt]||[file.filePath.pathExtension isEqualToString:PDFFileExt]||[file.filePath.pathExtension isEqualToString:AIPFileExt]) {
        FileEditorController *fileEditor = [[FileEditorController alloc]init];
        fileEditor.modalPresentationStyle = 0;
        fileEditor.file = file;
        fileEditor.originController = self;
        [self presentViewController:fileEditor animated:YES completion:nil];
    }else{
        FileBrowseController *browseController = [[FileBrowseController alloc]init];
        browseController.file = file;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:browseController];
        navc.modalPresentationStyle = 0;
        [self presentViewController:navc animated:YES completion:nil];
    }
}

#pragma mark RDVTabBarControllerDelegate
- (BOOL)tabBarController:(CSTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
 
    }
    return YES;
}
@end
    
