//
//  SecondController.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "UserController.h"
#import "LoginViewController.h"
#import "CSCoreDataManager.h"
#import "PersonalDataViewController.h"
#import "UserInfoCell.h"
#import "AttributeController.h"
#import "CSShareManger.h"
#import "FeedBackController.h"
#import "SubscribeController.h"
#import "SignManagerController.h"
#import "SealManagerController.h"
#import "CertManagerController.h"
#import "DJReadNetManager.h"
#import "AboutUsController.h"
#import "LoginDistributionController.h"
#import "BindPhoneController.h"

#define Member @"个人"
#define Subscribe @"订阅"
#define UserInfo @"个人资料"
#define Attributes @"首选项"

#define Manager @"管理"
#define Sign @"签名"
#define Seal @"印章"
#define Cert @"证书"



#define ShareApp @"推荐给好友"
#define MeassgeInfo @"版本"
#define AboutUs @"关于我们"
#define Feedback @"意见反馈"


@interface UserController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * userTableView;
@property (nonatomic,strong) LoginViewController * loginVc;
@property (nonatomic,strong) LoginDistributionController * loginDistribution;

@property (nonatomic,strong) NSMutableDictionary *options;
@property (nonatomic,strong) UIButton * loginSender;
@property (nonatomic,strong) NSMutableDictionary *vipInfo;

@end

@implementation UserController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.vipInfo = [[NSMutableDictionary alloc]init];
    self.originController.tabBarHidden = NO;
    [self.userTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadOptions];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = CSBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的";
    [self setUserTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
}

- (void)loadOptions
{
    self.options = [[NSMutableDictionary alloc]init];
    int keyNum = 0;
//    NSString *key1 = [NSString stringWithFormat:@"%d",0];
//    [self.options setObject:@[Member,UserInfo] forKey:key1];
    
    NSString *key2 = [NSString stringWithFormat:@"%d",0];
    [self.options setObject:@[Sign,Seal,Cert] forKey:key2];
    
    NSString *key3 = [NSString stringWithFormat:@"%d",1];
    [self.options setObject:@[AboutUs,MeassgeInfo,Feedback,Attributes] forKey:key3];
}
- (void)gotoUserInfo
{
    @WeakObj(self);
    if(![CSCoreDataManager isLogin]){
        self.loginVc = [[LoginViewController alloc]init];
        self.loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
        self.loginVc.originController = self.originController;
        [self presentViewController:self.loginVc animated:YES completion:nil];
    }else{
        PersonalDataViewController * userVc = [[PersonalDataViewController alloc]init];
        userVc.loginOut = ^{
            UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.loginSender setTitle:@"登录" forState:UIControlStateNormal];
                [DJReadManager shareManager].loginType = LoginTypeAdmin;
                [[CSCoreDataManager shareManager] cleanCacheUser];
                [weakself showTitle:@"退出成功"];
                [weakself.userTableView reloadData];
            }];
            UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            addTarget(self, action_01, action_02, @"退出当前账户将会不能使用部分功能,是否确定退出");
        };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userVc];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)checkVersion
{
    NSString *verson = APP_VERSION;
    NSString *system = @"2";//1:安卓；2:iOS
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (verson.length > 0) {
        [params setValue:verson forKey:@"version"];
    }
    if (system.length > 0) {
        [params setValue:system forKey:@"version"];
    }
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_Appversion parameters:params showError:NO reponseResult:^(DJService *service) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *data = service.dataResult;
            NSInteger code = service.code;
            
            if (code == 0) {
                NSString *version = [data objectForKey:@"version"];
                if ([version isEqualToString:APP_VERSION]) {
                    showAlert(@"当前版本已是最新版本", RootController);
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"当前版本不是APP最新版本，是否去App store更新" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"已经很好用了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/1517200440"]];
                    }]];
                    [self presentViewController:alertController animated:YES  completion:nil];
                }
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未查询到版本信息，是否去App store更新" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"已经很好用了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/1517200440"]];
                }]];
                [self presentViewController:alertController animated:YES  completion:nil];

            }
        });
    }];
}
- (void)gotoLogin
{
    GotoLoginControllerFrom(self)
}
- (void)gotoAttribute
{
    AttributeController *attributeController = [[AttributeController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:attributeController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)shareApp
{
//    NSURL *shareURL = [NSURL URLWithString:@"wxd60e5a883ae5d4fc://programID=20000001"];
    NSURL *shareURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/1517200440"];
    [CSShareManger shareActivityController:self withFile:shareURL];
}
- (void)gotoFeedBack
{
    FeedBackController * feedVC = [[FeedBackController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:feedVC];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)gotoSubscribe
{
    if (![CSCoreDataManager isLogin]) {
        [self gotoLogin];
    }else{
        SubscribeController *subscribeController = [SubscribeController new];
        subscribeController.originController = self.originController;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:subscribeController];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
        self.originController.tabBarHidden = YES;
    }
}
- (void)gotoAboutUs
{
    AboutUsController *aboutUsVC = [[AboutUsController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:aboutUsVC];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)gotoSignController
{
    if (![DJReadManager shareManager].isVIP) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoSubscribe];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"签名功能必须开通VIP");
    }else{
        SignManagerController *manger = [[SignManagerController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manger];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)gotoSealController
{
    if (![DJReadManager shareManager].isVIP) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoSubscribe];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"印章功能必须开通VIP");
    }else{
        SealManagerController *manger = [[SealManagerController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manger];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)gotoBindPhoneController
{
    BindPhoneController *bindVC = [[BindPhoneController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:bindVC];
    navc.modalPresentationStyle = 0;
    [self presentViewController:navc animated:YES completion:nil];
}
- (void)gotoCertController
{
    if (![DJReadManager shareManager].isVIP) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoSubscribe];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"证书功能必须开通VIP");
    }else{
        CertManagerController *manger = [[CertManagerController alloc]init];
        manger.title = @"证书管理";
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manger];
        nav.modalPresentationStyle = 0;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - UI
