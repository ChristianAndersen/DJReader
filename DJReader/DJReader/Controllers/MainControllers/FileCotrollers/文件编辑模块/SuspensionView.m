//
//  SuspensionView.m
//  DJReader
//
//  Created by Andersen on 2020/9/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SuspensionView.h"
#import "EditorControllView.h"
#import "TextAtrributeView.h"
#import "HandAttributeView.h"
#import "SealAttributeView.h"
#import "NSObject+prv_Method.h"
#import "CertManagerController.h"
#import "DJReadManager.h"
#import "SubscribeController.h"
#import "CSTabBarMainController.h"
#import "FileEditorController.h"
#import "DrawController.h"
#import "SealSelector.h"
#import "SignSelector.h"

#define blank 30
#define controllInterval 10.0

@interface SuspensionView()<CSEditorControllViewDelegate>
@property (nonatomic,assign)BottomActionType actionType;
@property (nonatomic,strong)EditorControllView *controllBar;//三个圆形控制器视图
@property (nonatomic,strong)UIView *line;//分割线
@property (nonatomic,assign)CGFloat controllBarHeight,reviceHeight,controllWidth;

@property (nonatomic,strong)TextAtrributeView *textAttributeMenu;//文字属性控制视图
@property (nonatomic,strong)SealAttributeView *sealAttributeMenu;//手写属性控制试图
@property (nonatomic,strong)HandAttributeView *handAttributeMenu;//手写属性控制试图
@end

@implementation SuspensionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self controllBar];
    [self handAttributeMenu];
}
- (EditorControllView*)controllBar
{
    if (!_controllBar) {
        NSArray *controllItemImages = @[@"handControll", @"SealControll", @"TextControll"];
        _controllBar = [[EditorControllView alloc]initWithFrame:CGRectMake(controllInterval, controllInterval, self.width, self.controllBarHeight)];
        _controllBar.selectDelegate = self;
        [_controllBar setControllsWithImage:controllItemImages];
        [self addSubview:_controllBar];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.controllBar.mas_bottom);
            make.height.mas_equalTo(@(1.0));
        }];
    }
    return _controllBar;
}

- (TextAtrributeView*)textAttributeMenu{
    if (! _textAttributeMenu) {
        _textAttributeMenu = [[TextAtrributeView alloc]init];
        [self addSubview:_textAttributeMenu];
        [_textAttributeMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.controllBar.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _textAttributeMenu;
}

- (HandAttributeView*)handAttributeMenu{
    if (!_handAttributeMenu) {
        _handAttributeMenu = [[HandAttributeView alloc]init];
        [self addSubview:_handAttributeMenu];
        [_handAttributeMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.line.mas_bottom);
        }];
    }
    return _handAttributeMenu;
}
- (SealAttributeView*)sealAttributeMenu{
    if (!_sealAttributeMenu) {
        @WeakObj(self)
        _sealAttributeMenu = [[SealAttributeView alloc]init];
        _sealAttributeMenu.parentView = self;
        _sealAttributeMenu.controller = self.parentController;
        _sealAttributeMenu.createSealhander = ^{
            DrawController *dvc = [[DrawController alloc]init];
            dvc.modalPresentationStyle = 0;
            dvc.imageSelectedBlcok = ^(UIImage *image) {
            };
            [weakself.parentController presentViewController:dvc animated:YES completion:nil];
        };
        _sealAttributeMenu.certDidSelected = ^{
            CertManagerController *manager = [[CertManagerController alloc]init];
            manager.title = @"请选择签名证书";
            manager.modalPresentationStyle = UIModalPresentationCustom;
            manager.certSeletedComplete = ^(DJCertificate * _Nonnull certificate) {
                if (weakself.actionDelegate && [weakself.actionDelegate respondsToSelector:@selector(suspension:selectedCertificate:)]) {
                    [DJReadManager shareManager].curCertificate = certificate;
                    [weakself.actionDelegate suspension:weakself selectedCertificate:certificate];
                }
            };
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manager];
            nav.modalPresentationStyle = UIModalPresentationCustom;
            [weakself.parentController presentViewController:nav animated:YES completion:nil];
        };
        [self addSubview:_sealAttributeMenu];
        [_sealAttributeMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.line.mas_bottom);
        }];
    }
    return _sealAttributeMenu;
}
- (void)textControllAction:(BOOL)isActive{
    _actionType = BottomActionTypeText;
    _handAttributeMenu.hidden = YES;
    _sealAttributeMenu.hidden = YES;
}
- (void)sealControllAction:(BOOL)isActive{
    if (![DJReadManager shareManager].isVIP) {//签名盖章功能需要开通VIP
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SubscribeController *subscribeController = [SubscribeController new];
            subscribeController.originController = self.originController;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:subscribeController];
            nav.modalPresentationStyle = 0;
            [self.parentController presentViewController:nav animated:YES completion:nil];
            self.originController.tabBarHidden = YES;
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self.parentController, action_01, action_02, @"签名盖章功能需要开通VIP");
    }else{
        _actionType = BottomActionTypeSeal;
        _handAttributeMenu.hidden = YES;
        if (isActive == NO) {
            _sealAttributeMenu.hidden = YES;
            _handAttributeMenu.hidden = YES;
        }else{
            _handAttributeMenu.hidden = YES;
            _sealAttributeMenu.hidden = NO;
            [self sealAttributeMenu];
        }
    }
}

- (void)handControllAction:(BOOL)isActive{
    _actionType = BottomActionTypeHand;
    if (isActive == NO) {
        _handAttributeMenu.hidden = YES;
        _sealAttributeMenu.hidden = YES;
    }else{
        _handAttributeMenu.hidden = NO;
        _sealAttributeMenu.hidden = YES;
        [self handAttributeMenu];
    }
}
#pragma CSEditorControllViewDelegate
- (BOOL)controllView:(EditorControllView*)controllView shouldSelectControll:(NSInteger)selectIndex selected:(BOOL)selected
{
    return YES;
}
- (void)controllView:(EditorControllView*)controllView didSelectControll:(NSInteger)selectIndex selected:(BOOL)selected{
    switch (selectIndex) {
        case 0:{
            [self handControllAction:selected];
        }break;
        case 1:{
            [self sealControllAction:selected];
        }break;
        case 2:{
            [self textControllAction:selected];
        }break;
        default:
            break;
    }
    [self sendParams];
}
- (void)sendParams
{
    NSDictionary *parms;
    switch (_actionType) {
        case BottomActionTypeWait:{
            parms = nil;
        } break;
        case BottomActionTypeText:{
            parms = nil;
        } break;
        case BottomActionTypeHand:{
            parms = @{@"penWidth":@(_handAttributeMenu.penWidth),@"penAlpha":@(_handAttributeMenu.penAlpha),@"colorUnit":_handAttributeMenu.unit};
        } break;
        case BottomActionTypeSeal:{
            if (_sealAttributeMenu.curUnit) {
                parms = @{@"sealUnit":_sealAttributeMenu.curUnit};
            }
        } break;
        default:
            break;
    }
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(suspension:actionType:parms:)]) {
        [self.actionDelegate suspension:self actionType:_actionType parms:parms];
    }
}
- (CGFloat)controllBarHeight
{
    return controllInterval*2 + self.controllWidth;
}
- (CGFloat)controllWidth
{
    return (self.width - blank*2)/5;;
}
@end
