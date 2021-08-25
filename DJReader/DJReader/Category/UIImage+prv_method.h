//
//  UIImage+prv_method.h
//  DJReader
//
//  Created by Andersen on 2020/3/26.
//  Copyright © 2020 Andersen. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (prv_method)
//缩放图片
+ (UIImage*)imageCompress:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
+ (UIImage*)imageChangeBackground:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
