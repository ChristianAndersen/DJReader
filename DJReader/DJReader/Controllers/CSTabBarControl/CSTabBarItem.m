//
//  CSTabBarItem.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/25.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTabBarItem.h"
#define  kBadgeTipStr @"badgeTip"

@interface CSTabBarItem()
@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;
@end

@implementation CSTabBarItem
- (id)initWithFrame:(CGRect)frame {
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
- (void)commonInitialization {
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
//    _unselectedTitleAttributes = @{
//                                   NSFontAttributeName: [UIFont systemFontOfSize:12],
//                                   NSForegroundColorAttributeName: [self colorWithHexString:@"0x808080"]
//                                   };
    _unselectedTitleAttributes = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:12],
                                   NSForegroundColorAttributeName: [UIColor colorWithRed:55/255.0 green:70/255.0 blue:88/255.0 alpha:1.0]
                                   };
    
    _selectedTitleAttributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:78/255.0 green:118/255.0 blue:221/255.0 alpha:1.0],
                                 };
    if (@available(iOS 13.0, *)) {
       [self setBackgroundColor:[UIColor systemBackgroundColor]];
       _badgeTextColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
           if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
               return [UIColor lightTextColor];
           }else{
               return [UIColor darkTextColor];
           }
       }];
    
    } else {
        _badgeTextColor = [UIColor whiteColor];
        [self setBackgroundColor:[self colorWithHexString:@"0xf75388"]];
    }
    _badgeTextFont = [UIFont systemFontOfSize:11];
    _badgePositionAdjustment = UIOffsetMake(-4, 2);
    self.backgroundColor = [UIColor whiteColor];
}
- (void)drawRect:(CGRect)rect{
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    CGFloat scale = 2.9;
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    }else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    imageSize = CGSizeMake(imageSize.width/scale, imageSize.height/scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (!_title.length) {//如果按钮没有标题
        //按钮没有标题，图片居中绘制
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal,roundf(frameSize.height/2 - imageSize.height/2) + _imagePositionAdjustment.vertical,imageSize.width, imageSize.height)];
    }else {
        titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 12)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleAttributes[NSFontAttributeName]}
                                         context:nil].size;//计算标题长度
        imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height)/3);//计算居中
        //imageStartingY = 2;//计算居中
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal, imageStartingY + _imagePositionAdjustment.vertical,imageSize.width, imageSize.height)];
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + _titlePositionAdjustment.vertical, titleSize.width, titleSize.height) withAttributes:titleAttributes];
    }
    
    if ([[self badgeValue]length]) {
        CGSize badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self badgeTextFont]} context:nil].size;
        CGFloat textOffset = 2.0f;
        if (badgeSize.width<badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        if ([_badgeValue isEqualToString:kBadgeTipStr]) {
            badgeSize = CGSizeMake(4, 4);
        }
        CGRect badgeBackgroundFrame = CGRectMake(round(frameSize.width / 2 + (image.size.width / 2) * 0.9) +
                                                 [self badgePositionAdjustment].horizontal, textOffset + [self badgePositionAdjustment].vertical, badgeSize.width + 2* textOffset, badgeSize.height+2*textOffset);
        CGFloat padding = 2.0;
        CGRect badgeBackgroundPaddingFrame = CGRectMake(badgeBackgroundFrame.origin.x-padding, badgeBackgroundFrame.origin.y-padding, badgeBackgroundFrame.size.width+2*padding, badgeBackgroundFrame.size.height + 2*padding);
        
//        if ([self badgeBackgroundColor]) {
//            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//            if (badgeSize.width>badgeSize.height) {//外白色描边
//                CGFloat circleWith = badgeBackgroundPaddingFrame.size.height;
//                CGFloat totalWidth =badgeBackgroundPaddingFrame.size.width;
//                CGFloat diffWidth = totalWidth - circleWith;
//                CGPoint originPoint = badgeBackgroundPaddingFrame.origin;
//
//                CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
//                CGRect centerFrame = CGRectMake(originPoint.x + circleWith/2, originPoint.y, diffWidth, circleWith);
//                CGRect rightCicleFrame = CGRectMake(originPoint.x + (totalWidth-circleWith), originPoint.y, circleWith, circleWith);
//                CGContextFillEllipseInRect(context, leftCicleFrame);//矩型中填充一个椭圆
//                CGContextFillRect(context, centerFrame);
//                CGContextFillEllipseInRect(context, rightCicleFrame);
//            }else{
//                CGContextFillEllipseInRect(context, badgeBackgroundPaddingFrame);
//            }
//            //badge背景色
//            CGContextSetFillColorWithColor(context, [self badgeBackgroundColor].CGColor);
//            if (badgeSize.width>badgeSize.height) {
//                CGFloat circleWidth = badgeBackgroundFrame.size.height;
//                CGFloat totalWidth = badgeBackgroundFrame.size.width;
//                CGFloat diffWidth = totalWidth - circleWidth;
//                CGPoint originPoint = badgeBackgroundFrame.origin;
//
//                CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWidth, circleWidth);
//                CGRect centerFrame = CGRectMake(originPoint.x+circleWidth/2, originPoint.y, diffWidth, circleWidth);
//                CGRect rightCicleFrame = CGRectMake(originPoint.x + (totalWidth - circleWidth), originPoint.y, circleWidth, circleWidth);
//                CGContextFillEllipseInRect(context, leftCicleFrame);
//                CGContextFillRect(context, centerFrame);
//                CGContextFillEllipseInRect(context, rightCicleFrame);
//            }else{
//                CGContextFillEllipseInRect(context, badgeBackgroundFrame);
//            }
//        }else if ([self badgeBackgroundColor]){
//            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
//        }
        //badgeValue
        if (![self.badgeValue isEqualToString:kBadgeTipStr]) {
            CGContextSetFillColorWithColor(context, [[self badgeTextColor]CGColor]);
            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByCharWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
            
            NSDictionary *badgeTextAttributes = @{NSFontAttributeName:[self badgeTextFont],NSForegroundColorAttributeName:[self badgeTextColor],NSParagraphStyleAttributeName:badgeTextStyle};
            [self.badgeValue drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame)+textOffset,CGRectGetMinY(badgeBackgroundFrame)+textOffset,badgeSize.width,badgeSize.height) withAttributes:badgeTextAttributes];
        }
    }
    CGContextRestoreGState(context);
}

- (UIImage*)finishedSelectedImage{
    return [self selectedImage];
}
- (UIImage*)finishedUnselectedImage{
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage{
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    if (unselectedImage &&(unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}

#pragma mark - Background configuration
- (UIImage*)backgroundSelectedImage{
    return [self selectedBackgroundImage];
}
- (UIImage*)backgroundUnselectedImage{
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage{
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
