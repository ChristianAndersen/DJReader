//
//  ADSPen.m
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import "ADSPen.h"

@implementation ADSPressedPenPoint

@end

@interface ADSPen()

@property (nonatomic) BOOL onDraw;
@property (nonatomic) float currentWidth;
@property (nonatomic) float widthAddValue;

@end

@implementation ADSPen

@synthesize currentPressedPoint = _currentPressedPoint;
@synthesize previousPressedPoint = _previousPressedPoint;
@synthesize previous2PressedPoint = _previous2PressedPoint;

- (id)init{
    self = [super init];
    if(self)
    {
        self.currentWidth = 0;
        self.onDraw = NO;
        self.num = 0;
        
        self.pointQueue = [[NSMutableArray alloc] init];
        _previousPressedPoint = nil;
        _previous2PressedPoint = nil;
        _currentPressedPoint = nil;
    }
    return self;
}

- (void)beginPoint:(CGPoint)point{
    [self clear];
    self.onDraw = YES;
    [_pointQueue addObject:NSStringFromCGPoint(point)];
}

- (void)movePoint:(CGPoint)point{
    if (self.onDraw) {
        [_pointQueue addObject:NSStringFromCGPoint(point)];
    }
}

- (void)endPoint:(CGPoint)point{
    if (self.onDraw) {
        [_pointQueue addObject:NSStringFromCGPoint(point)];
        self.onDraw = NO;
    }
}

//清楚之前的笔记点
- (void)clear{
    [_pointQueue removeAllObjects];
    _previousPressedPoint = nil;
    _previous2PressedPoint = nil;
    _currentPressedPoint = nil;
    
    self.currentWidth = 0;
    self.onDraw = NO;
    self.num = 0;
}
//当前笔记点
- (ADSPressedPenPoint*)currentPressedPoint{
    if ([_pointQueue count] == 0) {
        return nil;
    }
    ADSPressedPenPoint *penPoint = [[ADSPressedPenPoint alloc]init];
    CGPoint point = CGPointFromString([_pointQueue firstObject]);
    [_pointQueue removeObjectAtIndex:0];
    self.num ++;
    
    [self calWidth];
    if (self.currentWidth == 0) {
        return nil;
    }
    penPoint.color = self.color;
    penPoint.width = self.currentWidth;
    penPoint.point = point;
    
    _previous2PressedPoint = _previousPressedPoint;
    _previousPressedPoint = _currentPressedPoint;
    _currentPressedPoint = penPoint;
    
    if(!_previousPressedPoint)
        _previousPressedPoint = _currentPressedPoint;
    if(!_previous2PressedPoint)
        _previous2PressedPoint = _currentPressedPoint;
    
    return penPoint;
}
- (float)penHard{
    if (_penHard == 0) {
        _penHard = 50;
    }
    return _penHard;
}

//设置笔宽
- (void)calWidth{
    float offValue = 0.0f;
    
    if(!self.onDraw)
        offValue -= _currentWidth/[_pointQueue count];
    
    float offY = fabs(_previousPressedPoint.point.y - _currentPressedPoint.point.y);
    float offX = fabs(_previousPressedPoint.point.x - _currentPressedPoint.point.x);
    
    double maxOffValue = 6.0;
    double speedPressed = 40 -  (offX + offY);
    double off = 3;
    CGFloat flag = 30;
    CGFloat hard = self.penHard * 0.8;
    CGFloat bottom = flag *(1 - hard/100.0)/2;
    CGFloat top = flag - bottom;

    if (speedPressed > 0 && self.currentWidth >3) {
        if (speedPressed <= bottom && speedPressed > 2) {
            off = off * 4;
        }
        if (speedPressed>bottom && speedPressed<top) {
            off = off ;
        }
        if (speedPressed>=top && speedPressed <= 50) {
            off = off * 4;
        }
    }else if(speedPressed > 0 && self.currentWidth < 3){
        off = off * 8;
    }else{
        if (speedPressed > -bottom && speedPressed <= 0) {
            off = off * 4;
        }
        if (speedPressed <= -bottom && speedPressed > -top) {
            off = off ;
        }
        if (speedPressed <= -top) {
            off = off * 4;
        }
    }
    
    if (offValue < maxOffValue && offValue > - maxOffValue)
    {
        offValue += (off * (self.currentWidth /10) * speedPressed/30);
    }
     
    if(offValue > maxOffValue)
        offValue = maxOffValue;
    if(offValue < (-maxOffValue))
        offValue = -maxOffValue;
    
    self.currentWidth += offValue;
}

- (BOOL)next
{
    if(_pointQueue.count < 2)
        return NO;
    else{
        [_pointQueue removeObjectAtIndex:0];
        return YES;
    }
}
- (ADSPressedPenPoint *)previousPressedPoint{
    return _previousPressedPoint ? _previousPressedPoint : _currentPressedPoint;
}
- (ADSPressedPenPoint *)previous2PressedPoint
{
    return _previous2PressedPoint ? _previous2PressedPoint : _currentPressedPoint;
}
- (void)setMaxWidth:(float)maxWidth{
    _maxWidth = maxWidth;
    self.widthAddValue = _maxWidth/_smoothLevel;
}
- (void)setSmoothLevel:(int)smoothLevel{
    _smoothLevel = smoothLevel;
    self.widthAddValue = _maxWidth/_smoothLevel;
}
- (void)setWidthAddValue:(float)widthAddValue
{
    _widthAddValue = widthAddValue;
    if(_widthAddValue > 0.5)
        _widthAddValue = 0.5;
}
- (void)setCurrentWidth:(float)currentWidth
{
    if(currentWidth > self.maxWidth)
        currentWidth = self.maxWidth;
    else if(currentWidth < 0.5)
        currentWidth = 0.5;
    
    _currentWidth = currentWidth;
}

@end
