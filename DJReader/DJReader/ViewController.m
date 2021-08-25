//
//  ViewController.m
//  DJReader
//
//  Created by Andersen on 2020/3/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#define Interval 20
@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat lineWidth = (self.view.width - Interval*5)/2;

    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *authorizationButton = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhiteOutline];
                
        [authorizationButton addTarget:self action:@selector(login_Apple) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:authorizationButton];
        [authorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
                make.right.equalTo(self.view).offset(-lineWidth*0.6);
                make.width.mas_equalTo(@(Interval*6));
                make.height.mas_equalTo(@(Interval*2));
        }];
    } else {
    
    }
    UIButton *login_apple = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"苹果账户登录" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"橡皮_selected"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(login_Apple) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:login_apple];
    [login_apple mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-Interval);
        make.right.equalTo(self.view).offset(-lineWidth*0.8);
        make.width.mas_equalTo(@(Interval*3));
        make.height.mas_equalTo(@(Interval*4));
    }];
    login_apple.titleLabel.font = [UIFont systemFontOfSize:10];
    login_apple.imageEdgeInsets = UIEdgeInsetsMake(Interval/2, Interval/2, Interval*1.5, Interval/2);
    login_apple.titleEdgeInsets = UIEdgeInsetsMake(Interval*2.5, -Interval*2.5, 1.0, -Interval/2);
}
- (void)login_Apple
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
        ASAuthorizationPasswordRequest *passwordRequest = [[[ASAuthorizationPasswordProvider alloc]init] createRequest];
        [request setRequestedScopes:@[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail]];
        ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request,passwordRequest]];
        auth.delegate = self;
        auth.presentationContextProvider = self;
        [auth performRequests];
    } else {
        showAlert(@"iOS 13 以下的系统不支持apple 账户登录",self)
    }
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}

-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
        if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
            ASAuthorizationAppleIDCredential *credential = authorization.credential;
            NSString *userID = credential.user;
            NSPersonNameComponents *fullName = credential.fullName;
            NSString *name = [NSString stringWithFormat:@"%@%@",fullName.familyName,fullName.givenName];
            NSString *email = credential.email;
            NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
            NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
            NSDictionary *appleInfo = [[DJReadManager shareManager]appleUserInfo];
            
            if (!appleInfo) {
                [[DJReadManager shareManager]saveMsg:userID forKey:KEYCHAIN_USERID] ;
                [[DJReadManager shareManager]saveMsg:email forKey:KEYCHAIN_EMAIL];
                [[DJReadManager shareManager]saveMsg:authorizationCode forKey:KEYCHAIN_AUTHORIZATIONCODE];
                [[DJReadManager shareManager]saveMsg:identityToken forKey:KEYCHAIN_IDENTITYTOKEN];
                [[DJReadManager shareManager]saveMsg:name forKey:KEYCHAIN_USERNAME];
            }
        }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
            ASPasswordCredential *pass = authorization.credential;
    
            NSString *username = pass.user;
            NSString *password = pass.password;
            NSDictionary *appleInfo = [[DJReadManager shareManager]appleUserInfo];
            if (!appleInfo) {
                [[DJReadManager shareManager]saveMsg:username forKey:KEYCHAIN_USERID] ;
                [[DJReadManager shareManager]saveMsg:password forKey:KEYCHAIN_USERNAME];
            }
        }
}

///回调失败
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"Handle error：%@", error);
    NSString*errorMsg =nil;
    switch(error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg =@"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg =@"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg =@"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg =@"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg =@"授权请求失败未知原因";
            break;
        default:
            break;
    }
}
//


- (void)UTLSFileOpenNotification:(NSNotification*)notification
{
}

@end
