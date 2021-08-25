//
//  CSNavBar.m
//  DJReader
//
//  Created by Andersen on 2020/3/6.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define Item_Width 60
#import "CSNavBar.h"

@interface CSNavBar()
@property (nonatomic,strong)NSMutableArray *leftItems;
@property (nonatomic,strong)NSMutableArray *rightItems;
@property (nonatomic,strong)NSMutableArray *centerItems;
@property (nonatomic,assign)CSNavBarType type;
@end

@implementation CSNavBar
- (instancetype)init{
    if (self = [super init]) {
       [self initValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initValues];
    }
    return self;
}

- (void)initValues{
    self.userInteractionEnabled = YES;
    _leftItems = [[NSMutableArray alloc]init];
    _rightItems = [[NSMutableArray alloc]init];
    _centerItems = [[NSMutableArray alloc]init];
    
    _itemWidth = Item_Width;
}

- (void)setItemWidth:(CGFloat)itemWidth{
    
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
        [self reloadItems];
    }
}
- (void)setRightItem:(NSArray *)items{
    _type = CSNavBarTypeDefault;
    for (int i = 0; i<items.count; i++) {
        id item = [items objectAtIndex:i];
        if ([item isKindOfClass:[UIView class]]) {
            [_rightItems addObject:item];
        }
    }
}

- (void)setLetfItems:(NSArray *)items{
    _type = CSNavBarTypeDefault;
    for (int i = 0; i<items.count; i++) {
        id item = [items objectAtIndex:i];
        
        if ([item isKindOfClass:[UIView class]]) {
            [_leftItems addObject:item];
        }
    }
}
- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if (self.responseType == CSNavBarResponseSingle)
        [btn setTitleColor:ControllerDefalutColor forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];

//    [btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.rightItems addObject:btn];
}

- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:ControllerDefalutColor forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.leftItems addObject:btn];
}
- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action haslight:(BOOL)has{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if (has) {
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",title]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",title]] forState:UIControlStateSelected];
    }else{
        [btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    }

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.rightItems addObject:btn];
}
- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action haslight:(BOOL)has{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if (has) {
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",title]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",title]] forState:UIControlStateSelected];
    }else{
        [btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.leftItems addObject:btn];
}

- (void)setCenterItems:(NSArray *)items{
    _type = CSNavBarTypeCenter;
    for (int i = 0; i<items.count; i++) {
        id item = [items objectAtIndex:i];
        
        if ([item isKindOfClass:[UIView class]]) {
            [_centerItems addObject:item];
        }
    }
}

- (void)reloadItems{
    switch (_type) {
        case CSNavBarTypeDefault:
        {
            CGFloat leftX = 0;
            CGFloat rightX = 0;
 
            for (int i = 0; i<_leftItems.count; i++) {
                id item = [_leftItems objectAtIndex:i];
                
                UIButton *itemView = (UIButton *)item;
                itemView.frame = CGRectMake(leftX = _itemWidth*i, 0, _itemWidth, self.height);
                [self addSubview:item];
            }
            for (int i = 0; i<_rightItems.count; i++) {
                id item = [_rightItems objectAtIndex:i];
                
                UIButton *itemView = (UIButton *)item;
                rightX = rightX + _itemWidth;
                itemView.frame = CGRectMake(self.width - rightX, 0, _itemWidth, self.height);
                [item setImageEdgeInsets:UIEdgeInsetsMake(0.3*self.height, 0.3*_itemWidth, 0.3*self.height, 0.3*_itemWidth)];
                [self addSubview:item];
            }
            if(_leftItems.count == 1){
               id item = [_leftItems objectAtIndex:0];
               UIButton *itemView = (UIButton *)item;
               itemView.frame = CGRectMake(0, 0, _itemWidth*2, self.height);
               [self addSubview:item];
               return;
             }
             for (int i = 0; i<_leftItems.count; i++) {
                 id item = [_leftItems objectAtIndex:i];
                 UIButton *itemView = (UIButton *)item;
                 itemView.frame = CGRectMake(leftX = _itemWidth*2, 0, _itemWidth, self.height);
                 [self addSubview:item];
             }
        }
            break;
        case CSNavBarTypeCenter:
        {
            NSInteger centerCount = 0;
            CGFloat xLocation = 0;
            if (_itemWidth * _centerItems.count > self.width) {
                centerCount = self.width/_itemWidth;
            }else{
                centerCount = _centerItems.count;
            }
            xLocation = (self.width - _itemWidth * centerCount)/2;
            
            for (int i = 0; i<centerCount; i++) {
                 id item = [_centerItems objectAtIndex:i];
                 
                 UIView *itemView = (UIView *)item;
                 itemView.frame = CGRectMake(xLocation + _itemWidth*i, 0, _itemWidth, self.height);
                 [self addSubview:item];
             }
        }
            break;
        default:
            break;
    }
    
}

- (void)reloadItemWithVerticalOffset:(CGFloat)offY{
    CGFloat leftX = 0;
    CGFloat rightX = 0;
    for (int i = 0; i<_leftItems.count; i++) {
        id item = [_leftItems objectAtIndex:i];
        UIButton *itemView = (UIButton *)item;
        itemView.frame = CGRectMake(leftX = _itemWidth*i, 0, _itemWidth, self.height);
        
        if ([itemView isKindOfClass:[UIButton class]]) {
            CGFloat top = self.height*offY;
            CGFloat left = (_itemWidth - CSIconWidth)/2;
            CGFloat bottom = self.height - CSIconWidth - self.height*offY;
            [itemView setTitleEdgeInsets:UIEdgeInsetsMake(self.height, self.height, self.height, self.height)];
            [itemView setImageEdgeInsets:UIEdgeInsetsMake(top,left, bottom, left)];
//            CGFloat btHeight = self.height*(1 - offY - 0.06);
//            [itemView setTitleEdgeInsets:UIEdgeInsetsMake(self.height, self.height, self.height, self.height)];
//            [itemView setImageEdgeInsets:UIEdgeInsetsMake(offY*self.height,(Item_Width-btHeight)/2, 0.06*self.height, (Item_Width-btHeight)/2)];
        }
        [self addSubview:item];
    }
    
    for (int i = 0; i<_rightItems.count; i++) {
        id item = [_rightItems objectAtIndex:i];

        UIButton *itemView = (UIButton *)item;
        rightX = rightX + _itemWidth;
        //itemView.frame = CGRectMake(self.width - rightX, self.height/2, _itemWidth, self.height/2);
        
        itemView.frame = CGRectMake(self.width - rightX, 0, _itemWidth, self.height);

        if ([itemView isKindOfClass:[UIButton class]])
        {
            CGFloat top = self.height*offY;
            CGFloat left = (_itemWidth - CSIconWidth)/2;
            CGFloat bottom = self.height - CSIconWidth - self.height*offY;
            [itemView setTitleEdgeInsets:UIEdgeInsetsMake(self.height, self.height, self.height, self.height)];
            [itemView setImageEdgeInsets:UIEdgeInsetsMake(top,left, bottom, left)];

//            CGFloat btHeight = self.height*(1 - offY - 0.06);
//            [itemView setTitleEdgeInsets:UIEdgeInsetsMake(self.height, self.height, self.height, self.height)];
//            [itemView setImageEdgeInsets:UIEdgeInsetsMake(offY*self.height,(Item_Width-btHeight)/2, 0.06*self.height, (Item_Width-btHeight)/2)];
        }
        [self addSubview:item];
    }
}

- (void)cleanItems
{
    [self initValues];
    for (UIView *item in self.subviews)
    {
        [item removeFromSuperview];
    }
}
@end
