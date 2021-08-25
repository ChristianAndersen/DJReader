//
//  InvitationController.m
//  DJReader
//
//  Created by Andersen on 2021/8/17.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "InvitationController.h"
#import "CSWXAPIManager.h"

@interface InvitationController ()

@end

@implementation InvitationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"活动详情"];
    [self.view addSubview:backView];
    [self loadSubView];
}
- (void)loadSubView
{
    UIButton *friend = ({
        UIButton *btn = [[UIButton alloc]init];
        btn;
    });
    [friend setImage:[UIImage imageNamed:Action_ShareFriend] forState:UIControlStateNormal];
    [friend addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friend];
    friend.tag = 0;
    [friend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-100);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    UIButton *forum = ({
        UIButton *btn = [[UIButton alloc]init];
        btn;
    });
    [forum setImage:[UIImage imageNamed:Action_ShareForum] forState:UIControlStateNormal];
    forum.tag = 1;
    [forum addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forum];
    [forum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(100);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
}
- (void)invitation:(UIButton*)sender
{
    if (![[DJReadManager shareManager].loginUser.uphone isPhone]) {
        GotoBindPhoneControllerFrom(self);
    }else{
        NSString *phoneNum = [DJReadManager shareManager].loginUser.uphone;
        NSData *phoneData = [[NSData alloc]initWithBase64EncodedString:phoneNum options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *tCode = [[NSString alloc]initWithData:phoneData encoding:NSUTF8StringEncoding];
        NSString *urlStr = [[NSString alloc]initWithFormat:ShareInvitaitionURL,tCode];
        //NSString *urlStr2 = @"http://www.baidu.com?tCode=MTUwMDEzODkxNjk=";
        [[CSWXAPIManager sharedManager] sendLinkContent:urlStr
                                                Title:@"邀请好友得会员"
                                          Description:@"邀请三个好友下载登录即可获得一年会员"
                                              AtScene:(int)sender.tag completion:nil];
    }
}

@end
