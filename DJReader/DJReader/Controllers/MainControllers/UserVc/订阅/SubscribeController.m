//
//  SubscribeController.m
//  DJReader
//
//  Created by Andersen on 2020/7/29.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SubscribeController.h"
#import <StoreKit/StoreKit.h>
#import <MBProgressHUD.h>
#import "DJReadNetManager.h"
#import "LoginViewController.h"
#import "PopupsViewDelegate.h"
#import "BindPhoneController.h"
#import "CSWXAPIManager.h"
#import "InvitationAlert.h"
#import "InvitationController.h"

#define PRODUCT_Year_ID @"DianjuOFD00000004"
#define PRODUCT_Quarter_ID @"DianjuOFD00000005"
#define PRODUCT_Month_ID @"DianjuOFD00000002"

#define interval 20
@interface SubscribeController ()<POAlertViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) UIImageView *head;
@property (nonatomic,strong) UIButton *userInfoBtn;
@property (nonatomic,strong) UIView *mainViewHeader;
@property (nonatomic,strong) UIView *mainViewFotter;
@property (nonatomic,strong) NSArray *advantages;
@property (nonatomic,strong) NSMutableAttributedString *userAttributeStr;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) PopupsViewDelegate *vipPopView;
@property (nonatomic,strong) NSMutableDictionary *vipInfo;
@property (nonatomic,assign) BOOL isReload;
@property (nonatomic,strong) NSMutableArray *products;
@property (nonatomic,strong) NSMutableDictionary *params;//购买产品需要发送的参数
@property (nonatomic,assign) NSString *buyProduct;
@end

