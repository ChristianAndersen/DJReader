//
//  CSSheetManager.m
//  ZmjPickView
//
//  Created by Andersen on 2020/9/22.
//  Copyright © 2020 郑敏捷. All rights reserved.
//
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CSSheetManager.h"
#import <MBProgressHUD.h>
@interface CSSheetManager()
@end

@implementation CSSheetManager
static MBProgressHUD *_hud;
+ (void)showHud:(NSString*)msg atView:(UIView*)view
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = msg;
    [_hud showAnimated:YES];
}
+ (void)hiddenHud
{
    [_hud hideAnimated:YES];
}
- (void)showView:(UIView*)view inParent:(UIView*)parent;
{
    _sheet = [[CSSheetView alloc]init];
    [_sheet showView:view inParent:parent];
}
- (void)reloadContentHeight:(CGFloat)height;
{
    [_sheet reloadContentHeight:height];
}
- (void)dismiss
{
    [_sheet dismiss];
}
@end
