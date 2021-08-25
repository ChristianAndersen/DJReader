//
//  ADSDrawView.h
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSPen.h"
@interface ADSDrawPath : NSObject

@property (nonatomic) NSMutableArray* pointStrings;
@property (nonatomic) NSMutableArray* widthStrings;
@property (nonatomic) float penWidth;
@property (nonatomic) UIColor* color;
@property (nonatomic) int smoothLevel;
@property (nonatomic) int endPoint;




-(id)initWithPoints:(NSArray*)pointStrings width:(NSArray*)widthStrings penWidth:(int)penWidth color:(UIColor *)color smoothLevel:(int)smoothLevel;
-(id)init;

@end

@interface ADSDrawView : UIView<UIGestureRecognizerDelegate>
{
@private
    CGPoint _currentPoint;
    CGPoint _previousPoint1;
    CGPoint _previousPoint2;
    long _startTime;
}

@property (nonatomic)NSMutableArray *paths;
@property (nonatomic)ADSDrawPath *currentPath;

@property (nonatomic) UIImage* currentImage;
@property (nonatomic)BOOL touchBegan;
@property (nonatomic)ADSPen *pen;
@property (nonatomic)UIColor *color;
@property (nonatomic)int penWidth;
@property (nonatomic)int penHard;

@property (nonatomic) CGPoint touchPoint;

- (void)clearAllPath;
- (UIImage*)saveToGetSignatrueImage;
@end
