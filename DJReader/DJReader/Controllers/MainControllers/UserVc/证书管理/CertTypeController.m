//
//  CertTypeController.m
//  DJReader
//
//  Created by Andersen on 2020/9/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CertTypeController.h"
#import "CSRadio.h"
//#import "CertRequestController.h"
#import "CertApplyController.h"
@interface CertTypeController ()
@property (nonatomic,strong)CSRadio *radio_01,*radio_02;
@property (nonatomic,strong)UIButton *certTypeBtn_01,*certTypeBtn_02;
@property (nonatomic,assign)NSInteger certType;
@end

@implementation CertTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
}

- (void)loadSubviews
{
    @WeakObj(self);
    self.certType = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = CSBackgroundColor;
    CGFloat itemWidth = self.view.width/3;
    CGFloat interval = itemWidth/3;
    _certTypeBtn_01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certTypeBtn_01 addTarget:self action:@selector(certTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_certTypeBtn_01 setImage:[UIImage imageNamed:@"个人证书"] forState:UIControlStateNormal];
    [_certTypeBtn_01 setTitle:@"个人" forState:UIControlStateNormal];
    [_certTypeBtn_01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _certTypeBtn_01.titleLabel.textAlignment = NSTextAlignmentCenter;
    _certTypeBtn_01.layer.masksToBounds = YES;
    _certTypeBtn_01.layer.borderColor = [UIColor grayColor].CGColor;
    _certTypeBtn_01.layer.borderWidth = 1.0;
    _certTypeBtn_01.layer.cornerRadius = 5.0;
    
    _certTypeBtn_02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certTypeBtn_02 addTarget:self action:@selector(certTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_certTypeBtn_02 setImage:[UIImage imageNamed:@"企业证书"] forState:UIControlStateNormal];
    [_certTypeBtn_02 setTitle:@"企业" forState:UIControlStateNormal];
    [_certTypeBtn_02 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _certTypeBtn_02.layer.masksToBounds = YES;
    _certTypeBtn_02.layer.borderColor = [UIColor grayColor].CGColor;
    _certTypeBtn_02.layer.borderWidth = 1.0;
    _certTypeBtn_02.layer.cornerRadius = 5.0;
    [self.view addSubview:_certTypeBtn_01];
    [self.view addSubview:_certTypeBtn_02];
    
    [_certTypeBtn_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).offset(interval);
        make.left.equalTo(weakself.view).offset(interval);
        make.width.mas_equalTo(@(itemWidth));
        make.height.mas_equalTo(@(itemWidth));
    }];
    [_certTypeBtn_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).offset(interval);
        make.right.equalTo(weakself.view).offset(-interval);
        make.width.mas_equalTo(@(itemWidth));
        make.height.mas_equalTo(@(itemWidth));
    }];
    _certTypeBtn_01.titleEdgeInsets = UIEdgeInsetsMake(itemWidth*3/4, -itemWidth/4, -1.0, itemWidth/4);
    _certTypeBtn_01.imageEdgeInsets = UIEdgeInsetsMake(itemWidth/8, itemWidth/4, itemWidth/4, itemWidth/4);
    _certTypeBtn_02.titleEdgeInsets = UIEdgeInsetsMake(itemWidth*3/4, -itemWidth/4, -1.0, itemWidth/4);
    _certTypeBtn_02.imageEdgeInsets = UIEdgeInsetsMake(itemWidth/8, itemWidth/4, itemWidth/4, itemWidth/4);

    _radio_01 = [[CSRadio alloc]init];
    _radio_01.selected = YES;
    [_radio_01 addTarget:self action:@selector(certTypeSelected:)];
    [self.view addSubview:_radio_01];
    
    _radio_02 = [[CSRadio alloc]init];
    _radio_02.selected = NO;
    [_radio_02 addTarget:self action:@selector(certTypeSelected:)];
    [self.view addSubview:_radio_02];
    
    [_radio_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_certTypeBtn_01);
        make.height.mas_equalTo(@(itemWidth/4));
        make.left.equalTo(_certTypeBtn_01);
        make.top.equalTo(_certTypeBtn_01.mas_bottom);
    }];
    
    [_radio_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_certTypeBtn_02);
        make.height.mas_equalTo(@(itemWidth/4));
        make.right.equalTo(_certTypeBtn_02);
        make.top.equalTo(_certTypeBtn_02.mas_bottom);
    }];
    
    UIButton *newCert = [UIButton buttonWithType:UIButtonTypeCustom];
    newCert.layer.masksToBounds = YES;
    newCert.layer.cornerRadius = 5;
    [newCert addTarget:self action:@selector(gotoRequestController) forControlEvents:UIControlEventTouchUpInside];
    [newCert setTitle:@"确认" forState:UIControlStateNormal];
    newCert.backgroundColor = ControllerDefalutColor;
    [self.view addSubview:newCert];
    
    [newCert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.radio_01.mas_bottom).offset(80);
        make.left.equalTo(weakself.radio_01);
        make.right.equalTo(weakself.radio_02);
        make.height.mas_equalTo(@(44));
    }];
}

- (void)certTypeSelected:(UIControl*)sender
{
    if ([sender isEqual:_radio_01] || [sender isEqual:_certTypeBtn_01]) {
        _radio_01.selected = YES;
        _radio_02.selected = NO;
        _certType = 0;
    }else{
        _radio_01.selected = NO;
        _radio_02.selected = YES;
        _certType = 1;
    }
}

- (void)gotoRequestController
{
    CertApplyController *applyController = [[CertApplyController alloc]init];
    applyController.certType = self.certType;
    [self.navigationController pushViewController:applyController animated:YES];

//    CertRequestController *requestController = [[CertRequestController alloc]init];
//    requestController.certType = self.certType;
//    [self.navigationController pushViewController:requestController animated:YES];
}
@end
