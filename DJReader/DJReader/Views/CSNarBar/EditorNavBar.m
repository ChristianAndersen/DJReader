//
//  EditorNavBar.m
//  DJReader
//
//  Created by Andersen on 2020/3/13.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "EditorNavBar.h"
#import "CSNavBar.h"
#import "HEMenu.h"
#import "CSCoreDataManager.h"
#import "CSImportImageView.h"
@interface EditorNavBar()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)EditorNavBarType type;
@property (nonatomic,strong)CSNavBar *bar;
@end
@implementation EditorNavBar
- (instancetype)initWithFrame:(CGRect)frame andType:(EditorNavBarType)type
{
    if(self = [super initWithFrame:frame]){
        _type = type;
        [self createSubViews];
    }
    return self;
}
- (void)layoutSubviews
{
    self.backgroundColor = [UIColor drakColor:DrakModeColor lightColor:LightModeColor];
}
- (void)createSubViews
{
    switch (_type) {
        case EditorNavBarTypeBrowse:{
            _bar = [[CSNavBar alloc]initWithFrame:self.frame];
            [_bar cleanItems];
            [self addSubview:_bar];
            [self loadBorwseItems];
        }break;
        case EditorNavBarTypeText:{
            _bar = [[CSNavBar alloc]initWithFrame:self.frame];
            [_bar cleanItems];
            [self loadTextItems];
        }break;
        case EditorNavBarTypeSeal:{
            _bar = [[CSNavBar alloc]initWithFrame:self.frame];
            [_bar cleanItems];
            [self loadSealItems];
        }break;
        case EditorNavBarTypeHand:{
            _bar = [[CSNavBar alloc]initWithFrame:self.frame];
            [_bar cleanItems];
            [self loadHandItems];
        }break;
        default:
            break;
    }
}
- (void)changeType:(EditorNavBarType)type
{
    _type = type;
    switch (_type) {
        case EditorNavBarTypeBrowse:{
            [_bar cleanItems];
            [self addSubview:_bar];
            [self loadBorwseItems];
        }
            break;
        case EditorNavBarTypeText:{
            [_bar cleanItems];
            [self loadTextItems];
        }
            break;
        case EditorNavBarTypeSeal:{
            [_bar cleanItems];
            [self loadSealItems];
        }
            break;
        case EditorNavBarTypeHand:{
            [_bar cleanItems];
            [self loadHandItems];
        }
            break;
        default:
            break;
    }
}
- (void)loadBorwseItems
{
    _bar.responseType = CSNavBarResponseDouble;
//    [_bar setRightItem:Action_ImportImage target:self action:@selector(itemclicked:) haslight:NO];
    [_bar setLeftItems:Action_Back target:self action:@selector(itemclicked:) haslight:NO];
    [_bar setRightItem:Action_Share target:self action:@selector(itemclicked:) haslight:NO];
    [_bar setRightItem:Action_Save target:self action:@selector(itemclicked:) haslight:NO];
    [_bar setRightItem:Action_Star target:self action:@selector(itemclicked:) haslight:YES];
    [_bar reloadItemWithVerticalOffset:0.6];
}
- (void)loadTextItems
{
    _bar.responseType = CSNavBarResponseSingle;
    [_bar setLeftItems:Action_Exit target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_LuRu target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_PaiBan target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_Undo target:self action:@selector(itemclicked:) haslight:NO];
    [_bar reloadItemWithVerticalOffset:0.6];
    [self setSelectedItem:Action_LuRu];
}
- (void)loadSealItems
{
    _bar.responseType = CSNavBarResponseSingle;

    [_bar setLeftItems:Action_Exit target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_Undo target:self action:@selector(itemclicked:) haslight:NO];
    [_bar reloadItemWithVerticalOffset:0.6];
}
- (void)loadHandItems
{
    _bar.responseType = CSNavBarResponseSingle;
    [_bar setLeftItems:Action_Exit target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_Hand target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_PaiBan target:self action:@selector(itemclicked:) haslight:YES];
    [_bar setRightItem:Action_Undo target:self action:@selector(itemclicked:) haslight:NO];
    [_bar reloadItemWithVerticalOffset:0.6];
    [self setSelectedItem:Action_Hand];
}
- (void)setStar:(BOOL)star
{
    for (UIButton *btn in self.bar.subviews) {
        if ([btn.titleLabel.text isEqualToString:@"标星"]) {
            btn.selected = star;
        }
    }
}
- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action
{
    [self.bar setRightItem:title target:target action:action];
}
- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action
{
    [self.bar setLeftItems:title target:target action:action];
}
- (void)setSelectedItem:(NSString*)title
{
    if (self.bar.responseType == CSNavBarResponseDouble) {
        for (UIButton *btn in self.bar.subviews) {
            if ([btn.titleLabel.text isEqualToString:title]) {
                btn.selected = !btn.selected;
            }
        }
    }
    if (self.bar.responseType == CSNavBarResponseSingle) {
        for (UIButton *btn in self.bar.subviews) {
            if ([btn.titleLabel.text isEqualToString:title]) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
}
- (void)setSelectedSingleItem:(NSString *)title
{
    if (self.bar.responseType == CSNavBarResponseSingle) {
        for (UIButton *btn in self.bar.subviews) {
            if ([btn.titleLabel.text isEqualToString:title]) {
                btn.selected = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(navBar:type:selectItem:)]) {
                    [self.delegate navBar:self type:_type selectItem:title];
                }
            }else{
                btn.selected = NO;
            }
        }
    }
}
- (void)reloadItems
{
    [self.bar reloadItemWithVerticalOffset:0.6];
    NSLog(@"nav reload finished");
}
- (void)itemclicked:(UIButton*)sender
{
    if (([sender.titleLabel.text isEqualToString:Action_Star])&&![[DJReadManager shareManager]isLoging]) {
        NSLog(@"%@",sender.titleLabel.text);
    }else{
        [self setSelectedItem:sender.titleLabel.text];//修改按钮是否高亮
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBar:type:selectItem:)]) {
        [self.delegate navBar:self type:_type selectItem:sender.titleLabel.text];
    }
}
@end
