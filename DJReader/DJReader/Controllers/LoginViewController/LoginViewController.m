//
//  LoginViewController.m
//  DJReader
//
//  Created by liugang on 2020/4/30.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "LoginViewController.h"
#import "CQCountDownButton.h"
#import "DJReadNetManager.h"
#import "CSCoreDataManager.h"
#import "DJReadManager.h"
#import "CSSnowIDFactory.h"
#import "UserController.h"
#import "AppDelegate.h"
#define Interval 20

@interface LoginViewController ()<CQCountDownButtonDataSource, CQCountDownButtonDelegate,WXApiDelegate,DJReadManagerWXDelegate>

#pragma mark - 登录
@property (nonatomic,strong)UIView * loginView;
@property (nonatomic,strong)UITextField * loginVerificationTF;
@property (nonatomic,strong)UIButton * registeredBtn;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UITextField * accountTextField;
@property (nonatomic,strong)UITextField * passwordTextField;
@property (nonatomic, strong)CQCountDownButton *loginCountDownButton;
@property (nonatomic, strong)UIView *view1;
@property (nonatomic, strong)UIView *view2;

#pragma mark - 注册
@property (nonatomic,strong)UIView * registeredView;
@property (nonatomic,strong)UITextField * regAccTextField;
@property (nonatomic,strong)UITextField * regPwTextField;
@property (nonatomic,strong)UITextField * verificationTextField;
@property (nonatomic,strong)UIButton * confirmBtn;
@property (nonatomic,strong) CQCountDownButton *countDownButton;

@property (nonatomic,assign)BOOL isRegistered;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //禁用夜间模式
    if (@available(iOS 13.0, *)) {
       self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
       self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    [self setLoginView];
    self.originController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    //键盘的弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //键盘的消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.isRegistered = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.originController.navigationController.navigationBarHidden = NO;
    self.originController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
}

-(void)setLoginView{
    if ([DJReadManager deviceType] == 0) {
        [self.view addSubview:self.loginView];
        [self.view addSubview:self.registeredView];
    }else{
        [self.view addSubview:[self loginView_iPad]];
        [self.view addSubview:[self registeredView_iPad]];
    }
}