@implementation SubscribeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅";
    self.products = [[NSMutableArray alloc]initWithObjects:PRODUCT_Quarter_ID,PRODUCT_Month_ID,PRODUCT_Year_ID, nil];
    self.view.backgroundColor = CSWhiteBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.vipInfo = [[NSMutableDictionary alloc]init];
    [self loadSubviews];
    [self getVIPInfo];
    //注册后台用户信息更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoReload) name:@"loginSuccess" object:nil];
    //添加观察者：设置支付服务
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    [self showInvitationAlert];
}
- (void)getVIPInfo
{
    DJReadUser *user = [DJReadManager shareManager].loginUser;
    @WeakObj(self);
    if (!user.uphone) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BindPhoneController *bindPhoneVC = [[BindPhoneController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bindPhoneVC];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:nav completion:nil];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"开通会员需要先绑定手机号码");
    }else{
        NSString *openid = [DJReadManager shareManager].loginUser.openid;
        NSString *phonenum = [DJReadManager shareManager].loginUser.uphone;
        NSString *gettype = @"1";//1:开通时间。2:开通记录
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:openid forKey:@"openid"];
        [params setValue:phonenum forKey:@"phonenum"];
        [params setValue:gettype forKey:@"gettype"];
        
        [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_VIPInfo parameters:params showError:NO reponseResult:^(DJService *service) {
            NSInteger code = service.code;
            if (code == 0) {
                weakself.vipInfo = service.dataResult;
            }else{
                ShowMessage(@"提示", service.serviceMessage, self);
            }
            [weakself reloadUserInfo];
        }];
    }
}
- (void)loadNav
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)reloadUserInfo
{
    if (!_head)
        return;
    
    NSString *userName = [DJReadManager shareManager].loginUser.name;
    UIImage *image;
    
    NSString *vipInfo,*userImage;
    NSURL *url = [NSURL URLWithString:[DJReadManager shareManager].loginUser.avatar];
    if (url.absoluteString.length >= 8) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }else{
        image = [UIImage imageNamed:@"默认头像"];
    }
    if([DJReadManager shareManager].isVIP){
        vipInfo = [NSString stringWithFormat:@"VIP:%@",[_vipInfo objectForKey:@"endtime"]];
        userImage = @"VIP点亮";
    }else{
        vipInfo = @"普通用户";
        userImage = @"普通用户";
    }
    
    NSString *userInfo = [NSString stringWithFormat:@"%@\r%@",userName,vipInfo];
    NSMutableAttributedString *userAttributeStr = [[NSMutableAttributedString alloc]initWithString:userInfo];
    NSMutableParagraphStyle *userParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    userParagraphStyle.alignment = NSTextAlignmentLeft;
    userParagraphStyle.lineSpacing = 2;
    
    [userAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range: NSMakeRange(0, userName.length)];
    [userAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range: NSMakeRange(userName.length + 1, vipInfo.length)];
    [userAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(userName.length + 1 + 4, vipInfo.length - 4)];
    
    [userAttributeStr addAttribute:NSParagraphStyleAttributeName value:userParagraphStyle range:NSMakeRange(0, userInfo.length)];
    [userAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range: NSMakeRange(0, userInfo.length)];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:userImage];
    attach.bounds = CGRectMake(0, -2, 12, 12);
    
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [userAttributeStr insertAttributedString:imageStr atIndex:userName.length + 1];
    _userAttributeStr = userAttributeStr;
    _userInfoBtn.titleLabel.numberOfLines = 0;
    
    _head.image = image;
    [_userInfoBtn setAttributedTitle:_userAttributeStr forState:UIControlStateNormal];
}
- (void)showInvitationAlert
{
    InvitationAlert *alert = [[InvitationAlert alloc]initWithFrame:self.view.bounds];
    alert.alertTouch = ^{
        InvitationController *controller = [[InvitationController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    [self.navigationController.view addSubview:alert];
}
- (void)showOpenVIP
{
    if (!_vipPopView) {
        UIImage *vip = [UIImage imageNamed:@"开通VIP弹框"];
        UIImageView *contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, vip.size.height*300/vip.size.width)];
        contentView.userInteractionEnabled = YES;
        contentView.image = vip;
        
        UIButton *experience = [UIButton buttonWithType:UIButtonTypeSystem];
        experience.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:RGBACOLOR(69, 62, 56, 1)];
        [experience setTitle:@"立即体验" forState:UIControlStateNormal];
        [experience setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [experience addTarget:self action:@selector(experience) forControlEvents:UIControlEventTouchUpInside];
        experience.layer.masksToBounds = YES;
        experience.layer.cornerRadius = 4;
        [contentView addSubview:experience];
        
        [experience mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView).offset(-30);
            make.centerX.equalTo(contentView);
            make.width.mas_equalTo(@(contentView.width*0.8));
            make.height.mas_equalTo(@(35));
        }];
        _vipPopView = [[PopupsViewDelegate alloc]initWithContentView:contentView];
    }
    [_vipPopView showView];
}

- (void)experience
{
    [_vipPopView dismissAlertView];
}

