//
//  CSSignBarItem.h
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSSignBarItem : UIControl
@property (nonatomic, assign)BOOL shouldRound;
@property (nonatomic, assign)CGFloat itemHeight;
@property (nonatomic, copy) NSString *title;//按钮标题

@property (nonatomic) UIOffset titlePositionAdjustment;
@property (nonatomic) UIOffset imagePositionAdjustment;

@property (copy) NSDictionary *unselectedTitleAttributes;
@property (copy) NSDictionary *selectedTitleAttributes;

- (UIImage *)finishedSelectedImage;
- (UIImage *)finishedUnselectedImage;

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

- (UIImage *)backgroundSelectedImage;
- (UIImage *)backgroundUnselectedImage;

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

@end

NS_ASSUME_NONNULL_END