#pragma mark - 登录页
- (UIView *)loginView_iPad
{
    if (_loginView == nil) {
        _loginView = [[UIView alloc]initWithFrame:self.view.frame];
        _loginView.backgroundColor = [UIColor whiteColor];
        //返回
        UIButton * returnBtn =[[UIButton alloc]init];
        [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnUserVC) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginView).mas_equalTo(Interval*3);
            make.left.equalTo(self.loginView).mas_equalTo(Interval);
            make.height.width.mas_equalTo(Interval);
        }];
        
        //背景图
        UIImageView * loginBackview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dj_loginbeijin"]];
        [_loginView addSubview:loginBackview];
        
        [loginBackview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginView).offset(120);
            make.centerX.equalTo(self.loginView);
            make.width.mas_equalTo(kFrame_width/2);
            make.height.mas_equalTo(kFrame_width/2);
        }];
        
        //分割线
        UIView * noteView = [[UIView alloc]init];
        noteView.backgroundColor = [UIColor lightGrayColor];
        [_loginView addSubview:noteView];
        [noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(loginBackview.mas_bottom).mas_equalTo(-Interval);
            make.left.equalTo(loginBackview).mas_equalTo(-40);
            make.right.equalTo(loginBackview).mas_equalTo(40);
            make.height.mas_equalTo(1);
        }];
        //验证码登录标签
        UILabel * loginLabel = [[UILabel alloc]init];
        loginLabel.text = @"登录";
        loginLabel.textColor = RGBACOLOR(45, 121, 220, 1);
        loginLabel.font = [UIFont systemFontOfSize:20];
        [_loginView addSubview:loginLabel];
        [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(noteView).mas_equalTo(-10);
            make.left.equalTo(noteView);
        }];
        //添加点击事件
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginlabelClick)];
        loginLabel.userInteractionEnabled = YES;
        [loginLabel addGestureRecognizer:labelTapGestureRecognizer];
        //选中
        self.view1 = [UIView new];
        self.view1.backgroundColor = RGBACOLOR(45, 121, 220, 1);
        [_loginView addSubview:self.view1];
        [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(noteView);
            make.width.left.equalTo(loginLabel);
            make.height.mas_equalTo(2.5f);
        }];
        
        //注册按钮
        UIButton * signUpButton = [UIButton new];
        [signUpButton setTitleColor:RGBACOLOR(45, 121, 220, 1) forState:UIControlStateNormal];
        [signUpButton setTitle:@"注册" forState:UIControlStateNormal];
        signUpButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [signUpButton addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:signUpButton];
        [signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(noteView.mas_bottom).mas_equalTo(-5);
            make.right.equalTo(noteView.mas_right).mas_equalTo(-15);
        }];
        
        //账号
        self.accountTextField = [[UITextField alloc]init];
        self.accountTextField.placeholder = @"手机号/邮箱";
        self.accountTextField.backgroundColor = RGBAColor(247,248,249,1);
        [_loginView addSubview:self.accountTextField];
        [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noteView).mas_equalTo(35);
            make.width.left.mas_equalTo(noteView);
            make.height.mas_equalTo(40);
         }];
         //验证码
         self.loginVerificationTF = [UITextField new];
         self.loginVerificationTF.placeholder = @"请输入验证码";
         self.loginVerificationTF.backgroundColor = RGBAColor(247,248,249,1);
         self.loginVerificationTF.contentMode = UIViewContentModeScaleAspectFit;

         [_loginView addSubview:self.loginVerificationTF];
         [self.loginVerificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.accountTextField.mas_bottom).mas_equalTo(20);
             make.left.width.height.mas_equalTo(self.accountTextField);
         }];
         
         //倒计时按钮
         self.loginCountDownButton = [[CQCountDownButton alloc] init];
         self.loginCountDownButton.layer.masksToBounds = YES;
         self.loginCountDownButton.layer.cornerRadius = 5.f;
         self.loginCountDownButton.layer.borderWidth = .5f;
         self.loginCountDownButton.layer.borderColor = RGBACOLOR(90, 90, 90, 1).CGColor;
         [self.loginCountDownButton setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
         self.loginCountDownButton.backgroundColor = RGBACOLOR(236, 237, 238, 1);
         [self.loginCountDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
         self.loginCountDownButton.titleLabel.font = [UIFont systemFontOfSize:15];

         self.loginCountDownButton.dataSource = self;
         self.loginCountDownButton.delegate = self;
         [_loginView addSubview:self.loginCountDownButton];
         [self.loginCountDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.bottom.equalTo(self.loginVerificationTF).mas_equalTo(-2);
             make.top.equalTo(self.loginVerificationTF).mas_equalTo(2);
             make.width.mas_equalTo(100);
         }];
        
        //密码
        self.passwordTextField = [[UITextField alloc]init];
        self.passwordTextField.placeholder = @"密码";
        self.passwordTextField.backgroundColor = RGBAColor(247,248,249,1);
        self.passwordTextField.hidden = YES;
        [_loginView addSubview:self.passwordTextField ];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTextField.mas_bottom).mas_equalTo(Interval);
            make.left.width.height.mas_equalTo(self.accountTextField);
        }];
        
        //登录按钮
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.backgroundColor = RGBACOLOR(45, 121, 220, 1);
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.cornerRadius = 5.f;
        [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginVerificationTF.mas_bottom).mas_equalTo(Interval);
            make.left.width.height.mas_equalTo(self.accountTextField);
        }];
//        [self addWeChatView];
    }
    return _loginView;
}

