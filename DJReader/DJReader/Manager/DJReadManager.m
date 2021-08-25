//
//  DJReadManager.m
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
//
#import "DJReadManager.h"
#import <DJContents/DJContents.h>
#import "CSCoreDataManager.h"
#import "CSKeyChain.h"
#import "DJReadNetManager.h"
#import <MJExtension.h>

@interface DJReadManager()<WXApiDelegate>
@property (nonatomic, strong) NSString *authState;///微信登录状态使用
@end

@implementation DJReadManager
static DJReadManager *_manager;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

+ (DJReadManager*)shareManager
{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken,^{
         _manager = [[DJReadManager alloc]init];
     });
     return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

+ (void)loadFonts
{
//  NSString *pingFangPath = [[NSBundle mainBundle]pathForResource:@"苹方" ofType:@"ttc"];//PingFang SC
//  NSString *songTiPath = [[NSBundle mainBundle]pathForResource:@"宋体" ofType:@"ttc"];//Songti SC
    NSString *kaiTiPath = [[NSBundle mainBundle]pathForResource:@"楷体" ofType:@"ttf"];//KaiTi_GB2312
    NSString *fangSongPath = [[NSBundle mainBundle]pathForResource:@"仿宋" ofType:@"ttf"];//FZFangSong-Z02S
    NSString *yaHeiPath = [[NSBundle mainBundle]pathForResource:@"雅黑" ofType:@"ttf"];//Microsoft YaHei
    NSString *yuanTiPath = [[NSBundle mainBundle]pathForResource:@"圆体" ofType:@"ttf"];//HBXiYuanTi
    NSString *liShuPath = [[NSBundle mainBundle]pathForResource:@"隶书" ofType:@"ttf"];//FZTieJinLiShu-S17S
    NSString *xingKaiPath = [[NSBundle mainBundle]pathForResource:@"行楷" ofType:@"ttf"];//STXingkai
    NSMutableDictionary *fonts = [[NSMutableDictionary alloc]init];
//  [fonts setValue:@"宋体" forKey:songTiPath];
//  [fonts setValue:@"苹方" forKey:pingFangPath];
    [fonts setValue:@"楷体" forKey:kaiTiPath];
    [fonts setValue:@"仿宋" forKey:fangSongPath];
    [fonts setValue:@"雅黑" forKey:yaHeiPath];
    [fonts setValue:@"圆体" forKey:yuanTiPath];
    [fonts setValue:@"隶书" forKey:liShuPath];
    [fonts setValue:@"行楷" forKey:xingKaiPath];

    for (NSString *path in fonts.allKeys) {
        NSData *fontData = [[NSData alloc]initWithContentsOfFile:path];
        [DJContentView setFontData:fontData withFontName:path.lastPathComponent];
    }
}

+ (NSInteger)deviceType
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        return 0;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        return 2;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        return 1;
    }
    return 99;
}
- (BOOL)isLoging
{
    if ([CSCoreDataManager isLogin])
    {
        return YES;
    }else{
        return NO;
    }
}
+ (void)isProduct:(void(^)(BOOL isProduct))versionChecked
{
    NSString *verson = APP_VERSION;
    NSString *system = @"2";//1:安卓；2:iOS

    NSMutableDictionary *params = [NSMutableDictionary new];
    if (verson.length > 0) {
        [params setValue:verson forKey:@"version"];
    }
    if (system.length > 0) {
        [params setValue:system forKey:@"system"];
    }
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_Appversion parameters:params showError:NO reponseResult:^(DJService *service) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *data = service.dataResult;
            NSInteger code = service.code;
            if (code == 0) {
                NSString *version = [data objectForKey:@"version"];
                NSString *isCheck = [data objectForKey:@"ischeck"];
                NSString *isupdate = [data objectForKey:@"isupdate"];
                if (versionChecked) {
                    versionChecked(YES);
                }
            }else{
                if (versionChecked)
                    versionChecked(NO);
            }
        });
    }];
}
- (BOOL)isBindPhone
{
    if (_loginUser.uphone.length<11) {
        return NO;
    }
    return YES;
}

- (BOOL)isVIP
{
    if (_loginUser.isvip == 1) {
        return YES;
    }else{
        return NO;
    }
}

- (DJReadUser*)loginUser{
    if (!_loginUser) {
        _loginUser = [[CSCoreDataManager shareManager] user];
    }
    return _loginUser;
}

- (UserPreference*)preference
{
    if (!_preference) {
        _preference = [[UserPreference alloc]init];
    }
    return _preference;
}

- (void)requestUserInfo:(NSString *)phone andOpenid:(nonnull NSString *)openid complete:(nonnull void (^)(DJReadUser * _Nonnull))hander
{
    [DJReadNetShare requestUserInfo:phone andOpenid:openid complete:hander];
}

