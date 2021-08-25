//
//  UIColor+DrakMode.m
//  DJReader
//
//  Created by Andersen on 2020/5/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UIColor+DrakMode.h"

@implementation UIColor (DrakMode)
+ (UIColor*)drakColor:(UIColor*)drakColor lightColor:(UIColor*)lightColor
{
    if (@available(iOS 13.0, *)) {
        UIColor * color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) { //浅色模式
                return lightColor;
            } else { //深色模式
                return drakColor;
            }
        }];
        return color;
    }else{
        return lightColor;
    }
}
+ (UIColor*)hexColor:(NSString*)colorHex
{
    NSScanner *scanner = [NSScanner scannerWithString:colorHex];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
@end