- (UIView *)loginView{
    if (_loginView == nil) {
        _loginView = [[UIView alloc]initWithFrame:self.view.frame];
        _loginView.backgroundColor = [UIColor whiteColor];
        //返回
        UIButton * returnBtn =[[UIButton alloc]init];
        [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnUserVC) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginView).mas_equalTo(60);
            make.left.equalTo(self.loginView).mas_equalTo(Interval);
            make.height.width.mas_equalTo(Interval);
        }];
        
        //背景图
        UIImageView * loginBackview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dj_loginbeijin"]];
        [_loginView addSubview:loginBackview];
        [loginBackview mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.left.equalTo(self.loginView);
             make.height.width.mas_equalTo(self.loginView.width);
        }];
        //分割线
        UIView * noteView = [[UIView alloc]init];
        noteView.backgroundColor = [UIColor clearColor];
        [_loginView addSubview:noteView];
        [noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(loginBackview.mas_bottom).mas_equalTo(-Interval*3);
            make.left.equalTo(self.loginView).mas_equalTo(40);
            make.right.equalTo(self.loginView).mas_equalTo(-40);
            make.height.mas_equalTo(1);
        }];
        //账号
        self.accountTextField = [[UITextField alloc]init];
        self.accountTextField.placeholder = @"手机号/邮箱";
        self.accountTextField.backgroundColor = RGBAColor(247,248,249,1);
        [_loginView addSubview:self.accountTextField];
        [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noteView).mas_equalTo(35);
            make.width.left.mas_equalTo(noteView);
            make.height.mas_equalTo(40);
         }];
         //验证码
         self.loginVerificationTF = [UITextField new];
         self.loginVerificationTF.placeholder = @"请输入验证码";
         self.loginVerificationTF.backgroundColor = RGBAColor(247,248,249,1);
         self.loginVerificationTF.contentMode = UIViewContentModeScaleAspectFit;

         [_loginView addSubview:self.loginVerificationTF];
         [self.loginVerificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.accountTextField.mas_bottom).mas_equalTo(Interval);
             make.left.width.height.mas_equalTo(self.accountTextField);
         }];
         
         //倒计时按钮
         self.loginCountDownButton = [[CQCountDownButton alloc] init];
         self.loginCountDownButton.layer.masksToBounds = YES;
         self.loginCountDownButton.layer.cornerRadius = 5.f;
         self.loginCountDownButton.layer.borderWidth = .5f;
         self.loginCountDownButton.layer.borderColor = RGBACOLOR(90, 90, 90, 1).CGColor;
         [self.loginCountDownButton setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
         self.loginCountDownButton.backgroundColor = RGBACOLOR(236, 237, 238, 1);
         [self.loginCountDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
         self.loginCountDownButton.titleLabel.font = [UIFont systemFontOfSize:15];

         self.loginCountDownButton.dataSource = self;
         self.loginCountDownButton.delegate = self;
         [_loginView addSubview:self.loginCountDownButton];
         [self.loginCountDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.bottom.equalTo(self.loginVerificationTF).mas_equalTo(-2);
             make.top.equalTo(self.loginVerificationTF).mas_equalTo(2);
             make.width.mas_equalTo(100);
         }];
        
        //密码
        self.passwordTextField = [[UITextField alloc]init];
        self.passwordTextField.placeholder = @"密码";
        self.passwordTextField.backgroundColor = RGBAColor(247,248,249,1);
        self.passwordTextField.hidden = YES;
        [_loginView addSubview:self.passwordTextField ];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTextField.mas_bottom).mas_equalTo(Interval);
            make.left.width.height.mas_equalTo(self.accountTextField);
        }];
        
        //登录按钮
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.backgroundColor = RGBACOLOR(45, 121, 220, 1);
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.cornerRadius = 5.f;
        [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginVerificationTF.mas_bottom).mas_equalTo(Interval);
            make.left.width.height.mas_equalTo(self.accountTextField);
        }];
