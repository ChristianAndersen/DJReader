//
//  EditorControllView.m
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
#import "EditorControllView.h"
#import "CSSingleBar.h"

@interface EditorControllView()<CSSingBarDelegate>
@property (nonatomic,strong)CSSingleBar *controllBar;
@end

@implementation EditorControllView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self controllBar];
}

- (CSSingleBar*)controllBar{
    if (!_controllBar) {
        _controllBar = [[CSSingleBar alloc]initWithFrame:self.bounds];
        [_controllBar setDelegate:self];
    }
    [self addSubview:_controllBar];
    return _controllBar;
}

- (void)setControlls:(NSDictionary*)items
{
    NSMutableArray *controllBarItems = [[NSMutableArray alloc]init];
    for (NSString *title in items.allKeys) {
        CSSignBarItem *controllBarItem = [[CSSignBarItem alloc]init];
        [controllBarItem setTitle:title];
        [controllBarItems addObject:controllBarItem];
    }
    [self.controllBar setItems:controllBarItems];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = items.allValues;
    NSArray *tabBarItemTitles = items.allKeys;
    NSInteger index = 0;
    for (CSSignBarItem *item in [[self controllBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
    }
}
- (void)setControllsWithImage:(NSArray*)items
{
    NSMutableArray *controllBarItems = [[NSMutableArray alloc]init];
    for (int i = 0;i<items.count;i++) {
        CSSignBarItem *controllBarItem = [[CSSignBarItem alloc]init];
        controllBarItem.shouldRound = YES;
        [controllBarItems addObject:controllBarItem];
    }
    [self.controllBar setItems:controllBarItems];
    NSInteger index = 0;
    for (CSSignBarItem *item in [[self controllBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [items objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [items objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}
#pragma CSSingleBarDelegate
- (BOOL)singleBar:(CSSingleBar*)tabBar shouldSelectItemAtIndex:(NSInteger)index selected:(BOOL)selected
{
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(controllView:shouldSelectControll:selected:)]) {
        [self.selectDelegate controllView:self shouldSelectControll:index selected:selected];
    }
    return YES;
}
- (void)singleBar:(CSSingleBar*)tabBar didSelectItemAtIndex:(NSInteger)index selected:(BOOL)selected
{
    if (selected == NO) return;
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(controllView:didSelectControll:selected:)]) {
        [self.selectDelegate controllView:self didSelectControll:index selected:selected];
    }
}

@end