- (void)loadSubviews
{
    [self loadNav];
    @WeakObj(self);
    CGFloat widthScale = 0.8;
    CGFloat productInterval = 20.0;
    CGFloat contentWidth = self.view.width * widthScale;
    CGFloat contentHeight = self.view.height/5;
    
    UIScrollView *mainView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    mainView.backgroundColor = CSBackgroundColor;
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.contentSize = CGSizeMake(self.view.size.width, (self.view.height/8)+productInterval*4 + contentHeight*5 + 80);
    [self.view addSubview:mainView];
        
    UIImageView *backHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4)];
    backHead.image = [UIImage imageNamed:@"backHead"];
    backHead.userInteractionEnabled = YES;
    [mainView addSubview:backHead];
    
    _head = [[UIImageView alloc]init];
    _head.layer.masksToBounds = YES;
    _head.layer.cornerRadius  = 40;
    _head.contentMode = 1;
    [backHead addSubview:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backHead).offset(self.view.width*0.1);
        make.top.equalTo(backHead).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    _userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userInfoBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [backHead addSubview:_userInfoBtn];
    
    [_userInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.head.mas_right);
        make.top.equalTo(weakself.head);
        make.height.mas_equalTo(@(80));
        make.width.mas_equalTo(@(200));
    }];
    [self reloadUserInfo];
    
    UIImageView *invitationView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*0.1, (self.view.height/8) + contentHeight*0 + productInterval*1, contentWidth, contentHeight)];
    invitationView.userInteractionEnabled = YES;
    invitationView.image = [UIImage imageNamed:@"SubscribeTitle"];
    [mainView addSubview:invitationView];
    [self loadInVitationWithMessage:@"邀请3个好友" inView:invitationView description:@"可免费获得一年的VIP"];
    
    UIImageView *titleView_month = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*0.1, (self.view.height/8) + contentHeight*1 +productInterval*2, contentWidth, contentHeight)];
    titleView_month.userInteractionEnabled = YES;
    titleView_month.image = [UIImage imageNamed:@"SubscribeTitle"];
    [mainView addSubview:titleView_month];
    [self loadProductWithPrice:@"12元/月" inView:titleView_month reducedPrice:@"现在开通最高可优惠36元"];
    
    UIImageView *titleView_quarter = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*0.1, (self.view.height/8) + contentHeight*2+productInterval*3, contentWidth, contentHeight)];
    titleView_quarter.userInteractionEnabled = YES;
    titleView_quarter.image = [UIImage imageNamed:@"SubscribeTitle"];
    [mainView addSubview:titleView_quarter];
    [self loadProductWithPrice:@"30元/季" inView:titleView_quarter reducedPrice:@"现在开通最高可优惠36元"];
    
    UIImageView *titleView_year = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*0.1, (self.view.height/8) + contentHeight*3+productInterval*4, contentWidth, contentHeight)];
    titleView_year.userInteractionEnabled = YES;
    titleView_year.image = [UIImage imageNamed:@"SubscribeTitle"];
    [mainView addSubview:titleView_year];
    [self loadProductWithPrice:@"108元/年" inView:titleView_year reducedPrice:@"现在开通最高可优惠36元"];
    
    
    UILabel* descript = [[UILabel alloc]init];
    NSString *des = @"   购买点聚OFD年费会员,您将拥有点聚OFD为期一年的特殊权益,并且我们如果新增加了VIP用户的权益，您的账户仍然可以享受此权益，如果您已购买此产品，仍继续购买，将会在已有的到期的日期上延期。";
    descript.text = des;
    descript.numberOfLines = 0;
    descript.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:descript];
    [descript mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView_year.mas_bottom);
        make.left.right.equalTo(titleView_year);
        make.height.mas_equalTo(@(contentHeight));
    }];
    
    UIImageView *earnings_01 = [[UIImageView alloc]init];
    earnings_01.image = [UIImage imageNamed:@"earnings_01"];
    [self.view addSubview:earnings_01];
    UIImageView *earnings_02 = [[UIImageView alloc]init];
    earnings_02.image = [UIImage imageNamed:@"earnings_02"];
    [mainView addSubview:earnings_02];
    
    [earnings_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView_year);
        make.top.equalTo(descript.mas_bottom);
        make.height.mas_equalTo(@(80));
        make.width.mas_equalTo(@(contentWidth/2 - 10));
    }];
    [earnings_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView_year);
        make.top.equalTo(descript.mas_bottom);
        make.height.mas_equalTo(@(80));
        make.width.mas_equalTo(@(contentWidth/2 - 10));
    }];
}
- (void)loadInVitationWithMessage:(NSString*)message inView:(UIView*)titleView description:(NSString*)description
{
    NSString *headStr = [[NSString alloc]initWithFormat:@"%@\r\n%@",message,description];
    NSMutableAttributedString *headAttributeStr = [[NSMutableAttributedString alloc]initWithString:headStr];
    NSMutableParagraphStyle *headParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    headParagraphStyle.alignment = NSTextAlignmentCenter;
    headParagraphStyle.lineSpacing = 8;

    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range: NSMakeRange(0, message.length)];
    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range: NSMakeRange(message.length + 2, description.length)];
    [headAttributeStr addAttribute:NSParagraphStyleAttributeName value:headParagraphStyle range:NSMakeRange(0, headStr.length)];
    [headAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:62/255.0 blue:56/255.0 alpha:1.0] range: NSMakeRange(0, headStr.length)];

    UILabel *title = [[UILabel alloc]init];
    title.numberOfLines = 0;
    title.attributedText = headAttributeStr;
    [titleView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleView).offset(titleView.height*0.25);
        make.height.mas_equalTo(@(titleView.height/3));
        make.width.equalTo(titleView.mas_width);
    }];
    
    UIButton *subcribe = [UIButton buttonWithType:UIButtonTypeSystem];
    subcribe.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:RGBACOLOR(69, 62, 56, 1)];
    [subcribe setTitle:Action_ShareFriend forState:UIControlStateNormal];

    [subcribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subcribe.layer.masksToBounds = YES;
    subcribe.layer.cornerRadius = 4;
    [titleView addSubview:subcribe];
    [subcribe addTarget:self action:@selector(invitaiton:) forControlEvents:UIControlEventTouchUpInside];
    
    [subcribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(titleView).offset(-self.view.width/8 - 10);
        make.width.mas_equalTo(@(self.view.width/4));
        make.height.mas_equalTo(@(35));
    }];
    
    UIButton *shareForum = [UIButton buttonWithType:UIButtonTypeSystem];
    shareForum.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:RGBACOLOR(69, 62, 56, 1)];
    [shareForum setTitle:Action_ShareForum forState:UIControlStateNormal];

    [shareForum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareForum.layer.masksToBounds = YES;
    shareForum.layer.cornerRadius = 4;
    [titleView addSubview:shareForum];
    [shareForum addTarget:self action:@selector(invitaiton:) forControlEvents:UIControlEventTouchUpInside];
    
    [shareForum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(titleView).offset(self.view.width/8 + 10);
        make.width.mas_equalTo(@(self.view.width/4));
        make.height.mas_equalTo(@(35));
    }];
}