//        [self addWeChatView];
    }
    return _loginView;
}
//- (void)addWeChatView
//{
//    //按钮长宽
//    CGFloat lineWidth = (self.loginView.width - Interval*5)/2;
//    UIButton * login_WeChat = ({
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"微信账户登录" forState:UIControlStateNormal];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(login_Wechat) forControlEvents:UIControlEventTouchUpInside];
//        btn;
//    });
//    [_loginView addSubview:login_WeChat];
//    [login_WeChat mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.loginView).offset(-Interval);
//        make.centerX.equalTo(self.loginView);
//        make.width.mas_equalTo(@(Interval*2));
//        make.height.mas_equalTo(@(Interval*3));
//    }];
//    login_WeChat.titleLabel.font = [UIFont systemFontOfSize:8];
//    login_WeChat.imageEdgeInsets = UIEdgeInsetsMake(1.0, -1, Interval, 1);
//    login_WeChat.titleEdgeInsets = UIEdgeInsetsMake(Interval*2, -Interval*3, 1.0, -Interval);
//
//    UILabel *tipLab = [[UILabel alloc]init];
//    tipLab.textAlignment = NSTextAlignmentCenter;
//    tipLab.text = @"其他登陆方式";
//    tipLab.font = [UIFont systemFontOfSize:10];
//    tipLab.textColor = CSTextColor;
//    [_loginView addSubview:tipLab];
//    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(login_WeChat.mas_top).offset(-Interval/2);
//        make.centerX.equalTo(self.loginView);
//        make.width.mas_equalTo(Interval*4);
//        make.height.mas_equalTo(@(20));
//    }];
//
//    UILabel *leftLine = [[UILabel alloc]init];
//    UILabel *rightLine = [[UILabel alloc]init];
//    leftLine.backgroundColor = CSTextColor;
//    rightLine.backgroundColor = CSTextColor;
//    [_loginView addSubview:leftLine];
//    [_loginView addSubview:rightLine];
//    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(tipLab);
//        make.left.equalTo(self.loginView).offset(Interval);
//        make.width.mas_equalTo(@(lineWidth));
//        make.height.mas_equalTo(@(0.5));
//    }];
//    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(tipLab);
//        make.right.equalTo(self.loginView).offset(-Interval);
//        make.width.mas_equalTo(@(lineWidth));
//        make.height.mas_equalTo(@(0.5));
//    }];
//
//}
#pragma mark - 注册页
- (UIView *)registeredView{
    if (_registeredView == nil) {
        _registeredView = [[UIView alloc]initWithFrame:self.view.frame];
        _registeredView.backgroundColor = [UIColor whiteColor];
        _registeredView.hidden = YES;
        
        //背景图
        UIImageView * backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dj_zhucebeijin"]];
        backView.contentMode = UIViewContentModeScaleAspectFit;
        [_registeredView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(self.registeredView);
        }];
        
        //返回
        UIButton * returnBtn =[[UIButton alloc]init];
        [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
        [_registeredView addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registeredView).mas_equalTo(60);
            make.left.equalTo(self.registeredView).mas_equalTo(20);
            make.height.width.mas_equalTo(20);
        }];

        //密码
        self.regPwTextField = [UITextField new];
        self.regPwTextField.placeholder = @"请设置您的密码";
        self.regPwTextField.backgroundColor = [UIColor whiteColor];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView.image = [UIImage imageNamed:@"dj_mima"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];

        self.regPwTextField.leftView = view;
        self.regPwTextField.leftViewMode = UITextFieldViewModeAlways;
        self.regPwTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.regPwTextField.layer.cornerRadius = 5.f;
        self.regPwTextField.layer.masksToBounds = YES;
    
        [_registeredView addSubview:self.regPwTextField];
        [self.regPwTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.registeredView).mas_equalTo(40);
            make.right.equalTo(self.registeredView).mas_equalTo(-40);
            make.centerX.equalTo(self.registeredView);
            make.bottom.equalTo(self.registeredView.mas_centerY);
            make.height.mas_equalTo(50);
        }];
        
        //验证码
        self.verificationTextField = [UITextField new];
        self.verificationTextField.placeholder = @"请输入验证码";
        self.verificationTextField.backgroundColor = [UIColor whiteColor];

        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView2= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView2.image = [UIImage imageNamed:@"dj_yanzhengma"];
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [view2 addSubview:imageView2];

        self.verificationTextField.leftView = view2;
        self.verificationTextField.leftViewMode = UITextFieldViewModeAlways;
        self.verificationTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.verificationTextField.layer.cornerRadius = 5.f;
        self.verificationTextField.layer.masksToBounds = YES;
        [_registeredView addSubview:self.verificationTextField];
        [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.regPwTextField);
            make.bottom.equalTo(self.regPwTextField.mas_top).mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
        
        //倒计时按钮
        self.countDownButton = [[CQCountDownButton alloc] init];
        self.countDownButton.layer.masksToBounds = YES;
        self.countDownButton.layer.cornerRadius = 5.f;
        self.countDownButton.layer.borderWidth = .5f;
        self.countDownButton.layer.borderColor = RGBACOLOR(90, 90, 90, 1).CGColor;
        [self.countDownButton setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
        self.countDownButton.backgroundColor = RGBACOLOR(236, 237, 238, 1);
        [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.countDownButton.dataSource = self;
        self.countDownButton.delegate = self;
        [_registeredView addSubview:self.countDownButton];
        [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.verificationTextField).mas_equalTo(-2);
            make.top.equalTo(self.verificationTextField).mas_equalTo(2);
            make.width.mas_equalTo(100);
        }];
    
        //账号
        self.regAccTextField = [UITextField new];
        self.regAccTextField.placeholder = @"请输入您的手机号/邮箱";
        self.regAccTextField.backgroundColor = [UIColor whiteColor];

        UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView3= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView3.image = [UIImage imageNamed:@"dj_zhanghao"];
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        [view3 addSubview:imageView3];

        self.regAccTextField.leftView = view3;
        self.regAccTextField.leftViewMode = UITextFieldViewModeAlways;
        self.regAccTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.regAccTextField.layer.cornerRadius = 5.f;
        self.regAccTextField.layer.masksToBounds = YES;

        [_registeredView addSubview:self.regAccTextField];
        [self.regAccTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.verificationTextField);
            make.bottom.equalTo(self.verificationTextField.mas_top).mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];

        //注册提示
        UILabel *registeredLabel = [UILabel new];
        registeredLabel.text = @"请填写以下信息完成注册";
        registeredLabel.font = [UIFont systemFontOfSize:20];
        [_registeredView addSubview:registeredLabel];
        [registeredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verificationTextField);
            make.bottom.equalTo(self.regAccTextField.mas_top).mas_equalTo(-30);
        }];

        //确认按钮
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        self.confirmBtn.backgroundColor = RGBACOLOR(45, 121, 220, 1);
        self.confirmBtn.layer.masksToBounds = YES;
        self.confirmBtn.layer.cornerRadius = 5.f;
        [_registeredView addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.right.equalTo(self.regPwTextField);
              make.top.equalTo(self.regPwTextField.mas_bottom).mas_equalTo(35);
              make.height.mas_equalTo(50);
        }];
        [self.confirmBtn addTarget:self action:@selector(registered) forControlEvents:UIControlEventTouchUpInside];
        
     
    }
    return _registeredView;
}
- (UIView *)registeredView_iPad{
    if (_registeredView == nil) {
        _registeredView = [[UIView alloc]initWithFrame:self.view.frame];
        _registeredView.backgroundColor = [UIColor whiteColor];
        _registeredView.hidden = YES;
        
        //背景图
        UIImageView * backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dj_zhucebeijin"]];
        backView.contentMode = UIViewContentModeScaleAspectFit;
        [_registeredView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(self.registeredView);
        }];
        
        //返回
        UIButton * returnBtn =[[UIButton alloc]init];
        [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
        [_registeredView addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registeredView).mas_equalTo(60);
            make.left.equalTo(self.registeredView).mas_equalTo(20);
            make.height.width.mas_equalTo(20);
        }];

        //密码
        self.regPwTextField = [UITextField new];
        self.regPwTextField.placeholder = @"请设置您的密码";
        self.regPwTextField.backgroundColor = [UIColor whiteColor];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView.image = [UIImage imageNamed:@"dj_mima"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];

        self.regPwTextField.leftView = view;
        self.regPwTextField.leftViewMode = UITextFieldViewModeAlways;
        self.regPwTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.regPwTextField.layer.cornerRadius = 5.f;
        self.regPwTextField.layer.masksToBounds = YES;
    
        [_registeredView addSubview:self.regPwTextField];
        [self.regPwTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.registeredView).mas_equalTo(kFrame_width/4);
            make.right.equalTo(self.registeredView).mas_equalTo(-kFrame_width/4);
            make.centerX.equalTo(self.registeredView);
            make.bottom.equalTo(self.registeredView.mas_centerY);
            make.height.mas_equalTo(50);
        }];
        
        //验证码
        self.verificationTextField = [UITextField new];
        self.verificationTextField.placeholder = @"请输入验证码";
        self.verificationTextField.backgroundColor = [UIColor whiteColor];

        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView2= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView2.image = [UIImage imageNamed:@"dj_yanzhengma"];
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [view2 addSubview:imageView2];

        self.verificationTextField.leftView = view2;
        self.verificationTextField.leftViewMode = UITextFieldViewModeAlways;
        self.verificationTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.verificationTextField.layer.cornerRadius = 5.f;
        self.verificationTextField.layer.masksToBounds = YES;
        [_registeredView addSubview:self.verificationTextField];
        [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.regPwTextField);
            make.bottom.equalTo(self.regPwTextField.mas_top).mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
        
        //倒计时按钮
        self.countDownButton = [[CQCountDownButton alloc] init];
        self.countDownButton.layer.masksToBounds = YES;
        self.countDownButton.layer.cornerRadius = 5.f;
        self.countDownButton.layer.borderWidth = .5f;
        self.countDownButton.layer.borderColor = RGBACOLOR(90, 90, 90, 1).CGColor;
        [self.countDownButton setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
        self.countDownButton.backgroundColor = RGBACOLOR(236, 237, 238, 1);
        [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.countDownButton.dataSource = self;
        self.countDownButton.delegate = self;
        [_registeredView addSubview:self.countDownButton];
        [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.verificationTextField).mas_equalTo(-2);
            make.top.equalTo(self.verificationTextField).mas_equalTo(2);
            make.width.mas_equalTo(100);
        }];
    
        //账号
        self.regAccTextField = [UITextField new];
        self.regAccTextField.placeholder = @"请输入您的手机号/邮箱";
        self.regAccTextField.backgroundColor = [UIColor whiteColor];

        UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        UIImageView * imageView3= [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        imageView3.image = [UIImage imageNamed:@"dj_zhanghao"];
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        [view3 addSubview:imageView3];

        self.regAccTextField.leftView = view3;
        self.regAccTextField.leftViewMode = UITextFieldViewModeAlways;
        self.regAccTextField.contentMode = UIViewContentModeScaleAspectFit;
        self.regAccTextField.layer.cornerRadius = 5.f;
        self.regAccTextField.layer.masksToBounds = YES;

        [_registeredView addSubview:self.regAccTextField];
        [self.regAccTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.verificationTextField);
            make.bottom.equalTo(self.verificationTextField.mas_top).mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];

        //注册提示
        UILabel *registeredLabel = [UILabel new];
        registeredLabel.text = @"请填写以下信息完成注册";
        registeredLabel.font = [UIFont systemFontOfSize:20];
        [_registeredView addSubview:registeredLabel];
        [registeredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verificationTextField);
            make.bottom.equalTo(self.regAccTextField.mas_top).mas_equalTo(-30);
        }];

        //确认按钮
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        self.confirmBtn.backgroundColor = RGBACOLOR(45, 121, 220, 1);
        self.confirmBtn.layer.masksToBounds = YES;
        self.confirmBtn.layer.cornerRadius = 5.f;
        [_registeredView addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.right.equalTo(self.regPwTextField);
              make.top.equalTo(self.regPwTextField.mas_bottom).mas_equalTo(35);
              make.height.mas_equalTo(50);
        }];
        [self.confirmBtn addTarget:self action:@selector(registered) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registeredView;
}

