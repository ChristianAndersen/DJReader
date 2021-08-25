//
//  CSBottomAlert.m
//  CSBottomAlertView
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define defalutPopHeight 250

#import "CSBottomAlert.h"

@interface CSBottomAlert()
@property (strong, nonatomic) UIBezierPath   *bezierPath;
@property (strong, nonatomic) CAShapeLayer   *shapeLayer;
@property (weak, nonatomic) UIView *fromView;

@property (strong, nonatomic) UIButton       *cancelBtn;
@property (strong, nonatomic) UIButton       *DetermineBtn;
@end

@implementation CSBottomAlert

- (instancetype)init
{
    CGRect frame = CGRectMake(0, kScreen_Height, kScreen_Width, defalutPopHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    
    return self;
}

- (void)initGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)show
{
    [self initView];
}

- (void)initView {
    
    [self showInView:[UIApplication sharedApplication].delegate.window];
    if (_showBtn) {
        [self cancelBtn];
        [self DetermineBtn];
    }

    [self bezierPath];
    [self shapeLayer];
}

- (void)showInView:(UIView *)view {
    if (_isShow == YES)
        return;
    
    
    _isShow = YES;
    
    CGFloat popHeight = defalutPopHeight;
    if (_contenSize.height > 0)
        popHeight = _contenSize.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y      -= popHeight;
        self.center   = point;
    } completion:^(BOOL finished) {
    
    }];
    
    [view addSubview:self];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.5;
}

- (void)dismiss
{
    if (_isShow == NO) return;
    _isShow = NO;
    CGFloat popHeight = 250;
    if (_contenSize.height > 0 ||_contenSize.height<kScreen_Height)
        popHeight = _contenSize.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y      += popHeight;
        self.center   = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.path = _bezierPath.CGPath;
        self.layer.mask = _shapeLayer;
    }
    return _shapeLayer;
}


- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    }
    return _bezierPath;
}

- (void)reloadSubviews
{
    _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.path = _bezierPath.CGPath;
    self.layer.mask = _shapeLayer;
           
    CGPoint center = CGPointMake(self.center.x, kScreen_Height - _contenSize.height/2);
    self.center = center;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, 0, 50, 50);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
            make.top.equalTo(self);
        }];
    }
    return _cancelBtn;
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(kScreen_Width - 50, 0, 50, 50);
        [_DetermineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_DetermineBtn];
        
        [_DetermineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
            make.top.equalTo(self);
        }];
    }
    return _DetermineBtn;
}
- (void)determineBtnAction:(UIButton *)button {
    if (self.determineBtnBlock) {
        self.determineBtnBlock();
    }
    [self dismiss];
}

- (void)setContenSize:(CGSize)contenSize shouldReload:(BOOL)shouldReload
{
    _contenSize = contenSize;
    self.frame = CGRectMake(self.frame.origin.x + (kScreen_Width - self.contenSize.width)/2, kScreen_Height, kScreen_Width - (kScreen_Width - self.contenSize.width) , _contenSize.height);
    
    if (shouldReload) {
        [UIView animateWithDuration:0.3 animations:^{
            [self reloadSubviews];
        } completion:^(BOOL finished) {
            
        }];
    }
    _contenSize = contenSize;

}
- (void)setContenSize:(CGSize)contenSize
{
    _contenSize = contenSize;
    self.frame = CGRectMake((kScreen_Width - _contenSize.width)/2, kScreen_Height, _contenSize.width, _contenSize.height);
}

@end
