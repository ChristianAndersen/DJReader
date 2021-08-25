//
//  CSSheetView.m
//  ZmjPickView
//
//  Created by Andersen on 2020/9/22.
//  Copyright © 2020 郑敏捷. All rights reserved.
//
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CSSheetView.h"
@interface CSSheetView()
@property (strong, nonatomic) UIView *darkView;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat boardRadio;
@property (assign, nonatomic) CGFloat contentInterval;
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGFloat parentH,parentW;

@property (assign, nonatomic) BOOL show;
@end

@implementation CSSheetView
- (instancetype)init {
    self = [super init];
    if (self) {
        _boardRadio = 20.0;
        _contentInterval = 10.0;
        _contentHeight = 400.0;
    }
    return self;
}
- (void)showView:(UIView*)view inParent:(UIView*)parent
{
    _contentView = nil;
    _backView = nil;
    _darkView = nil;
    _contentView = view;
    _contentHeight = view.frame.size.height;
    _parentH = parent.frame.size.height;
    _parentW = parent.frame.size.width;
    
    _contentFrame = CGRectMake(_contentInterval, _parentH, _parentW - _contentInterval*2, _contentHeight);
    _contentView.frame = CGRectMake(0, 0, _parentW - _contentInterval*2, _contentHeight);
    self.frame = parent.frame;
    [self initView];
    [self initGesture];
}
- (void)reloadContentHeight:(CGFloat)height
{
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentHeight = height;
        self.contentFrame = CGRectMake(self.contentInterval, self.parentH - self.contentHeight, self.parentW - self.contentInterval*2, self.contentHeight);
        self.contentView.frame = CGRectMake(0, 0, self.contentView.width, self.contentHeight);
        self.backView.frame = self.contentFrame;
        self.darkView.frame = CGRectMake(0, 0,self.parentW, self.parentH);
        self.frame = CGRectMake(0, 0, self.parentW, self.parentH);
    }];
}
- (void)setContentView:(UIView *)contentView
{
    [self contentSize:contentView.frame.size.height];
    [self.backView addSubview:contentView];
}

- (void)initView{
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.contentView];

    [self bezierPath];
    [self shapeLayer];
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView                 = [[UIView alloc]init];
        _darkView.frame           = CGRectMake(0, 0,_parentW, _parentH + _contentHeight);;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha           = 0.3;
    }
    return _darkView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.frame = _contentFrame;
        _backView.backgroundColor = [UIColor systemBlueColor];
    }
    return _backView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(_contentInterval, _contentInterval)];
    }
    return _bezierPath;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = _backView.bounds;
        _shapeLayer.path = _bezierPath.CGPath;
        _backView.layer.mask = _shapeLayer;
    }
    return _shapeLayer;
}

- (void)contentSize:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
}

- (void)initGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.darkView addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view {
    _show = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = CGPointMake(self.center.x, (self.parentH - self.contentHeight)/2);
        self.center   = point;
    } completion:^(BOOL finished) {
    }];
    [view addSubview:self];
}
- (void)dismiss {
    _show = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = CGPointMake(self.center.x,self.parentH/2);
        self.center   = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSheetView:)]) {
            [self.delegate dismissSheetView:self];
        }
    }];
}
@end