#pragma mark - 提示框
-(void)showTitle:(NSString *)title{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
}

- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 退出
-(void)returnUserVC{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 视图切换
-(void)returnV{
    [self.view endEditing:YES];
    
    if (self.loginView.isHidden) {
        self.loginView.hidden = NO;
        self.registeredView.hidden = YES;
    }else{
        self.loginView.hidden = YES;
        self.registeredView.hidden = NO;
    }
}

//点击账号登录
-(void)loginlabelClick{
    self.view1.hidden = NO;
    self.view2.hidden = YES;
    self.passwordTextField.hidden = YES;
    self.loginVerificationTF.hidden = NO;
    self.loginCountDownButton.hidden = NO;
    self.isRegistered = YES;
}

#pragma mark - 倒计时代理
// 设置起始倒计时秒数
-(NSUInteger)startCountDownNumOfCountDownButton:(CQCountDownButton *)countDownButton {
    return 60;
}

// 倒计时进行中的回调
- (void)countDownButtonDidInCountDown:(CQCountDownButton *)countDownButton withRestCountDownNum:(NSInteger)restCountDownNum {
    NSString *title = [NSString stringWithFormat:@"%ld秒后重试", restCountDownNum];
    if(countDownButton == self.loginCountDownButton){
        [self.loginCountDownButton setTitle:title forState:UIControlStateNormal];
    }else{
        [self.countDownButton setTitle:title forState:UIControlStateNormal];
    }
}
// 倒计时结束时的回调
- (void)countDownButtonDidEndCountDown:(CQCountDownButton *)countDownButton {
    if(countDownButton == self.loginCountDownButton){
         [self.loginCountDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

// 倒计时按钮点击回调
- (void)countDownButtonDidClick:(CQCountDownButton *)countDownButton {
    NSString *type,*account;
    if(countDownButton == self.loginCountDownButton){
        if ([self.accountTextField.text isPhone]) {
            type = @"phone";
        }else if ([self.accountTextField.text isEmail]){
            type = @"email";
        }else{
            [self showTitle:@"请输入正确的手机号或邮箱"];
            return;
        }
       account = self.accountTextField.text;
    }else{
        if ([self.regAccTextField.text isPhone]) {
            type = @"phone";
        }else if ([self.regAccTextField.text isEmail]){
            type = @"email";
        }else{
            [self showTitle:@"请输入正确的手机号或邮箱"];
            return;
        }
        account = self.regAccTextField.text;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:account forKey:@"account"];
    [params setValue:type forKey:@"type"];
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_verifyCode parameters:params reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            [countDownButton startCountDown];//开始倒计时
        }else{
            
        }
     }];
}

#pragma mark - 注册
-(void)registered{
    //验证账号
    NSString * type ;
    if ([self.regAccTextField.text isPhone]) {
        type = @"phone";
    }else if ([self.regAccTextField.text isPhone]){
        type = @"email";
    }else{
        [self showTitle:@"请输入正确的手机号或邮箱"];
        return;
    }
    //验证验证码
    if([self.verificationTextField.text isEqualToString:@""]){
        [self showTitle:@"请输验证码"];
        return;
    }
    //用户注册
    NSDictionary *parameters = @{
        @"account": self.regAccTextField.text,
        @"code": self.verificationTextField.text,
        @"password": self.regPwTextField.text,
        @"type": @"1"
    };
    
    @WeakObj(self);
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_Register parameters:parameters reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if(code == 0){//成功
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself returnV];
                    weakself.regAccTextField.text = nil;
                    weakself.verificationTextField.text = nil;
                    weakself.regPwTextField.text = nil;
                });
            });
        }
    }];
}

