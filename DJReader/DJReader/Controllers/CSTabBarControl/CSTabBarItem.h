//
//  CSTabBarItem.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/25.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CSTabBarItem : UIControl

@property CGFloat itemHeight;
@property (nonatomic, copy) NSString *title;//按钮标题
@property (nonatomic) UIOffset titlePositionAdjustment;

@property (copy) NSDictionary *unselectedTitleAttributes;
@property (copy) NSDictionary *selectedTitleAttributes;
@property (nonatomic) UIOffset imagePositionAdjustment;

- (UIImage *)finishedSelectedImage;
- (UIImage *)finishedUnselectedImage;

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

- (UIImage *)backgroundSelectedImage;
- (UIImage *)backgroundUnselectedImage;

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;


@property (nonatomic, copy) NSString *badgeValue;
@property (strong) UIImage *badgeBackgroundImage;
@property (strong) UIColor *badgeBackgroundColor;
@property (strong) UIColor *badgeTextColor;
@property (nonatomic) UIOffset badgePositionAdjustment;
@property (nonatomic) UIFont *badgeTextFont;

@end
NS_ASSUME_NONNULL_END
