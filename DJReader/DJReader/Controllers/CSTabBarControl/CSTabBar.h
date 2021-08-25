//
//  CSTabBar.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/26.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CSTabBar,CSTabBarItem;
@protocol CSTabBarDelegate <NSObject>
- (BOOL)tabBar:(CSTabBar*)tabBar shouldSelectItemAtIndex:(NSInteger)index;
- (void)tabBar:(CSTabBar*)tabBar didSelectItemAtIndex:(NSInteger)index;
@end

@interface CSTabBar : UIView
@property (nonatomic,weak)id <CSTabBarDelegate>delegate;
@property (nonatomic,copy) NSArray *items;
@property (nonatomic, weak)CSTabBarItem *selectedItem;
@property (nonatomic, readonly)UIView *backgroundView;
@property UIEdgeInsets contentEdgeInsets;

//设置是否半透明
@property (nonatomic, getter=isTransulcent) BOOL translucent;

- (void)setHeight:(CGFloat)height;
- (CGFloat)minimumContentHeight;

@end

NS_ASSUME_NONNULL_END
