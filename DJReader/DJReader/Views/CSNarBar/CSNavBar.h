//
//  CSNavBar.h
//  DJReader
//
//  Created by Andersen on 2020/3/6.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol CSNavBarDelegate <NSObject>
@optional
- (void)clickedIndex:(int)index itemTitle:(NSString*)title location:(CGPoint)location;
@end

@interface CSNavBar : UIView
@property (nonatomic ,assign)CGFloat itemWidth;
@property (nonatomic,assign)CSNavBarResponseType responseType;

- (void)setLetfItems:(NSArray*)items;
- (void)setRightItem:(NSArray*)items;
- (void)setCenterItems:(NSArray*)items;

- (void)reloadItems;
- (void)cleanItems;
- (void)reloadItemWithVerticalOffset:(CGFloat)offY;

- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action;
- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action;

- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action haslight:(BOOL)has;
- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action haslight:(BOOL)has;
@end

NS_ASSUME_NONNULL_END
