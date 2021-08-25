//
//  ADSPen.h
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ADSPressedPenPoint : NSObject

@property (nonatomic) CGPoint point;
@property (nonatomic) UIColor* color;
@property (nonatomic) float width;

@end
@interface ADSPen : NSObject
//用来盛放每次写的点
@property (nonatomic) NSMutableArray* pointQueue;
@property (nonatomic) UIColor* color;
@property (nonatomic) float penHard;//硬度。10～100;
@property (nonatomic) float maxWidth;
@property (nonatomic) int smoothLevel;
@property (nonatomic) int num;

//三个点，利用贝赛尔曲线画圆滑的线条
@property (nonatomic,readonly) ADSPressedPenPoint* currentPressedPoint;
@property (nonatomic,readonly) ADSPressedPenPoint* previousPressedPoint;
@property (nonatomic,readonly) ADSPressedPenPoint* previous2PressedPoint;


- (void)beginPoint:(CGPoint)point;
- (void)movePoint:(CGPoint)point;
- (void)endPoint:(CGPoint)point;
@end