- (void)loadProductWithPrice:(NSString*)price inView:(UIView*)titleView reducedPrice:(NSString*)reducePrice
{
    NSString *headStr = [[NSString alloc]initWithFormat:@"%@\r\n%@",price,reducePrice];
    NSMutableAttributedString *headAttributeStr = [[NSMutableAttributedString alloc]initWithString:headStr];
    NSMutableParagraphStyle *headParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    headParagraphStyle.alignment = NSTextAlignmentCenter;
    headParagraphStyle.lineSpacing = 8;

    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range: NSMakeRange(0, price.length)];
    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range: NSMakeRange(price.length + 2, reducePrice.length)];
    [headAttributeStr addAttribute:NSParagraphStyleAttributeName value:headParagraphStyle range:NSMakeRange(0, headStr.length)];
    [headAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:62/255.0 blue:56/255.0 alpha:1.0] range: NSMakeRange(0, headStr.length)];

    UILabel *title = [[UILabel alloc]init];
    title.numberOfLines = 0;
    title.attributedText = headAttributeStr;
    [titleView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleView).offset(titleView.height*0.25);
        make.height.mas_equalTo(@(titleView.height/3));
        make.width.equalTo(titleView.mas_width);
    }];
    
    UIButton *subcribe = [UIButton buttonWithType:UIButtonTypeSystem];
    subcribe.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:RGBACOLOR(69, 62, 56, 1)];
    if ([DJReadManager shareManager].isVIP) {
        [subcribe setTitle:@"续费" forState:UIControlStateNormal];
    }else{
        [subcribe setTitle:@"开通" forState:UIControlStateNormal];
    }
    [subcribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subcribe.layer.masksToBounds = YES;
    subcribe.layer.cornerRadius = 4;
    [titleView addSubview:subcribe];
    
    if ([price containsString:@"12"]) {
        [subcribe addTarget:self action:@selector(subcribeMonth) forControlEvents:UIControlEventTouchUpInside];
    }else if([price containsString:@"30"]){
        [subcribe addTarget:self action:@selector(subcribeQuarter) forControlEvents:UIControlEventTouchUpInside];
    }else if([price containsString:@"108"]){
        [subcribe addTarget:self action:@selector(subcribeYear) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [subcribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(titleView);
        make.width.mas_equalTo(@(self.view.width/3));
        make.height.mas_equalTo(@(35));
    }];
}
- (void)userInfoReload
{
    [self reloadUserInfo];
}
- (void)login
{
    if (![[DJReadManager shareManager] isLoging]) {
        GotoLoginControllerFrom(self);
    }
}
- (void)showHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = @"正在请求数据...";
    [_hud showAnimated:YES];
}
- (void)hiddenHUD
{
    [_hud hideAnimated:YES];
}
- (void)subcribeMonth
{
    self.params = [[NSMutableDictionary alloc]init];

    self.buyProduct = PRODUCT_Month_ID;
    [self.params setValue:@"1" forKey:@"viptype"];
    [self subcribeOFD];
}
- (void)subcribeQuarter
{
    self.params = [[NSMutableDictionary alloc]init];
    self.buyProduct = PRODUCT_Quarter_ID;
    [self.params setValue:@"2" forKey:@"viptype"];
    [self subcribeOFD];
}
- (void)subcribeYear
{
    self.params = [[NSMutableDictionary alloc]init];

    self.buyProduct = PRODUCT_Year_ID;
    [self.params setValue:@"3" forKey:@"viptype"];
    [self subcribeOFD];
}
- (void)subcribeOFD
{
    //判断app是否允许apple支付
    if([SKPaymentQueue canMakePayments]){
        [self requestAppleProducts];
    }else{
        showAlert(@"App无法获取支付权限，请检查您的设置", self);
    }
}
- (void)invitaiton:(UIButton*)sender
{
    if (![[DJReadManager shareManager].loginUser.uphone isPhone]) {
        GotoBindPhoneControllerFrom(self);
    }else{
        int wxscene;
        if ([sender.titleLabel.text isEqualToString:Action_ShareFriend]) {
            wxscene = 0;
        }else{
            wxscene = 1;
        }
        NSString *phoneNum = [DJReadManager shareManager].loginUser.uphone;
        NSData *phoneData = [[NSData alloc]initWithBase64EncodedString:phoneNum options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *tCode = [[NSString alloc]initWithData:phoneData encoding:NSUTF8StringEncoding];
        NSString *urlStr = [[NSString alloc]initWithFormat:ShareInvitaitionURL,tCode];
        [[CSWXAPIManager sharedManager] sendLinkContent:urlStr
                                                Title:@"邀请好友得会员"
                                          Description:@"邀请三个好友下载登录即可获得一年会员"
                                              AtScene:wxscene completion:nil];
    }
}
///请求苹果商品ID的信息列表
- (void)requestAppleProducts
{
    [self showHUD];
    NSSet *set = [NSSet setWithArray:self.products];
    //查询所有产品
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
///接到产品的返回信息列表，然后用返回的商品信息进行发起购买请求
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if (products.count == 0) {
        return;//后台无可售信息
    }
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in products) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        //如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if ([pro.productIdentifier isEqualToString:self.buyProduct]) {
            requestProduct = pro;
        }
    }
    if (!requestProduct) {
        ShowMessage(@"提示", @"商超暂无可供销售的物品", self);
        return;
    }
    //发送购买请求
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}
///请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
///反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"信息反馈结束");
}
///监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:{
                [self failedTransaction:tran];
            }break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}
// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2)){
//    ShowMessage(@"removedTransactions", @"1", self);
}
//恢复购买失败.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2)){
//    ShowMessage(@"restoreCompleted", @"2", self);
}
//当用户的所有购买食物都加入了队列.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2)){
//    ShowMessage(@"RestoreCompletedTransactionsFinished", @"3", self);
}
///当下载状态改变时
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads API_AVAILABLE(ios(6.0), macos(10.8), watchos(6.2)){
//    ShowMessage(@"updatedDownloads", @"4", self);
}
// Sent when a user initiates an IAP buy from the App Store
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product NS_SWIFT_NAME(paymentQueue(_:shouldAddStorePayment:for:)) API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos, macCatalyst, watchos){
    return YES;
}
- (void)paymentQueueDidChangeStorefront:(SKPaymentQueue *)queue API_AVAILABLE(ios(13.0), macos(10.15), watchos(6.2)){
//    ShowMessage(@"paymentQueueDidChangeStorefront", @"6", self);
}
//交易结束，当交易结束后还要去appstore上验证信息，只有所有都正确后，我们就可以给用发放虚拟物品了
- (void)completeTransaction:(SKPaymentTransaction*)transaction
{
    //验证凭据
    NSURL *receiptURL = [[NSBundle mainBundle]appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString *str = [[NSString alloc]initWithData:receiptData encoding:NSUTF8StringEncoding];
    NSString *environment = [self environmentForReceipt:str];
    NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@", environment);

    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}",encodeStr];
    NSURL *storeURL = nil;
    
    if ([environment isEqualToString:@"environment=Sandbox"]) {///沙盒环境
        storeURL = [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
    }else{
        storeURL = [[NSURL alloc]initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];//生产环境
    }
    NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
    NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [connectionRequest setHTTPMethod:@"POST"];
    [connectionRequest setTimeoutInterval:50.0];
    [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [connectionRequest setHTTPBody:postData];
    
    @WeakObj(self)
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:connectionRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"请求成功后的数据:%@", dic);
                //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
                //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                NSString *product = transaction.payment.productIdentifier;
                NSLog(@"transaction.payment.productIdentifier++++%@", product);
                if ([product length] > 0) {
                    NSArray *tt = [product componentsSeparatedByString:@"."];
                    NSString *bookid = [tt lastObject];
                    if([bookid length] > 0) {
                        [DJReadNetShare openWithParam:self.params complete:^(DJService *service) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self hiddenHUD];
                                NSInteger code = service.code;
                                if (code == 0) {
                                    //刷新用户信息
                                    NSString *openid = [DJReadManager shareManager].loginUser.openid;
                                    NSString *phonenum = [DJReadManager shareManager].loginUser.uphone;
                                    NSString *gettype = @"1";//1:开通时间。2:开通记录
                                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                    [params setValue:openid forKey:@"openid"];
                                    [params setValue:phonenum forKey:@"phonenum"];
                                    [params setValue:gettype forKey:@"gettype"];
                                    [DJReadManager shareManager].loginUser.isvip = 1;
                                    
                                    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_VIPInfo parameters:params reponseResult:^(DJService *service) {
                                        NSInteger code = service.code;
                                        if (code == 0) {
                                            weakself.vipInfo = service.dataResult;
                                        }else{
                                            NSString *msg = [NSString stringWithFormat:@"交易失败:%ld",(long)code];
                                            ShowMessage(@"提示", msg, self);
                                        }
                                        [weakself reloadUserInfo];
                                    }];
                                    [self showOpenVIP];
                                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                                }else{
                                    ShowMessage(nil, @"物品发放失败，下次购买时，重新发放", RootController);
                                }
                            });
                        }];
                    }
                }
            }else{
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self hiddenHUD];
                showAlert(@"交易失败:0xFFFFFF", self)
            }
        });
    }];
  [task resume];
}
- (void)failedTransaction:(SKPaymentTransaction*)transaction
{
    [self hiddenHUD];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    ShowMessage(@"交易失败:0xFFFFFE", transaction.error.debugDescription, self);
}
- (void)restoreTransaction:(SKPaymentTransaction*)transaction
{
    [self hiddenHUD];
    //完成之前的交易
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)finishTransaction:(SKPaymentTransaction*)transaction
{
    [self hiddenHUD];
    //放弃之前的交易
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (NSData*)getTransactionReceipt
{
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    return [NSData dataWithContentsOfURL:receiptUrl];
}
- (NSString*)environmentForReceipt:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *arr = [str componentsSeparatedByString:@";"];
    
    // 存储收据环境的变量
    NSString *environment = arr[2];
    return environment;
}
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
}
@end
