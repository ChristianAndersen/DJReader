//
//  BindPhoneController.m
//  DJReader
//
//  Created by Andersen on 2020/8/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "BindPhoneController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "INPutTextCell.h"
#import "CQCountDownButton.h"
#import "DJReadNetManager.h"
#import "CSCoreDataManager.h"

#define kCellIdentifier_InputTextCell @"INPutTextCell"
#define kCellIdentifier_PreferenceCell @"PreferenceCell"

@interface BindPhoneController ()<CQCountDownButtonDataSource,CQCountDownButtonDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic,strong)UIButton*login,*address;
@property (nonatomic,strong)CQCountDownButton *verifyBtn;
@property (nonatomic,copy)NSString * phoneNum;
@property (nonatomic,copy)NSString * verifyCode;
@end

@implementation BindPhoneController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.view.backgroundColor = CSBackgroundColor;
    [self loadSubviews];
    
}
- (void)loadSubviews
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
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [tableView registerClass:[INPutTextCell class] forCellReuseIdentifier:kCellIdentifier_InputTextCell];
        tableView.backgroundColor = CSBackgroundColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    self.myTableView.tableHeaderView=[self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPutTextCell *textCell;
    textCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextCell forIndexPath:indexPath];
    if (!textCell) {
        textCell = [[INPutTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_InputTextCell];
    }
    if(indexPath.row == 0){
        [textCell configTitle:@"账  户:  " andPlaceholder:@"请输入账户" andValue:nil];
        [textCell addLeftSender:[self createVerifyCode]];
        textCell.textValueChangedBlock = ^(NSString*text){
            self.phoneNum = text;
        };
    }else if (indexPath.row == 1){
        [textCell configTitle:@"验证码:  " andPlaceholder:@"请输验证码" andValue:nil];
        textCell.textValueChangedBlock = ^(NSString*text){
            self.verifyCode = text;
        };
    }
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return textCell;
}
- (CQCountDownButton*)createVerifyCode
{
    //倒计时按钮
    _verifyBtn = [[CQCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_verifyBtn setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.titleEdgeInsets = UIEdgeInsetsMake(1.0, 25, 1.0, 1.0);
    _verifyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_verifyBtn setTitleColor:[UIColor systemOrangeColor] forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    _verifyBtn.dataSource = self;
    _verifyBtn.delegate = self;
    return _verifyBtn;;
}

- (UIView *)customHeaderView{
    UIView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.myTableView.frame.size.width, kScreen_Height/20)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (UIView *)customFooterView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.myTableView.frame.size.width, kScreen_Height/3)];
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    [_login setTitle:@"确   认" forState:UIControlStateNormal];
    [_login setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _login.titleLabel.font = [UIFont systemFontOfSize:20];
    [_login addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_login];
    
    [_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).offset(30);
        make.centerX.equalTo(footView);
        make.width.mas_equalTo(footView.frame.size.width-40);
        make.height.mas_equalTo(@(40));
    }];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.login).offset(-10);
        make.top.equalTo(self.login.mas_bottom).offset(10);
        make.width.mas_equalTo(@(80));
        make.height.mas_equalTo(@(44));
    }];
    
    _login.layer.masksToBounds = YES;
    _login.layer.cornerRadius = 8;
    _login.backgroundColor = [UIColor whiteColor];
    return footView;
}

#pragma mark - 倒计时代理
// 设置起始倒计时秒数
-(NSUInteger)startCountDownNumOfCountDownButton:(CQCountDownButton *)countDownButton {
    return 60;
}
// 倒计时进行中的回调
- (void)countDownButtonDidInCountDown:(CQCountDownButton *)countDownButton withRestCountDownNum:(NSInteger)restCountDownNum {
    NSString *title = [NSString stringWithFormat:@"%ld秒后重试", restCountDownNum];
    [_verifyBtn setTitle:title forState:UIControlStateNormal];
}
// 倒计时结束时的回调
- (void)countDownButtonDidEndCountDown:(CQCountDownButton *)countDownButton {
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

// 倒计时按钮点击回调
- (void)countDownButtonDidClick:(CQCountDownButton *)countDownButton {
    if (![self.phoneNum isPhone]) {
        showAlert(@"请输入正确的手机号或邮箱", self);
        return;
    }
    NSString *type = @"phone";
    NSDictionary *parameters = @{@"account": self.phoneNum,@"type": type};

    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_verifyCode parameters:parameters reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            [countDownButton startCountDown];//开始倒计时
        }
     }];
}

- (void)bindPhone
{
    DJReadUser *user = [DJReadManager shareManager].loginUser;
    NSDictionary *params = @{
        @"openid":user.openid,
        @"phonenum":self.phoneNum,
        @"code":self.verifyCode,
    };
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_PhoneBind parameters:params reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {///成功
            dispatch_async(dispatch_get_main_queue(), ^{
                showAlert(@"绑定成功", self);
                user.uphone = self.phoneNum;
                [[CSCoreDataManager shareManager] updataUserInfo:user];
                [[CSCoreDataManager shareManager] cacheUser:user];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}
@end
