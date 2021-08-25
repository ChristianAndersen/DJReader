//
//  CSRadio.m
//  DJReader
//
//  Created by Andersen on 2020/9/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSRadio.h"
@interface CSRadio()
@end

@implementation CSRadio
{
    CGFloat _itemW;
}
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.width > self.height) {
        _itemW = self.height/2;
    }else{
        _itemW = self.width/2;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sendAction:self.action to:self.target forEvent:event];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.action = action;
    self.target = target;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.width > self.height){_itemW = self.height/2;}else{_itemW = self.width/2;}
    
    if (self.title) {
        switch (self.direction) {
            case 0:
                [self drawRightTitle];
                break;
            case 1:
                [self drawDownTitle];
                break;
            default:
                break;
        }
    }else{
        CGPoint center = CGPointMake(self.width/2, self.height/2);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor grayColor]set];
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, center.x, center.y, _itemW/2, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        if (self.selected) {
            CGRect frame = CGRectMake(center.x - _itemW/4, center.y - _itemW/4, _itemW/2, _itemW/2);
            [[UIColor whiteColor]set];
            CGContextFillRect(context, frame);
            CGContextAddEllipseInRect(context, frame);
            [[UIColor grayColor]set];
            CGContextFillPath(context);
        }
    }
}
- (void)drawRightTitle
{
    CGPoint center = CGPointMake(_itemW/2, self.height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor grayColor]set];
    CGContextSetLineWidth(context, 1);
    CGContextAddArc(context, center.x, center.y, _itemW/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (self.selected) {
        CGRect frame = CGRectMake(center.x - _itemW/4, center.y - _itemW/4, _itemW/2, _itemW/2);
        [[UIColor whiteColor]set];
        CGContextFillRect(context, frame);
        CGContextAddEllipseInRect(context, frame);
        [[UIColor grayColor]set];
        CGContextFillPath(context);
    }
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 1;
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary*attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor blackColor]};
    CGSize titleSize = [self.title sizeWithFont:[UIFont systemFontOfSize:15] inWidth:self.width - _itemW - 4 ];
    [self.title drawInRect:CGRectMake(_itemW+2, (self.height - titleSize.height)/2, titleSize.width + 2, self.height) withAttributes:attribute];
}
- (void)drawDownTitle
{
    CGPoint center = CGPointMake(self.width/2, _itemW/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor grayColor]set];
    CGContextSetLineWidth(context, 1);
    CGContextAddArc(context, center.x, center.y, _itemW/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (self.selected) {
        CGRect frame = CGRectMake(center.x - _itemW/4, center.y - _itemW/4, _itemW/2, _itemW/2);
        [[UIColor whiteColor]set];
        CGContextFillRect(context, frame);
        CGContextAddEllipseInRect(context, frame);
        [[UIColor grayColor]set];
        CGContextFillPath(context);
    }
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 1;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary*attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor blackColor]};
    CGSize titleSize = [self.title sizeWithFont:[UIFont systemFontOfSize:15] inWidth:self.width];
    [self.title drawInRect:CGRectMake(0, _itemW + (self.height/2 - titleSize.height)/2, self.width, _itemW) withAttributes:attribute];
}
@end
