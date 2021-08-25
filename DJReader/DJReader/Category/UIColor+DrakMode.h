//
//  UIColor+DrakMode.h
//  DJReader
//
//  Created by Andersen on 2020/5/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DrakMode)
+ (UIColor*)drakColor:(UIColor*)drakColor lightColor:(UIColor*)lightColor;
+ (UIColor*)hexColor:(NSString*)colorHex;
@end

NS_ASSUME_NONNULL_END
