//
//  PersonalDataViewController.m
//  DJReader
//
//  Created by liugang on 2020/5/14.
//  Copyright © 2020 Andersen. All rights reserved.
#import "PersonalDataViewController.h"
#import "UIColor+DrakMode.h"
#import "HWPopController.h"
#import "HWPop.h"
#import "Masonry.h"
#import "DJReadNetManager.h"
#import "DJReadManager.h"
#import "CSCoreDataManager.h"
#import "BindPhoneController.h"
#import "UserDetailCell.h"

#define headHeight 100
#define userPhoneKey @"手机"
#define userIDKey @"用户ID"
#define useraccountKey @"用户账户"
#define usernameKey @"昵称"
#define userHeaderImage @"avater"

@class BottomBoxVc;
@interface PersonalDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *headView,*footerView;
@property (nonatomic,strong) UITableView * listTableView;
@property (nonatomic,strong) NSArray * userInfo;
@property (nonatomic,strong) NSMutableDictionary *infoParam;
@end
@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfo = [NSArray arrayWithObjects:usernameKey,userIDKey,userPhoneKey, nil];
    [self setNavVc];
    [self setUI];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [super viewWillAppear:animated];
    self.originController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.originController.tabBar.hidden = NO;
}
- (BOOL)loadDataAdmin
{
    DJReadUser *user = [DJReadManager shareManager].loginUser;
    if ([user.account isEqualToString: AdminManager]) {
        [self.infoParam setValue:@"管理员" forKey:usernameKey];
        [self.infoParam setValue:[NSString stringWithFormat:@"%lld",user.id] forKey:userIDKey];
        [self.infoParam setValue:user.account forKey:useraccountKey];
        [self.infoParam setValue:user.name forKey:usernameKey];
        [self.infoParam setValue:user.uphone forKey:userPhoneKey];
        [self.listTableView reloadData];
        return YES;
    }else{
        return NO;
    }
}
- (void)loadData
{
    if ([self loadDataAdmin]) {
        return;
    }
    DJReadUser *user = [DJReadManager shareManager].loginUser;
    ///服务器已有的账户
    self.infoParam = [[NSMutableDictionary alloc]init];
    [self.infoParam setValue:user.nickname forKey:usernameKey];
    [self.infoParam setValue:user.uphone forKey:userPhoneKey];
    [self.infoParam setValue:user.avatar forKey:userHeaderImage];
    [self.infoParam setValue:user.firsttime forKey:userIDKey];
    
    if (!user.openid) {
        [self.infoParam setValue:user.uphone forKey:usernameKey];
    }
    if (![user.uphone isPhone])
    {
        [self.infoParam setValue:@"未绑定" forKey:userPhoneKey];
    }
    [self.listTableView reloadData];
}
-(void)setNavVc{
    if (@available(iOS 13.0, *))
    {
        self.navigationController.navigationBar.backgroundColor = [UIColor systemBackgroundColor];
        }else{
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    }
    self.title = @"个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
#pragma mark - setUI
-(void)setUI{
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listTableView];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).mas_equalTo(30);
        make.right.equalTo(self.view).mas_equalTo(-30);
        make.bottom.equalTo(self.view);
    }];
    _listTableView.backgroundColor = [UIColor whiteColor];
    UIButton *loginOut =[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height - 120, self.view.width, 40)];
    [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [loginOut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    loginOut.layer.masksToBounds = YES;
    loginOut.layer.cornerRadius = 5;
    [loginOut setTitle:@"退出登入" forState:UIControlStateNormal];
    [self.view addSubview:loginOut];
    
    [loginOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(40));
        make.left.equalTo(self.view).mas_equalTo(30);
        make.right.equalTo(self.view).mas_equalTo(-30);
        make.bottom.equalTo(self.view).offset(-40);
    }];
}
#pragma mark - 控件
- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc]init];
        _headView.frame = CGRectMake(0, 0, self.view.width, 120);
        
        UIImageView *headImage = [[UIImageView alloc]init];
        DJReadUser *user = [DJReadManager shareManager].loginUser;
        
        NSURL *imgURL = [NSURL URLWithString:user.avatar];
        if (user.avatar.length >= 8) {
            headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]];
        }else{
            headImage.image = [UIImage imageNamed:@"默认头像"];
        }
        headImage.contentMode = 1;
        [_headView addSubview:headImage];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(@(80));
            make.centerY.equalTo(_headView);
            make.right.equalTo(_headView);
        }];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 40;
        
        UILabel *headTitle = [[UILabel alloc]init];
        headTitle.text = @"头像";
        headTitle.textAlignment = NSTextAlignmentLeft;
        headTitle.font = [UIFont boldSystemFontOfSize:20];
        [_headView addSubview:headTitle];
        [headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView);
            make.centerY.equalTo(headImage);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor grayColor];
        [_headView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headTitle);
            make.right.equalTo(headImage);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(_headView);
        }];
    }
    return _headView;
}
- (UIView*)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.listTableView.width, 200)];
        UIButton *loginOut =[[UIButton alloc]initWithFrame:CGRectMake(0, 160, _footerView.width, 40)];
        [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
        [loginOut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        loginOut.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        loginOut.layer.masksToBounds = YES;
        loginOut.layer.cornerRadius = 5;
        [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [_footerView addSubview:loginOut];
    }
    return _footerView;
}
- (UITableView *)listTableView{
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listTableView.scrollEnabled = NO;
        _listTableView.tableFooterView = [UIView new];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    };
    return _listTableView;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userInfo.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 200;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UserDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    //取消选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *detail = [_infoParam objectForKey:_userInfo[indexPath.row]];
    [cell setLab:_userInfo[indexPath.row] andImage:[UIImage imageNamed:@"Me_selected"]andValue:detail];
    
    if ([detail isEqualToString:@"未绑定"]) {
        [cell addAction:@selector(gotoBindController) toTargt:self title:@"去绑定"];
    }
    [cell reloadSubView];
    return cell;
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return self.footerView;
//}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_infoParam objectForKey:_userInfo[indexPath.row]] isEqualToString:@"未绑定"]) {
        [self gotoBindController];
    }
}
- (void)gotoBindController
{
    BindPhoneController *bindVC = [[BindPhoneController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:bindVC];
    navc.modalPresentationStyle = 0;
    [self presentViewController:navc animated:YES completion:nil];
}
- (void)loginOutAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.loginOut) {
            self.loginOut();
        }
    }];
}
@end


