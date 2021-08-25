//
//  LoginDistributionController.m
//  DJReader
//
//  Created by Andersen on 2020/9/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "LoginDistributionController.h"
#import "DJReadNetManager.h"
#import "LoginViewController.h"

#define Distribution_Interval 30
@interface LoginDistributionController ()<DJReadManagerWXDelegate>
@property (nonatomic,strong) LoginViewController * loginVc;
@end

@implementation LoginDistributionController
- (void)viewDidLoad {
   [super viewDidLoad];
    [self loadSubviews];
}
- (void)loadSubviews
{
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录背景"]];
    backView.frame = self.view.bounds;
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    UIButton *back = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        btn;
    });
    [backView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(64);
        make.left.equalTo(backView).offset(20);
        make.width.mas_equalTo(@(30));
        make.height.mas_equalTo(@(30));
    }];
    
    UIImage *appNameImage = [UIImage imageNamed:@"appName"];
    CGFloat width = 300;
    CGFloat height = 300*appNameImage.size.height/appNameImage.size.width;
    UIImageView *appIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认头像"]];
    appIcon.contentMode = 1;
    [backView addSubview:appIcon];
    
    UIImageView *appName = [[UIImageView alloc]initWithImage:appNameImage];
    appName.contentMode = 1;
    [backView addSubview:appName];
    
    [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(64);
        make.centerX.equalTo(backView);
        make.width.mas_equalTo(@(64));
        make.height.mas_equalTo(@(64));
    }];
    [appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appIcon.mas_bottom).offset(44);
        make.centerX.equalTo(backView);
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(@(height));
    }];
    
    UIButton *weChat = ({
        NSMutableAttributedString *btnAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"\t\t微信登录"];
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"微信_白色"];
        attach.bounds = CGRectMake(0, -5, 25, 25);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [btnAttributeStr insertAttributedString:imageStr atIndex:0];
        
        NSMutableParagraphStyle *btnParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        btnParagraphStyle.alignment = NSTextAlignmentCenter;
        [btnAttributeStr addAttribute:NSParagraphStyleAttributeName value:btnParagraphStyle range:NSMakeRange(0, 7)];
        [btnAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, 4)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor =  RGBACOLOR(24, 178, 108, 1.0);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0;
        [btn setAttributedTitle:btnAttributeStr forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginForWeChat) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:weChat];
    [weChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appName.mas_bottom).offset(44);
        make.centerX.equalTo(backView);
        make.width.equalTo(appName);
        make.height.equalTo(@(44));
    }];
    UIButton *login = ({
        NSMutableAttributedString *btnAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"\t\t手机登录"];
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"手机_白色"];
        attach.bounds = CGRectMake(0, -5, 25, 25);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [btnAttributeStr insertAttributedString:imageStr atIndex:0];
        
        NSMutableParagraphStyle *btnParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        btnParagraphStyle.alignment = NSTextAlignmentCenter;
        [btnAttributeStr addAttribute:NSParagraphStyleAttributeName value:btnParagraphStyle range:NSMakeRange(0, 7)];
        [btnAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, 4)];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor =  RGBACOLOR(24, 132, 231, 1.0);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0;
        [btn setAttributedTitle:btnAttributeStr forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoLoginController) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weChat.mas_bottom).offset(20);
        make.centerX.equalTo(backView);
        make.width.equalTo(appName);
        make.height.equalTo(@(44));

    }];

}
- (void)loginForWeChat
{
    if (![WXApi isWXAppInstalled]) {
        ShowMessage(@"提示", @"您未安装微信请去AppStore下载", self);
        return;
    }
    [DJReadManager shareManager].delegate = self;
    [DJReadManager sendAuthRequestScope:@"snsapi_userinfo" State:@"XXX" OpenID:WeChat_AppSecret InViewController:self];
}
- (void)gotoLoginController
{
    self.loginVc = [[LoginViewController alloc]init];
    self.loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
    self.loginVc.originController = self.originController;
    [self presentViewController:self.loginVc animated:YES completion:nil];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
        NSString *code = response.code;
        NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChat_APPID,WeChat_AppSecret,code];
        NSURL *url = [NSURL URLWithString:urlString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *openID = [dict objectForKey:@"openid"];
            NSString *token = [dict objectForKey:@"access_token"];
            
            NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID];
            NSURL *userUrl = [NSURL URLWithString:urlString];
            NSString *userStr = [NSString stringWithContentsOfURL:userUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *userData = [userStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data){
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
                    if ([userInfo objectForKey:@"errcode"]){
                    }else{
                        NSString *headURL = [userInfo objectForKey:@"headimgurl"];
                        NSString *openid = [userInfo objectForKey:@"openid"];
                        NSString *name = [userInfo objectForKey:@"nickname"];
                        NSString *sex = [userInfo objectForKey:@"sex"];
                        NSMutableDictionary *parm = [NSMutableDictionary new];
                        [parm setValue:headURL forKey:@"headimgur"];
                        [parm setValue:name forKey:@"nickname"];
                        [parm setValue:sex forKey:@"sex"];
                        [parm setValue:openid forKey:@"openid"];
                    
                        NSString *tcode = [self getTcode];
                        if (tcode) [parm setValue:tcode forKey:@"tcode"];
                        
                        ///后台微信登录
                        [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_LoginWechat parameters:parm reponseResult:^(DJService *service) {
                            if (service.code == 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [DJReadManager loginName:name openID:openid headURL:headURL];
                                    [self sendPasteBoardMessage];
                                });
                            }else{
                                ShowMessage(@"", @"登录失败，请重试", RootController);
                            }
                            [self back];
                        }];
                    }
                }
            });
        });
}
- (NSString*)getTcode{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *text = [NSString stringWithFormat:@"粘贴内容：%@",pasteBoard.string];
    if (text.length <= 12)//"粘贴内容：dianju_"长度最少12
        return nil;
    
    NSString *pasteStr = [text substringFromIndex:5];
    NSString *startStr = [pasteStr substringToIndex:7];

    if ([startStr isEqualToString:@"dianju_"]) {
        NSString *tCodeBase64 = [pasteStr substringFromIndex:7];
        NSData *tCodeData = [[NSData alloc]initWithBase64EncodedString:tCodeBase64 options:0];
        NSString *tCode = [[NSString alloc]initWithData:tCodeData encoding:NSUTF8StringEncoding];
        return tCode;
    }
    return nil;
}
//用于给账户送会员
- (void)sendPasteBoardMessage{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *text = [NSString stringWithFormat:@"粘贴内容：%@",pasteBoard.string];
    if (text.length <= 12)//"粘贴内容：dianju_"长度最少12
        return;
    
    NSString *pasteStr = [text substringFromIndex:5];
    NSString *startStr = [pasteStr substringToIndex:7];

    if ([startStr isEqualToString:@"dianju_"]) {
        NSString *tCodeBase64 = [pasteStr substringFromIndex:7];
        NSData *tCodeData = [[NSData alloc]initWithBase64EncodedString:tCodeBase64 options:0];
        NSString *tCode = [[NSString alloc]initWithData:tCodeData encoding:NSUTF8StringEncoding];
        ShowMessage(@"粘贴板内容", tCode, RootController);
        
        [DJReadNetShare requestAFN:DJNetPOST urlString:@"" parameters:nil reponseResult:^(DJService *service) {

        }];
    }
}
@end