+ (DJReadUser*)loginAccount:(NSString*)account password:(NSString*)password
{
    DJReadUser *user = [[CSCoreDataManager shareManager]loginAccount:account password:password];
    if (!user) {
        //保存账号密码
        NSMutableDictionary *userProperties = [[NSMutableDictionary alloc]init];
        [userProperties setValue:@([CSSnowIDFactory shareFactory].nextID) forKey:@"id"];
        [userProperties setValue:@(0) forKey:@"status"];
        [userProperties setValue:account forKey:@"account"];
        [userProperties setValue:account forKey:@"name"];
        [userProperties setValue:account forKey:@"password"];
        [userProperties setValue:account forKey:@"uphone"];
        user = [[CSCoreDataManager shareManager]registerAccount:userProperties];
    }
    user.uphone = account;
    //从服务端拉取用户数据更新
    [DJReadNetShare requestUserInfo:user.uphone andOpenid:user.openid complete:^(DJReadUser *user) {
        [DJReadManager shareManager].loginUser = user;
        [[CSCoreDataManager shareManager]updataUserInfo:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    }];
    [[CSCoreDataManager shareManager] loginUser:user];
    [[CSCoreDataManager shareManager] cacheUser:user];
    [DJReadManager shareManager].loginUser = user;
    [DJReadManager shareManager].loginType = LoginTypeOFD;
    return user;
}

+ (DJReadUser*)loginUser:(DJReadUser*)user
{
    //登入用户，切换数据库
    [[CSCoreDataManager shareManager] loginUser:user];
    [[CSCoreDataManager shareManager] cacheUser:user];
    [DJReadManager shareManager].loginType = LoginTypeOFD;
    
    [DJReadNetShare requestUserInfo:user.uphone andOpenid:user.openid complete:^(DJReadUser *user) {
        [DJReadManager shareManager].loginUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    }];
    return user;
}

+ (DJReadUser*)loginName:(NSString*)name openID:(NSString*)openid headURL:(NSString*)headURL
{
    DJReadUser *fetchUser = [[CSCoreDataManager shareManager]loginAccount:name password:name];
    if (!fetchUser) {
        //保存账号密码
        NSMutableDictionary *userProperties = [[NSMutableDictionary alloc]init];
        [userProperties setValue:@([CSSnowIDFactory shareFactory].nextID) forKey:@"id"];
        [userProperties setValue:@(0) forKey:@"status"];
        [userProperties setValue:name forKey:@"account"];
        [userProperties setValue:name forKey:@"name"];
        [userProperties setValue:openid forKey:@"openid"];
        [userProperties setValue:headURL forKey:@"avatar"];///头像
        [userProperties setValue:@(1) forKey:@"status"];///是否已同步到服务器
        fetchUser = [[CSCoreDataManager shareManager]registerAccount:userProperties];
    }else{
        fetchUser.avatar = headURL;
        fetchUser.openid = openid;
        fetchUser.name = name;
        [[CSCoreDataManager shareManager]updataUserInfo:fetchUser];
    }
    //登入用户，切换数据库
    [[CSCoreDataManager shareManager] loginAccount:fetchUser.account password:fetchUser.password];
    [[CSCoreDataManager shareManager] cacheUser:fetchUser];
    [DJReadManager shareManager].loginUser = fetchUser;
    [DJReadManager shareManager].loginType = LoginTypeWechat;
    
    [DJReadNetShare requestUserInfo:fetchUser.uphone andOpenid:fetchUser.openid complete:^(DJReadUser *user) {
        [DJReadManager shareManager].loginUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    }];
    
    return fetchUser;
}

- (NSDictionary*)appleUserInfo
{
    return [CSKeyChain appleUserInfo];
}
- (void)saveMsg:(NSString*)value forKey:(NSString*)key
{ 
    [CSKeyChain saveMsg:value forKey:key];
}
- (APPPreference*)appPreference
{
    if (!_appPreference) {
        _appPreference = [[APPPreference alloc]init];
    }
    return _appPreference;
}
+ (void)sendAuthRequestScope:(NSString *)scope
                           State:(NSString *)state
                          OpenID:(NSString *)openID
              InViewController:(UIViewController *)viewController
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    [WXApi sendAuthReq:req
        viewController:viewController
              delegate:[DJReadManager shareManager]
            completion:^(BOOL success) {
        NSLog(@"%d",success);
    }];
}
///微信登录回调
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    }
}
//判断用户状态
- (void)judgeUser:(void(^)(BOOL isLogin))status bindIPhone:(void (^)(BOOL bind))bind isVIP:(void(^)(BOOL isVIP))isVIP
{
    if ([self isLoging]) {//先判断是否登录
        if (status) status(YES);
        if ([self isBindPhone]) {//判断是否绑定设备
            if (bind) bind(YES);
            if (isVIP) isVIP([self isVIP]);
        }else{//未绑定的话，肯定不是VIP
            if (bind) bind(NO);
        }
    }else{//未登录的话，肯定不是VIP和没绑定手机号
        if (status) status(NO);
    }
}
@end

@implementation DJReaderConfig

@end
