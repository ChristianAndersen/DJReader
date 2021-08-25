//
//  DJReadManager.h
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
#import <Foundation/Foundation.h>
#import "DJReadUser.h"
#import "APPPreference.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "DJCertificate.h"
#import "DJSignSeal.h"
NS_ASSUME_NONNULL_BEGIN

@interface DJReaderConfig : NSObject
@property (nonatomic,copy)NSString *appKey;
@property (nonatomic,copy)NSString *appVersion;
@property (nonatomic,copy)NSString *appValue;
@property (nonatomic,copy)NSString *lasttime;
@property (nonatomic,copy)NSString *coId;
@property (nonatomic,copy)NSString *appType;
@property (nonatomic,copy)NSString *firsttime;
@property (nonatomic,copy)NSString *appStatus;
@end

#pragma 微信登录
@protocol DJReadManagerWXDelegate <NSObject>
@optional
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;
@end

@interface DJReadManager : NSObject<WXApiDelegate>
@property (nonatomic,strong)DJReadUser *loginUser;
@property (nonatomic,assign)BOOL isLoging,isVIP,isBindPhone;
@property (nonatomic,assign)LoginType loginType;
@property (nonatomic,strong)APPPreference *appPreference;
@property (nonatomic,strong)UserPreference *preference;
@property (nonatomic,strong)DJCertificate * __nullable curCertificate;
@property (nonatomic,strong)DJSignSeal *curSeal;

@property (nonatomic, assign) id<DJReadManagerWXDelegate> delegate;

+ (DJReadManager*)shareManager;
+ (void)loadFonts;
+ (NSInteger)deviceType;
+ (void)isProduct:(void(^)(BOOL isProduct))versionChecked;
+ (DJReadUser*)loginAccount:(NSString*)account password:(NSString*)password;
+ (DJReadUser*)loginName:(NSString*)name openID:(NSString*)openid headURL:(NSString*)headURL;///第三方信息登录
+ (DJReadUser*)loginUser:(DJReadUser*)user;

///请求用户信息
- (void)requestUserInfo:(NSString *)phone andOpenid:(NSString*)openid complete:(void(^)(DJReadUser*user))hander;

- (NSDictionary*)appleUserInfo;
- (void)saveMsg:(NSString*)value forKey:(NSString*)key;
+ (void)sendAuthRequestScope:(NSString *)scope
                           State:(NSString *)state
                          OpenID:(NSString *)openID
              InViewController:(UIViewController *)viewController;

- (void)judgeUser:(void(^)(BOOL isLogin))status bindIPhone:(void (^)(BOOL bind))bind isVIP:(void(^)(BOOL isVIP))isVIP;
@end



NS_ASSUME_NONNULL_END
