//
//  HEMenuC.m
//  YHMenu
//
//  Created by Boris on 2018/5/10.
//  Copyright © 2018年 Boris. All rights reserved.
//

#import "HEMenu.h"

@interface HEMenu ()

@property (nonatomic, strong) MenuView *menuView;

@end

@implementation HEMenu


+ (HEMenu *) shareManager {
    static HEMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[HEMenu alloc]init];
    });
    
    return menu;
}

- (void)showMenuWithSize:(CGSize)size point:(CGPoint)point itemSource:(NSDictionary *)itemSource style:(MenuStyle)style action:(void (^)(NSMutableDictionary *indexes))action{
    __weak __typeof(&*self)weakSelf = self;
    
    if (self.menuView != nil) {
        [weakSelf hideMenu];
    }
    
    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    self.menuView = [[MenuView alloc]initWithFrame:window.bounds menuSize:size point:point itemSource:itemSource style:style action:^(NSMutableDictionary *indexes) {
        if (style == MenuStyleSingle) {
            [weakSelf hideMenu];
        }
        if (action) {
            action(indexes);
        }
    }];

    _menuView.touchBlock = ^{
        [weakSelf hideMenu];
    };
    if (@available(iOS 13.0, *)) {
          
          self.menuView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                  return  [[UIColor blackColor]colorWithAlphaComponent:0.1f];
              }else{
                  return  [[UIColor lightGrayColor]colorWithAlphaComponent:0.25f];
              }
          }];
       } else {
            self.menuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
       }

    
    [window addSubview:self.menuView];

}

- (void) hideMenu {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
}



@end