-(void)setUserTableView{
    [self.view addSubview:self.userTableView];
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _userTableView.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.1 alpha:1.0] lightColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _userTableView;
}

#pragma mark - tableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.options.allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)section];
    NSArray *optionValue =  [self.options objectForKey:key];
    return optionValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row != 0 || indexPath.section == 2)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *optionValue = [self.options objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    NSString *infoTitle = [optionValue objectAtIndex:indexPath.row];
    [self initCell:cell forInfoTitle:infoTitle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 140;
    }else{
        return 0;
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == self.options.allKeys.count - 1) {
//        return 80;
//    }else{
        return 30;
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *optionValue = [self.options objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    NSString *actionName = [optionValue objectAtIndex:indexPath.row];
    [self clickedCell:nil forInfoTitle:actionName];
}

#pragma mark - 登录退出
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat interval = 10;
    CGFloat width = self.view.width - 40;
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    header.backgroundColor = CSWhiteBackgroundColor;
    
    UIView *loginView = [[UIView alloc]init];
    loginView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    loginView.layer.masksToBounds = YES;
    loginView.layer.cornerRadius = 4.0;
    [header addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(120);
    }];
    if ([[DJReadManager shareManager] isLoging]) {
        UIButton *userHeader = [[UIButton alloc]init];
        [userHeader setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
        [userHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [userHeader addTarget:self action:@selector(gotoUserInfo) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:userHeader];
        
        [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loginView).offset(interval);
            make.top.equalTo(loginView).offset(interval);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        //userHeader.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10, 130);
        //userHeader.titleEdgeInsets = UIEdgeInsetsMake(20, 00, 20, 0);
        userHeader.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.text = [DJReadManager shareManager].loginUser.name;
        [loginView addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userHeader);
            make.left.equalTo(userHeader.mas_right).offset(5);
            make.height.mas_equalTo(@(25));
            make.width.mas_equalTo(@(150));
        }];
        
        
        
        UILabel *viplabel = [[UILabel alloc]init];
        [loginView addSubview:viplabel];
        [viplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userHeader);
            make.left.equalTo(namelabel);
            make.height.mas_equalTo(@(25));
            make.width.mas_equalTo(@(150));
        }];
        NSString *userType,*userImage;
        if([DJReadManager shareManager].isVIP){
            userImage = @"VIP点亮";
            userType = @"VIP用户";
        }else{
            userImage = @"普通用户";
            userType = @"普通用户";
        }
        NSMutableAttributedString *userAttributeStr = [[NSMutableAttributedString alloc]initWithString:userType];
        NSMutableParagraphStyle *userParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        userParagraphStyle.alignment = NSTextAlignmentLeft;
        userParagraphStyle.lineSpacing = 2;
        
        [userAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range: NSMakeRange(0, userType.length)];
        [userAttributeStr addAttribute:NSParagraphStyleAttributeName value:userParagraphStyle range:NSMakeRange(0, userType.length)];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:userImage];
        attach.bounds = CGRectMake(0, -2, 14, 14);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [userAttributeStr insertAttributedString:imageStr atIndex:0];
        viplabel.numberOfLines = 0;
        viplabel.attributedText = userAttributeStr;
        
        UIButton *openVip = [[UIButton alloc]init];
        if ([[DJReadManager shareManager]isVIP]) {
            [openVip setTitle:@"续费" forState:UIControlStateNormal];
        }else{
            [openVip setTitle:@"开通" forState:UIControlStateNormal];
        }
        [openVip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openVip addTarget:self action:@selector(gotoSubscribe) forControlEvents:UIControlEventTouchUpInside];
        openVip.backgroundColor = [UIColor redColor];
        [loginView addSubview:openVip];
        [openVip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.height.mas_offset(35);
            make.right.equalTo(loginView).offset(-10);
            make.centerY.equalTo(userHeader);
        }];
        openVip.layer.masksToBounds = YES;
        openVip.layer.cornerRadius = 8.0;
        
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        [loginView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loginView).offset(-2);
            make.right.equalTo(loginView).offset(-2);
            make.top.equalTo(userHeader.mas_bottom).offset(interval);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *tip = [[UILabel alloc]init];
        tip.text = @"成为点聚会员专享更多功能";
        [loginView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(line).offset(20);
            make.right.equalTo(line);
            make.bottom.equalTo(loginView);
        }];
    }else{
        UILabel *title = [[UILabel alloc]init];
        title.text = @"登录点聚OFD，享受更多功能";
        title.textAlignment = NSTextAlignmentCenter;
        [loginView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(loginView);
            make.width.equalTo(loginView);
            make.top.equalTo(loginView).offset(10);
            make.height.equalTo(@(30));
        }];
        UIButton *loginSender = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginSender.layer.masksToBounds = YES;
        loginSender.layer.cornerRadius = 4.0;
        loginSender.backgroundColor = [UIColor systemBlueColor];
        [loginSender setTitle:@"登录" forState:UIControlStateNormal];
        [loginSender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginSender addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:loginSender];
        [loginSender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(loginView);
            make.width.mas_equalTo((self.view.width - 40)/3);
            make.bottom.equalTo(loginView).offset(-10);
            make.height.mas_equalTo(40);
        }];
    }
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == self.options.allKeys.count - 1) {
//        UIView * view = [[UIView alloc]init];
//        self.loginSender = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        if(![CSCoreDataManager isLogin]) {
//            [self.loginSender setTitle:@"登录" forState:UIControlStateNormal];
//        }else{
//            [self.loginSender setTitle:@"退出登录" forState:UIControlStateNormal];
//        }
//        [self.loginSender setTitleColor:CSTextColor forState:UIControlStateNormal];
//        self.loginSender.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:[UIColor whiteColor]];
//
//        [self.loginSender addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:self.loginSender];
//        [self.loginSender mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(view.mas_bottom);
//            make.centerX.equalTo(view.mas_centerX);
//            make.height.mas_offset(50);
//            make.width.mas_offset(self.view.width);
//        }];
//        return view;
//    }else{
        return nil;
//    }
}
#pragma mark -点击登录
-(void)login{
    if(![CSCoreDataManager isLogin]){
        GotoLoginControllerFrom(self)
    }else if([DJReadManager shareManager].loginType == LoginTypeOFD || [DJReadManager shareManager].loginType == LoginTypeWechat){
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.loginSender setTitle:@"登录" forState:UIControlStateNormal];
            [DJReadManager shareManager].loginType = LoginTypeAdmin;
            [[CSCoreDataManager shareManager] cleanCacheUser];
            [self showTitle:@"退出成功"];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"退出当前账户将会不能使用部分功能,是否确定退出");
    }
}
-(void)loginSuccess{
    if ([DJReadManager shareManager].loginUser.uphone.length != 11) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoBindPhoneController];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"当前您的账户未绑定手机号码，部分功能将被限制");
    }
    [self.userTableView reloadData];
}
- (void)loadUserInfo
{
    DJReadUser *loginUser = [[DJReadManager shareManager]loginUser];
    
    [DJReadNetShare requestUserInfo:loginUser.uphone andOpenid:loginUser.openid complete:^(DJReadUser *user) {
        [DJReadManager shareManager].loginUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    }];
}
#pragma mark - 提示框
-(void)showTitle:(NSString *)title{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
     [self presentViewController:alert animated:YES completion:nil];
     [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.5];
}
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCell:(UserInfoCell*)cell forInfoTitle:(NSString*)info
{
    if ([info isEqualToString:Member]) {
        [cell setHead:Member title:Member];
    }else if ([info isEqualToString:Manager]) {
        [cell setHead:Manager title:Manager];
    }else if ([info isEqualToString:Subscribe]) {
        [cell setHead:Subscribe title:Subscribe];
    }else if ([info isEqualToString:MeassgeInfo]) {
        [cell setHead:MeassgeInfo title:MeassgeInfo];
    }else if ([info isEqualToString:AboutUs]) {
        [cell setHead:AboutUs title:AboutUs];
    }else if ([info isEqualToString:Feedback]) {
        [cell setHead:Feedback title:Feedback];
    }else if ([info isEqualToString:Attributes]) {
        [cell setHead:Attributes title:Attributes];
    }else if ([info isEqualToString:Cert]) {
        [cell setHead:Cert title:Cert];
    }else if ([info isEqualToString:Seal]) {
        [cell setHead:Seal title:Seal];
    }else if ([info isEqualToString:Sign]) {
        [cell setHead:Sign title:Sign];
    }else{
        [cell setHead:nil title:info];
    }
}
- (void)clickedCell:(UserInfoCell*)cell forInfoTitle:(NSString*)info
{
    if ([info isEqualToString:Sign]||[info isEqualToString:Seal]||[info isEqualToString:Cert]) {
        if (![DJReadManager shareManager].isLoging || ![DJReadManager shareManager].loginUser.uphone) {
            ShowMessage(@"提示", @"请先登录，并且确定绑定手机号", self)
        }else{
            if([info isEqualToString:Sign]){
                [self gotoSignController];
            }else  if([info isEqualToString:Seal]){
                [self gotoSealController];
            }else  if([info isEqualToString:Cert]){
                [self gotoCertController];
            }
        }
    }else if([info isEqualToString:UserInfo]||[info isEqualToString:Subscribe]){
        if(![CSCoreDataManager isLogin]){
            GotoLoginControllerFrom(self)
        }else{
            if ([info isEqualToString:UserInfo]) {
                [self gotoUserInfo];
            }else  if([info isEqualToString:Subscribe]){
                [self gotoSubscribe];
            }
        }
    }else{
        if([info isEqualToString:MeassgeInfo]){
            [self checkVersion];
        }else  if([info isEqualToString:Attributes]){
            [self gotoAttribute];
        }else  if([info isEqualToString:ShareApp]){
            [self shareApp];
        }else if ([info isEqualToString:Feedback]){
            [self gotoFeedBack];
        }else  if([info isEqualToString:AboutUs]){
            [self gotoAboutUs];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
}
@end
