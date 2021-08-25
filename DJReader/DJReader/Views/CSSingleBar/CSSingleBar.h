//
//  CSSingleBar.h
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSignBarItem.h"
NS_ASSUME_NONNULL_BEGIN
@class CSSingleBar;

@protocol CSSingBarDelegate <NSObject>
- (BOOL)singleBar:(CSSingleBar*)tabBar shouldSelectItemAtIndex:(NSInteger)index selected:(BOOL)selected;
- (void)singleBar:(CSSingleBar*)tabBar didSelectItemAtIndex:(NSInteger)index selected:(BOOL)selected;
@end

@interface CSSingleBar : UIView
@property (nonatomic,weak)id <CSSingBarDelegate>delegate;
@property (nonatomic,copy) NSArray *items;
@property (nonatomic, weak)CSSignBarItem *selectedItem;
@property (nonatomic, readonly)UIView *backgroundView;
@property (nonatomic, assign)UIEdgeInsets contentEdgeInsets;

//设置是否半透明
@property (nonatomic, getter=isTransulcent) BOOL translucent;
- (void)setHeight:(CGFloat)height;
- (CGFloat)minimumContentHeight;
@end

NS_ASSUME_NONNULL_END
