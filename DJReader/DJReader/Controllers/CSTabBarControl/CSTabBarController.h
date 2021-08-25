//
//  CSTabBarController.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/26.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTabBar.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CSTarBarControllerDelegate;

@interface CSTabBarController : UIViewController<CSTabBarDelegate>
@property (nonatomic,weak)id<CSTarBarControllerDelegate>delegate;
@property (nonatomic,copy)NSArray *viewControllers;
@property (nonatomic,readonly)CSTabBar *tabBar;
@property (nonatomic,weak)UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;//当前选中控制器索引
@property (nonatomic,getter=isTabBarHidden)BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@protocol CSTarBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(CSTabBarController*)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController;

- (void)tabBarController:(CSTabBarController*)tabBarController didSelectViewController:(nonnull UIViewController *)viewController;
@end


@interface UIViewController(CSTabBarControllerItem)
@property(nonatomic,setter=cs_setTabBarItem:) CSTabBarItem *cs_tabBarItem;
@property (nonatomic,readonly)CSTabBarController *cs_tabBarController;
@end
NS_ASSUME_NONNULL_END
