//
//  CSSignBarItem.m
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSSignBarItem.h"
@interface CSSignBarItem()

@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;

@end

@implementation CSSignBarItem
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
    [self setBackgroundColor:[UIColor clearColor]];
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    _unselectedTitleAttributes = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:10],
                                   NSForegroundColorAttributeName: [self colorWithHexString:@"0x808080"]
                                   };
    _selectedTitleAttributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:10],
                                 NSForegroundColorAttributeName: [self colorWithHexString:@"0x3BBD79"],
                                 };
}

- (void)drawRect:(CGRect)rect{
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
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
    imageSize = CGSizeMake(imageSize.width, imageSize.width);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect circleRect = CGRectZero;
    
    if (!_title.length) {//如果按钮没有标题
        circleRect = CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal,roundf(frameSize.height / 2 - imageSize.height / 2) + _imagePositionAdjustment.vertical,imageSize.width, imageSize.height);
        
//        if (_shouldRound) {
//            if ([self isSelected]) {
//                CGContextSetRGBFillColor(context, 42/255.0, 132/255.0, 255/255.0, 1);
//                CGContextSetRGBStrokeColor(context, 42/255.0, 132/255.0, 255/255.0, 1);//线圈的颜色
//            }else{
//                CGContextSetRGBFillColor(context, 1, 1, 1, 1);
//                CGContextSetRGBStrokeColor(context, 255/255.0, 255/255.0, 255/255.0, 1);//线圈的颜色
//            }
//            CGContextSetLineWidth(context, 1.0);//线宽
//            CGContextAddArc(context,
//                            circleRect.origin.x + circleRect.size.width/2, circleRect.origin.y + circleRect.size.height/2, circleRect.size.height*1.4, 0, M_PI * 2.0, 0);//添加圆
//            CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
//            CGContextRestoreGState(context);
//        }

        //按钮没有标题，图片居中绘制
        [image drawInRect:circleRect];
        

    }else {
        titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleAttributes[NSFontAttributeName]}
                                         context:nil].size;//计算标题长度
        imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);//计算居中
        
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal, imageStartingY + _imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
        
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        
        circleRect = CGRectUnion(CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal, imageStartingY + _imagePositionAdjustment.vertical,
                                            imageSize.width, imageSize.height), CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + _titlePositionAdjustment.vertical, titleSize.width, titleSize.height));

        [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + _titlePositionAdjustment.vertical, titleSize.width, titleSize.height) withAttributes:titleAttributes];
        
    }

    CGContextRestoreGState(context);
}

- (UIImage*)finishedSelectedImage
{
    return [self selectedImage];
}

- (UIImage*)finishedUnselectedImage
{
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

#pragma mark - Background configuration
- (UIImage*)backgroundSelectedImage
{
    return [self selectedBackgroundImage];
}
- (UIImage*)backgroundUnselectedImage
{
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
