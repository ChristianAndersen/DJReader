//
//  ADSDrawView.m
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import "ADSDrawView.h"
@implementation ADSDrawPath

- (id)initWithPoints:(NSArray*)pointStrings width:(NSArray*)widthStrings penWidth:(int)penWidth color:(UIColor *)color smoothLevel:(int)smoothLevel
{
    self = [self init];
    if(self)
    {
        _pointStrings = [[NSMutableArray alloc] initWithArray:pointStrings];
        _widthStrings = [[NSMutableArray alloc] initWithArray:widthStrings];
        _penWidth = penWidth;
        _color = color;
        _smoothLevel = smoothLevel;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _pointStrings = [[NSMutableArray alloc] init];
        _widthStrings = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end

@interface ADSDrawView()

@property (nonatomic)UIImageView *imageView;
@property (nonatomic) CGPoint beganLoction;
@property (nonatomic) CGRect currentDrawRect;


@end

@implementation ADSDrawView
@synthesize paths = _paths;
@synthesize currentPath = _currentPath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor lightTextColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        [self setup];
    }
    return self;
}
- (void)setup{
    _paths = [[NSMutableArray alloc] init];
    self.pen =[[ADSPen alloc] init];
    
    self.touchBegan = NO;
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.userInteractionEnabled = YES;
}

- (CGPoint)fixLocationToValid:(CGPoint)location
{
    location.x = MIN(location.x, self.bounds.size.width);
    location.x = MAX(location.x, 0);
    location.y = MIN(location.y, self.bounds.size.height);
    location.y = MAX(location.y, 0);
    
    return location;
}
#pragma mark Private Helper function

CGPoint getMidPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}
- (int)penWidth
{
    if (_penWidth == 0) {
        _penWidth = 3;
    }
    return _penWidth;
}
- (UIColor*)color
{
    if (!_color) {
        _color = [UIColor blackColor];
    }
    return _color;
}

- (int)penHard
{
    if (_penHard == 0) {
        _penHard = 50;
    }
    return _penHard;
}

- (void)initPen:(ADSPen*)pen
{
    pen.maxWidth = self.penWidth * 3;
    pen.color = self.color;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
//如果触碰点在屏外则结束此次触碰事件
    if (!CGRectContainsPoint(self.bounds, location)) {
        return;
    }
    location = [self fixLocationToValid:location];
    
    self.beganLoction = location;
    
    self.touchBegan = YES;
    [self pen:_pen began:location];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.touchBegan)
        return;
    
    UITouch *touch  = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    location = [self fixLocationToValid:location];
    [self pen:_pen moved:location];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(!self.touchBegan)
        return;
    
    UITouch *touch  = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    location = [self fixLocationToValid:location];
    [self pen:_pen ended:location];
    [self clearCurrentPath];
            
     self.touchBegan = NO;
}

- (void)pen:(ADSPen*)pen began:(CGPoint)location{
    [self initPen:pen];
    [self clearCurrentPath];
    [pen beginPoint:location];
    if (pen.smoothLevel == 0) {
        [self drawSteps:1];
    }
}
- (void)pen:(ADSPen*)pen moved:(CGPoint)location
{
    [pen movePoint:location];
    [self drawSteps:2];
    
    if(pen.smoothLevel == 0)
    {
        ;
    }
    else if([_pen.pointQueue count] >= _pen.smoothLevel)
    {
        [self drawSteps:1];
    }
}
- (void)pen:(ADSPen*)pen ended:(CGPoint)location
{
    [_pen endPoint:location];
    _currentPath.endPoint = pen.num;
    
    if(_currentPath)
        [_paths addObject:_currentPath];
    _touchBegan = NO;
    
    if(pen.smoothLevel == 0)
    {
        [self drawSteps:1];
    }
}

- (CGRect)drawSteps:(int)NumOfSteps{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.currentImage drawAtPoint:CGPointMake(0, 0)];
    
    CGRect drawRect;
    CGRect totalRect = CGRectZero;
    for (int i = 0; i<NumOfSteps; i++) {
        drawRect = [ADSDrawView drawPen:self.pen context:context toPath:self.currentPath];
        if(CGRectEqualToRect(drawRect, CGRectZero))
            break;
        
        if(CGRectEqualToRect(totalRect, CGRectZero))
            totalRect = drawRect;
        else
            totalRect = CGRectUnion(drawRect, totalRect);
    }
    self.currentImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:totalRect];
    
    return totalRect;
}

CGPoint lerpPoints(CGPoint a, CGPoint b, const float t)
{
    CGPoint dest;
    dest.x = a.x + (b.x-a.x)*t;
    dest.y = a.y + (b.y-a.y)*t;
    return dest;
}

CGPoint bezierPoints(CGPoint a, CGPoint b, CGPoint c, const float t)
{
    CGPoint ab,bc,abbc;
    ab = lerpPoints(a,b,t);           // point between a and b (green)
    bc = lerpPoints(b,c,t);           // point between c and d (green)
    abbc = lerpPoints(ab,bc,t);       // point between ab and bc (blue)
    
    return abbc;
}