#pragma mark - 登录
- (BOOL)loginTest
{
    if ([self.accountTextField.text isEqualToString:@"400800888888"] && [self.loginVerificationTF.text isEqualToString:@"110120"]) {
        [DJReadManager loginAccount:self.accountTextField.text password:self.loginVerificationTF.text];
        [self.view endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserNotifitionName object:nil];
        [self returnUserVC];
        return YES;
    }else{
        return NO;
    }
}

-(void)login{
    NSString * type ;
    if ([self loginTest])///看是否是测试用户
        return;
    
    if ([self.accountTextField.text isPhone]) {
        type = @"phone";
    }else if ([self.accountTextField.text isPhone]){
        type = @"email";
    }else{
        [self showTitle:@"请输入正确的手机号或邮箱账号"];
        return;
    }
    if([self.accountTextField.text isEqualToString:@""]){
        [self showTitle:@"请输入密码"];
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    if (self.isRegistered) {
        [parameters setValue:self.accountTextField.text forKey:@"account"];
        [parameters setValue:self.loginVerificationTF.text forKey:@"code"];
    }else{
        [parameters setValue:self.accountTextField.text forKey:@"account"];
        [parameters setValue:self.passwordTextField.text forKey:@"password"];
    }
    NSString *tcode = [self getTcode];
    if (tcode.length>0) [parameters setValue:tcode forKey:@"tcode"];
    
    @WeakObj(self);
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_Login parameters:parameters reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if(code == 0){//登录成功
            //在切换用户后查询有无重复文件，若没有则写入到登录的用户
            [DJReadManager loginAccount:weakself.accountTextField.text password:weakself.accountTextField.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserNotifitionName object:nil];
            GotoMainRootController
        }
    }];
}
///第三方登录
- (void)loginName:(NSString*)name openID:(NSString*)openid headURL:(NSString*)headURL{
    [DJReadManager loginName:name openID:openid headURL:headURL];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserNotifitionName object:nil];
    [self returnUserVC];
    ///这里该是网络请求
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
#pragma mark - 取消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   [self.view endEditing:YES];
}

#pragma mark - 弹出键盘
-(void)transformView:(NSNotification*)aNSNotification{
    CGFloat moveY ;
    if (self.loginView.isHidden) {
        moveY = -50;
    }else{
        moveY = -250;
    }
    [UIView animateWithDuration:0.25f animations:^{
       self.view.frame = CGRectMake(0, moveY, self.view.width, self.view.height);
    }];
}

#pragma mark - 键盘消失
-(void)keyboardWillHide:(NSNotification*)aNSNotification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [UIView commitAnimations];
}
@end

