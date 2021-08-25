//
//  SealAttributeView.m
//  DJReader
//
//  Created by Andersen on 2020/3/17.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SealAttributeView.h"
#import <DJContents/ADSFunc.h>
#import "DrawController.h"
#import "NSObject+prv_Method.h"
#import "DJProtocolManager.h"
#import "CertManagerController.h"
#import "DJReadNetManager.h"

@interface SealAttributeView()<SignSelectorDelegate>
@property(nonatomic,strong)UIButton *sealState,*signState,*createSeal;
@property(nonatomic,assign)NSInteger curState;
@property(nonatomic,strong)UILabel *selectedLine,*line1,*line2,*line3;
@end

@implementation SealAttributeView
{
    CGFloat btnWidth;
    CGFloat btnheight;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        btnWidth = 80;
        btnheight = 40;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    [self loadBtns];
    [self loadMainView];
}

- (void)loadMainView
{
    _sealSelector = [[SealSelector alloc]init];
    _sealSelector.selectorDelegate = self;
    [self addSubview:_sealSelector];
    [_sealSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.sealState.mas_bottom);
    }];
    _signSelector = [[SignSelector alloc]init];
    _signSelector.curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _signSelector.selectorDelegate = self;
    [self addSubview:_signSelector];
    [_signSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.sealState.mas_bottom);
    }];
    self.curState = 0;
}
- (void)setCurState:(NSInteger)curState
{
    if (curState == 0) {
        self.sealSelector.hidden = NO;
        self.signSelector.hidden = YES;
        self.sealState.selected = YES;
        self.signState.selected = NO;
    }else{
        self.sealSelector.hidden = YES;
        self.signSelector.hidden = NO;
        self.sealState.selected = NO;
        self.signState.selected = YES;
    }
}
- (void)loadBtns
{
    _sealState = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sealState setTitle:@"印章" forState:UIControlStateNormal];
    _sealState.frame = CGRectMake(0, 1, btnWidth, btnheight);

    [_sealState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
    [_sealState setImage:[UIImage imageNamed:@"盖章.jpg"] forState:UIControlStateNormal];
    _sealState.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/4, btnheight/4, btnWidth/8);
    _sealState.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/4, btnheight/4, btnWidth/2);
    _sealState.selected = YES;
    _sealState.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [_sealState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
    [_sealState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
    [_sealState addTarget:self action:@selector(sealStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sealState];
    
    _signState = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signState setTitle:@"签字" forState:UIControlStateNormal];
    _signState.frame = CGRectMake(btnWidth, 1, btnWidth, btnheight);
    [_signState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
    [_signState setImage:[UIImage imageNamed:@"签字"] forState:UIControlStateNormal];
    _signState.titleLabel.textAlignment = NSTextAlignmentLeft;
    _signState.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/4, btnheight/4, btnWidth/8);
    _signState.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/4, btnheight/4, btnWidth/2);
    
    _signState.titleLabel.font = [UIFont systemFontOfSize:12];
    [_signState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
    [_signState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
    [_signState addTarget:self action:@selector(signStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signState];
    
    _createSeal = [UIButton buttonWithType:UIButtonTypeCustom];
    _createSeal.frame = CGRectMake(self.width - btnWidth*1.2, 1, btnWidth*1.2, btnheight);
    [_createSeal setTitle:@"创建签名" forState:UIControlStateNormal];
    [_createSeal setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_createSeal setImage:[UIImage imageNamed:@"创建"] forState:UIControlStateNormal];
    _createSeal.titleLabel.font = [UIFont systemFontOfSize:12];
    _createSeal.titleEdgeInsets = UIEdgeInsetsMake(btnheight/5, 0, btnheight/5, btnWidth*1.2/8);
    _createSeal.imageEdgeInsets = UIEdgeInsetsMake(btnheight/5, 0, btnheight/5, btnWidth*1.2*3/4);
    [_createSeal addTarget:self action:@selector(createSealAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_createSeal];
    [_createSeal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.mas_equalTo(btnWidth*1.2);
        make.height.mas_equalTo(btnheight);
        make.centerY.equalTo(self.signState);
    }];
    
    _line1 = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2, 0, 1, btnheight)];
    _line1.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self addSubview:_line1];

    _line2 = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth, 0, 1, btnheight)];
    _line2.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self addSubview:_line2];
    
    _line3 = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2, btnheight, self.width - btnWidth*2, 2)];
    _line3.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self addSubview:_line3];
    
    _selectedLine = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth, btnheight, btnWidth, 2)];
    _selectedLine.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self addSubview:_selectedLine];
}

- (void)sealStateAction:(UIButton*)sender
{
    _selectedLine.frame = CGRectMake(btnWidth, 40, btnWidth, 2);
    _sealState.selected = YES;
    _sealState.frame = CGRectMake(0, 1, btnWidth, btnheight);
    _signState.selected = NO;
    _signState.frame = CGRectMake(btnWidth, 1, btnWidth, btnheight);
    self.curState = 0;
}

- (void)signStateAction:(UIButton*)sender
{
    _selectedLine.frame = CGRectMake(0, 40, btnWidth, 2);
    _sealState.selected = NO;
    _sealState.frame = CGRectMake(0, 1, btnWidth, btnheight);
    _signState.selected = YES;
    _signState.frame = CGRectMake(btnWidth, 1, btnWidth, btnheight);
    self.curState = 1;
}

- (void)createSealAction:(UIButton*)sender
{
    if (self.createSealhander)
        self.createSealhander();
}
- (void)deleteSeal:(NSString*)sealID
{
    [DJReadNetShare deleteSeal:sealID complete:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            UIViewController *controller = (UIViewController *)self.controller;
            showAlert(@"删除成功", controller);
            [self.signSelector reloadSignSelector];
        }
    }];
}
- (void)selector:(SignSelector *)selector didSelected:(DJSignSeal *)signSeal
{
    UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"选择签名证书" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (signSeal) {
            [DJReadManager shareManager].curSeal = signSeal;
            if (self.certDidSelected) {self.certDidSelected();}
        }
    }];
    UIAlertAction *action_03 = [UIAlertAction actionWithTitle:@"不使用证书签名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (signSeal) {
            [DJReadManager shareManager].curSeal = signSeal;
        }
    }];
    UIViewController *controller = (UIViewController *)self.controller;
    addActionsToTarget(controller, @[action_01,action_03]);

}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    UIColor *normalColor,*selectedColor;
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
             normalColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                 if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return DrakModeColor;
                 }else{
                    return [UIColor colorWithWhite:0.95 alpha:1.0];
                 }
            }];
            selectedColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return RGBACOLOR(60, 60, 60, 1);
                }else{
                    return [UIColor whiteColor];
                }
            }];
            [_signState setBackgroundImage:ImageWithColor(selectedColor) forState:UIControlStateSelected];
            [_signState setBackgroundImage:ImageWithColor(normalColor) forState:UIControlStateNormal];
            
            [_sealState setBackgroundImage:ImageWithColor(selectedColor) forState:UIControlStateSelected];
            [_sealState setBackgroundImage:ImageWithColor(normalColor) forState:UIControlStateNormal];
            
            [_createSeal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_signState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sealState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [_signState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
            [_signState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
             
            [_sealState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
            [_sealState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
             
            [_createSeal setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [_signState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
            [_sealState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
        }
     } else {
        [_signState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
        [_signState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
         
        [_sealState setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateSelected];
        [_sealState setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.95 alpha:1]) forState:UIControlStateNormal];
         
        [_createSeal setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_signState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
        [_sealState setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
     }
}
@end
