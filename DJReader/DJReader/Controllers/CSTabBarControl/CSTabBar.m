//
//  CSTabBar.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/26.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTabBar.h"
#import "CSTabBarItem.h"
@interface CSTabBar ()
@property (nonatomic)CGFloat itemWidth;
@property (nonatomic)UIView *backgroundView;
@end
@implementation CSTabBar
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}
- (id)init {
    return [self initWithFrame:CGRectZero];
}
- (void)commonInitialization{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    _backgroundView = [[UIView alloc]init];
    [self addSubview:_backgroundView];
    [self setTranslucent:NO];
}

- (void)layoutSubviews{
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = self.minimumContentHeight;
    //TabBar背景图的frame
    [self.backgroundView setFrame:CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)];
    //整个TabBar的长度减去左右两边的空隙除以按钮个数
    [self setItemWidth:round((frameSize.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right)/self.items.count)];
    NSInteger index = 0;
    for (CSTabBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max ||IS_IPHONE_Xs) {
            [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index *self.itemWidth), round(frameSize.height - itemHeight)-self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        }else {
            [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index *self.itemWidth), round(frameSize.height - itemHeight)-self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        }
        //按钮图片位置
        [item setNeedsDisplay];
        index++;
    }
}
- (void)setItemWidth:(CGFloat)itemWidth{
    if (itemWidth>0) {
        _itemWidth = itemWidth;
    }
}
- (void)setItems:(NSArray *)items{
    for (CSTabBarItem *item in items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (CSTabBarItem *item in items) {
        item.badgeTextColor = [UIColor whiteColor];
        item.badgeTextFont = [UIFont systemFontOfSize:8];
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}
- (void)setHeight:(CGFloat)height{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}
- (CGFloat)minimumContentHeight {
    CGFloat minmumTabBarContentHeight = CGRectGetHeight([self frame]);
    for (CSTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minmumTabBarContentHeight)) {
            minmumTabBarContentHeight = itemHeight;
        }
    }
    return minmumTabBarContentHeight;
}

- (void)tabBarItemWasSelected:(id)sender{
    if ([self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![self.delegate tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [self.delegate tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(CSTabBarItem *)selectedItem{
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

- (void)setTranslucent:(BOOL)translucent{
    _translucent = translucent;
    CGFloat aplha = ( translucent ? 0.9:1.0);
    _backgroundView.backgroundColor = [UIColor drakColor:[UIColor blackColor] lightColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:aplha]];
}
@end