+ (CGRect)drawPen:(ADSPen*)pen context:(CGContextRef)context toPath:(ADSDrawPath*)currentPath{
    ADSPressedPenPoint* currentPenPoint = pen.currentPressedPoint;
    
    if(!currentPenPoint)
    {
        return CGRectZero;
    }
    
    CGPoint previousPoint2  = pen.previous2PressedPoint.point;
    CGPoint previousPoint1  = pen.previousPressedPoint.point;
    CGPoint currentPoint    =  currentPenPoint.point;
    float penWidth =  currentPenPoint.width;
    float previousPenWidth = pen.previousPressedPoint.width;
    UIColor* color = currentPenPoint.color;
    
    // calculate mid point
    CGPoint mid2    = getMidPoint(previousPoint1, previousPoint2);
    CGPoint mid1    = getMidPoint(currentPoint, previousPoint1);
    CGRect drawBox = CGRectZero;
    
    //get rect
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid2.x, mid2.y+0.5);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid1.x, mid1.y+0.5);
    
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox2 = bounds;

    drawBox2.origin.x        -= penWidth * 2;
    drawBox2.origin.y        -= penWidth * 2;
    drawBox2.size.width      += penWidth * 4;
    drawBox2.size.height     += penWidth * 4;
    
    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineJoin(context, kCGLineJoinMiter);
//    CGContextSetMiterLimit(context, 0.8);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGPoint previousBezierPoint = mid2;
    CGPoint currentBezierPoint = mid2;
    CGFloat currentPenWidth = penWidth;
    
    drawBox = (CGRect){mid2.x - penWidth ,mid2.y - penWidth,mid2.x + penWidth,mid2.y + penWidth};
    CGFloat rangX = pow((currentPenPoint.point.x - pen.previousPressedPoint.point.x),2);
    CGFloat rangY = pow((currentPenPoint.point.y - pen.previousPressedPoint.point.y),2);
    
    CGFloat rangLength = sqrt(rangX + rangY);
    
    int rangPointNum = rangLength;
    
    int widthPointNum = fabs(penWidth - previousPenWidth)/0.5;
    
    int pointNum = MAX(rangPointNum, widthPointNum);
    
    pointNum = MAX(pointNum, 4);

    
    for(int i = 0; i <= pointNum;i++)
    {
        CGFloat t = i/(float)pointNum;
        previousBezierPoint = currentBezierPoint;
        currentBezierPoint = bezierPoints(mid2,previousPoint1,mid1,t);
        currentPenWidth = previousPenWidth + (penWidth - previousPenWidth)*t;
        
        {
            drawBox.origin.x = MIN(currentBezierPoint.x - currentPenWidth, drawBox.origin.x);
            drawBox.origin.y = MIN(currentBezierPoint.y - currentPenWidth, drawBox.origin.y);
            
            drawBox.size.width = MAX(currentBezierPoint.x + currentPenWidth, drawBox.size.width);
            drawBox.size.height = MAX(currentBezierPoint.y + currentPenWidth, drawBox.size.height);
        }
        
        if(currentPath)
        {
            [currentPath.pointStrings addObject:NSStringFromCGPoint(currentBezierPoint)];
            [currentPath.widthStrings addObject:[NSString stringWithFormat:@"%f",(currentPenWidth)]];
        }
        
        CGContextSetLineWidth(context, currentPenWidth);
        
        [ADSDrawView drawLine:context fromPoint:previousBezierPoint toPoint:currentBezierPoint];
        
        previousBezierPoint = currentBezierPoint;
    }
    
    drawBox.size.width -= drawBox.origin.x;
    drawBox.size.height -= drawBox.origin.y;
    
    CGContextStrokePath(context);
    return drawBox;
}
+ (void)drawLine:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGContextMoveToPoint(context, fromPoint.x+0.5, fromPoint.y+0.5);
    CGContextAddLineToPoint(context, toPoint.x+0.5, toPoint.y+0.5);
    CGContextStrokePath(context);
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // 画圆
//    CGContextAddArc(ctx, 100, 100, 50, 0, 2 * M_PI_2, 0);
    
    if(self.currentImage)
        [self.currentImage drawAtPoint:CGPointMake(0, 0)];
    // 3.渲染 (注意, 画线只能通过空心来画)
    // CGContextFillPath(ctx);
//    CGContextStrokePath(ctx);
}
- (void)clearAllPath{
    self.paths = [[NSMutableArray alloc] init];
    self.currentImage = [ADSDrawView imageFromPaths:_paths size:self.bounds.size];
    [self setNeedsDisplay];
}

- (void)clearCurrentPath
{
    _currentPath = [[ADSDrawPath alloc] init];
    _currentPath.color = _pen.color;
    _currentPath.penWidth = _pen.maxWidth;
    _currentPath.smoothLevel = _pen.smoothLevel;
}
- (UIImage*)saveToGetSignatrueImage
{
    UIImage *image = [ADSDrawView imageFromPaths:_paths size:self.bounds.size];
    return image;
}
//根据当前笔迹数组显示图片，并且返回图片
+ (UIImage*)imageFromPaths:(NSArray*)paths size:(CGSize)size
{
    
    UIImage* image;
    
    
    if([paths count] == 0)
    {
        return [[UIImage alloc] init];
    }
    else if(size.height == 0 || size.width == 0)
    {
        return [[UIImage alloc] init];
    }
    else
    {
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for(ADSDrawPath* path in paths)
        {
            if(path.pointStrings.count == 0)
                continue;
            
            UIColor* color = path.color;
            
            CGFloat penWidth = path.penWidth;
            
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
             
            CGPoint previousPoint;
            CGPoint currentPoint;
            
            int i = 0;
            for(NSString* pointString in path.pointStrings)
            {
                if(i == 0)
                    currentPoint = CGPointFromString(pointString);
                
                previousPoint = currentPoint;
                currentPoint = CGPointFromString(pointString);
                

                penWidth = [(NSString*)path.widthStrings[i] floatValue];

                CGContextSetLineWidth(context, penWidth);
                [ADSDrawView drawLine:context fromPoint:previousPoint toPoint:currentPoint];
                
                i++;
            }
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
    [super setNeedsDisplayInRect:rect];
}
- (void)dealloc{
}

@end
