//
//  CSSingleBar.m
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSSingleBar.h"
@interface CSSingleBar()
@property (nonatomic)CGFloat itemWidth;
@property (nonatomic)UIView *backgroundView;
@end

@implementation CSSingleBar

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
    _backgroundView = [[UIView alloc]init];
    [self addSubview:_backgroundView];
    
    [self setTranslucent:NO];
}
- (void)layoutSubviews{
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = self.minimumContentHeight;
    //TabBar背景图的frame
    [self.backgroundView setFrame:CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)];
    CGFloat itemInterval = self.contentEdgeInsets.left;
    CGFloat itemWidth = (frameSize.width -itemInterval * (self.items.count+1))/self.items.count;
    
    [self setItemWidth:round(itemWidth)];
    NSInteger index = 0;
    for (CSSignBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max ||IS_IPHONE_Xs) {
            [item setFrame:CGRectMake(itemInterval*(index + 1) + (index *self.itemWidth), round(frameSize.height - itemHeight - 10)-self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        }else {
            [item setFrame:CGRectMake(itemInterval*(index + 1) + (index *self.itemWidth), round(frameSize.height - itemHeight)-self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
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
    for (CSSignBarItem *item in items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (CSSignBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        item.layer.shadowColor = [UIColor blackColor].CGColor;
        item.layer.shadowOffset = CGSizeMake(1, 1);
        item.layer.shadowRadius = 4;
        item.layer.shadowOpacity = 0.4;
    }
}

- (void)setHeight:(CGFloat)height{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minmumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (CSSignBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minmumTabBarContentHeight)) {
            minmumTabBarContentHeight = itemHeight;
        }
    }
    return minmumTabBarContentHeight;
}
- (void)tabBarItemWasSelected:(id)sender{
    BOOL isSelected = NO;
    NSUInteger index = [self.items indexOfObject:sender];
    if (index == 1 && ![DJReadManager shareManager].loginUser.isvip) {
        if (sender != _selectedItem) {
            isSelected = YES;
        }
        if ([self.delegate respondsToSelector:@selector(singleBar:didSelectItemAtIndex:selected:)]) {
            [self.delegate singleBar:self didSelectItemAtIndex:index selected:isSelected];
        }
    }else{
        if (sender != _selectedItem) {
            isSelected = YES;
        }
        //如果点击的是签名盖章按钮，需要去检查是否是VIP，如果是，才改变按钮状态
        [self setSelectedItem:sender];
        
        if ([self.delegate respondsToSelector:@selector(singleBar:didSelectItemAtIndex:selected:)]) {
            [self.delegate singleBar:self didSelectItemAtIndex:index selected:isSelected];
        }
    }
}

- (void)setSelectedItem:(CSSignBarItem *)selectedItem{
    if (selectedItem == _selectedItem) {
        [_selectedItem setSelected:NO];
        _selectedItem = nil;
        return;
    }else{
        [_selectedItem setSelected:NO];
        _selectedItem = selectedItem;
        [_selectedItem setSelected:YES];
    }
//    if (selectedItem != _selectedItem) {
//        [_selectedItem setSelected:NO];
//        _selectedItem = selectedItem;
//        [_selectedItem setSelected:YES];
//    }
}

- (void)setTranslucent:(BOOL)translucent{
    _translucent = translucent;
    CGFloat aplha = ( translucent ? 0.9:1.0);
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:aplha]];
}
@end
