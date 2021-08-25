//
//  CertManagerController.m
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//
#import "CertManagerController.h"
#import "CertificateCell.h"
#import "DJReadNetManager.h"
#import <MJExtension.h>
#import "CertApplyController.h"
#import "BindPhoneController.h"
#import <MBProgressHUD.h>

@interface CertManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainView;
@property (nonatomic,strong)UIButton *createCert;
@property (nonatomic,strong)NSMutableArray *certModels;
@property (nonatomic,strong)UIImageView *backHead;
@property (nonatomic,strong)UIView *footView,*headView;
@property (nonatomic,copy)NSString *uphone,*openid;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation CertManagerController
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)forceChangeToOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadCerts];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadCerts];
    self.view.backgroundColor = CSWhiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)loadNoCerts
{
    CGFloat intervalH = self.backHead.height/6;
    
    UIView *nocertBack = [[UIView alloc]initWithFrame:CGRectMake(30, intervalH, self.backHead.width - 60, self.backHead.height - intervalH*2)];
    nocertBack.backgroundColor = RGBACOLOR(231, 238, 246, 1);
    nocertBack.layer.masksToBounds = YES;
    nocertBack.layer.cornerRadius = 5;
    [self.backHead addSubview:nocertBack];
    
    UIImageView *noCertView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无数据"]];
    noCertView.contentMode = 1;
    [nocertBack addSubview:noCertView];
    noCertView.frame = nocertBack.bounds;
    
    UIButton *newCert = [UIButton buttonWithType:UIButtonTypeCustom];
    newCert.layer.masksToBounds = YES;
    newCert.layer.cornerRadius = 5;
    newCert.frame = CGRectMake(44, self.backHead.y + self.backHead.height + 44, self.backHead.width - 88, 44);
    [newCert addTarget:self action:@selector(createSealAction:) forControlEvents:UIControlEventTouchUpInside];
    [newCert setTitle:@"新的证书" forState:UIControlStateNormal];
    newCert.backgroundColor = ControllerDefalutColor;
    [self.view addSubview:newCert];
}
- (void)loadCerts
{
    self.certModels = [[NSMutableArray alloc]init];
    NSString *phonenum = [DJReadManager shareManager].loginUser.uphone;
    //openid = @"o-UtJ1RMTcN-Mt6dgQfELKDVXuDw";
    //phonenum = @"15001389169";
    NSMutableDictionary *params = [NSMutableDictionary new];

    if (phonenum.length == 11) {
        [params setValue:phonenum forKey:@"phonenum"];
        [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_CERTQuery parameters:params reponseResult:^(DJService *service) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger code = service.code;
                if (code == 0) {
                    NSArray *certs = service.dataResult;
                    NSMutableArray *certModels = [DJCertificate mj_objectArrayWithKeyValuesArray:certs];
                    self.certModels = [[NSMutableArray alloc]init];
                    for (DJCertificate *cert in certModels) {
                        if (cert.certstatus != 2) {
                            [self.certModels addObject:cert];
                        }
                    }
                    if (self.certModels.count == 0) {
                        self.mainView.hidden = YES;
                        [self loadNoCerts];
                    }else{
                        [self.mainView reloadData];
                    }
                }
            });
        }];
    }
}
- (UIView*)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4)];
        UIButton *newCert = [UIButton buttonWithType:UIButtonTypeCustom];
        newCert.layer.masksToBounds = YES;
        newCert.layer.cornerRadius = 5;
        newCert.frame = CGRectMake(15, self.view.height/10, self.backHead.width - 30, 44);
        [newCert addTarget:self action:@selector(createSealAction:) forControlEvents:UIControlEventTouchUpInside];
        [newCert setTitle:@"新的证书" forState:UIControlStateNormal];
        newCert.backgroundColor = ControllerDefalutColor;
        [_footView addSubview:newCert];
    }
    return _footView;
}
- (UIView*)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    }
    return _headView;
}
- (UITableView*)mainView
{
    if (!_mainView) {
        _mainView = ({
            UITableView *tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tab.backgroundColor = [UIColor clearColor];
            tab.delegate = self;
            tab.dataSource = self;
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            tab.tableFooterView = self.footView;
            tab.tableHeaderView = self.headView;
            tab;
        });
    }
    return _mainView;
}
- (UIImageView*)backHead
{
    if (!_backHead) {
        _backHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4)];
        _backHead.image = [UIImage imageNamed:@"backHead"];
        _backHead.userInteractionEnabled = YES;
    }
    return _backHead;
}
- (void)loadSubViews
{
    [self.view addSubview:self.backHead];
    [self.view addSubview:self.mainView];
    [self loadNav];
}
- (void)loadNav
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    CGFloat titleHeight = 24;
    
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

    _createCert = [UIButton buttonWithType:UIButtonTypeCustom];
    _createCert.frame = CGRectMake(0, 0, btnWidth, btnheight);
    [_createCert setTitleColor:CSTextColor forState:UIControlStateNormal];
    _createCert.titleLabel.font = [UIFont systemFontOfSize:14];
    [_createCert addTarget:self action:@selector(createSealAction:) forControlEvents:UIControlEventTouchUpInside];
    _createCert.titleLabel.textAlignment = NSTextAlignmentRight;
    [_createCert setImage:[UIImage imageNamed:@"创建"] forState:UIControlStateNormal];
    _createCert.imageEdgeInsets = UIEdgeInsetsMake((btnheight - titleHeight)/2, btnWidth - titleHeight, (btnheight - titleHeight)/2, 1.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_createCert];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)createSealAction:(UIButton*)sender
{
    if([DJReadManager shareManager].loginUser.isvip == 1){
        if (self.certModels.count == 1) {
            DJCertificate *cert = [self.certModels lastObject];
            if ([cert.certid isEqualToString:@"viptest000001001"] || [cert.certname isEqualToString:@"testcert.pfx"]) {
                CertApplyController *applyController = [[CertApplyController alloc]init];
                [self.navigationController pushViewController:applyController animated:YES];
            }else{
                ShowMessage(@"提示", @"证书仅能创建一个，不需要再重复创建", self);
            }
        }else if(self.certModels.count > 1){
            ShowMessage(@"提示", @"证书仅能创建一个，不需要再重复创建", self);
        }else{
            CertApplyController *applyController = [[CertApplyController alloc]init];
            [self.navigationController pushViewController:applyController animated:YES];
        }
    }else if([DJReadManager shareManager].loginUser.isvip != 1){
        ShowMessage(@"提示", @"非会员和赠送的会员无法创建证书", self);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_certModels count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identificer = @"certIdentificer";
    CertificateCell *cell = [[CertificateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (_certModels.count >= indexPath.row + 1)
    {
        cell.certificate = [self.certModels objectAtIndex:indexPath.row];
    }
    cell.scrollDeleted = ^(NSIndexPath * _Nonnull indexPath) {
        [self deletedCert:indexPath];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self);
    if ([self.title isEqualToString:@"请选择签名证书"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [DJReadManager shareManager].curCertificate = [weakself.certModels objectAtIndex:indexPath.row];
            if (weakself.certSeletedComplete)
                weakself.certSeletedComplete([DJReadManager shareManager].curCertificate);
        }];
    }
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self)
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself deletedCert:indexPath];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(RootController, action_01, action_02, @"是否确定删除证书，删除后不可恢复");
    }];
    NSArray *arr = @[deleteAction];
    return arr;
}
- (void)deletedCert:(NSIndexPath*)indexPath
{
    DJCertificate *cert = [self.certModels objectAtIndex:indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *openid = [DJReadManager shareManager].loginUser.openid;
    NSString *phoneNum = [DJReadManager shareManager].loginUser.uphone;
    NSString *certid = cert.certid;
    NSString *bussinessCode = cert.bussinessCode;
    NSString *reason = @"1";
    [params setValue:openid forKey:@"openid"];
    [params setValue:phoneNum forKey:@"phonenum"];
    [params setValue:certid forKey:@"certid"];
    [params setValue:bussinessCode forKey:@"bussinessCode"];
    [params setValue:reason forKey:@"reason"];
    [self showHUD];@WeakObj(self);
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_DeleteCert parameters:params showError:NO reponseResult:^(DJService *service) {
        [weakself hiddenHUD];
        NSInteger code = service.code;
        if (code == 0) {
            [weakself.certModels removeObject:cert];
            [weakself.mainView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            showAlert(@"删除失败", weakself);
        }
    }];
}
- (void)showHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = @"正在删除";
    [_hud showAnimated:YES];
}
- (void)hiddenHUD
{
    [_hud hideAnimated:YES];
}
- (void)dealloc
{
    _certSeletedComplete = nil;
}
@end
