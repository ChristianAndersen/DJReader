//
//  AppDelegate.h
//  DJReader
//
//  Created by Andersen on 2020/3/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow * window;

@property (assign, nonatomic) BOOL shouldLandscape;

- (void)gotoMainRootController;
- (void)gotoLoginControllerFrom:(id)parentVC;
- (void)gotoBindPhoneControllerFrom:(id)parentVC;
- (void)gotoSubcribeControllerFrom:(id)parentVC;
- (void)launchingProgram:(NSString*)programName programSection:(NSString*)sectionName;//跳转到某个小程序
- (void)setRootController:(UIViewController*)VC;//把某个控制器设为窗口的根控制器
@end

/**
 测试账户
 app账户：18799151515 密码：151515
 购买测试账户：18799151515@qq.com 密码：Dianju151515  需要手机切换Apple id
 百度SDK账户：18633520808 密码：Dianju5678
 审核版本管理地址：http://ofd365.dianju.cn/sso/sso/version/app-version.html
 
 
 
 */
//微信appid
//public static final String APP_ID = "wxd60e5a883ae5d4fc";
//微信appSecret
//public static String APP_SECRET = "8217269e8be086e071dcaea9cdf07db0";
