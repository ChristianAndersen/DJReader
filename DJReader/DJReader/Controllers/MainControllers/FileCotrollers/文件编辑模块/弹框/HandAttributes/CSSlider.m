//
//  CSSlider.m
//  CSSliderView
//
//  Created by Andersen on 2020/3/19.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define LabWidth 60
#define Labheight 20
#define topBand 10

#import "CSSlider.h"
@interface CSSlider()
@property (nonatomic,assign) BOOL didSetLayer;
@property (nonatomic,assign)CGRect trackRect;
@property (nonatomic,strong)UILabel *valueLab;
@property (nonatomic,strong)UILabel *titleLab;
@end

@implementation CSSlider
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    self.minimumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:.4];
    self.maximumTrackTintColor = self.minimumTrackTintColor;
    [self setContinuous:YES];
    UIImage *image = [UIImage imageNamed:@"CSSlider"];
    image = [UIImage imageCompress:image targetWidth:24];
    [self setThumbImage:image forState:UIControlStateNormal];
    self.minimumTrackTintColor = [UIColor blackColor];
    self.maximumTrackTintColor = [UIColor colorWithWhite:0.6 alpha:0.8];
 
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = [UIFont systemFontOfSize:10];
    _titleLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    _valueLab = [[UILabel alloc]init];
    _valueLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    _valueLab.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _valueLab.textAlignment = NSTextAlignmentCenter;
    _valueLab.layer.masksToBounds = YES;
    _valueLab.font = [UIFont systemFontOfSize:12];
    _valueLab.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    _valueLab.layer.borderWidth = 1.0;
    _valueLab.layer.cornerRadius = 2.0;
    
    [self addSubview:_titleLab];
    [self addSubview:_valueLab];
}
- (void)setValueLabValue:(NSString*)value
{
    _valueLab.text = [NSString stringWithFormat:@"%@",value];
}
- (void)setTitleLabTitle:(NSString *)title
{
    _titleLab.text = title;
}
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
    CGFloat X = 0;
    CGFloat H = 21;
    CGFloat Y =( bounds.size.height - H ) *.5f;
    CGFloat W = H;
    return CGRectMake(X, Y, W, H);
}
/// 设置maximumValueImage的rect
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    CGFloat H = 21;
    CGFloat Y =( bounds.size.height - H ) *.5f;
    CGFloat W = H;
    CGFloat X = bounds.size.width - W;
    return CGRectMake(X, Y, W, H);
}

//滑块位置
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    _trackRect = rect;
    CGFloat WH =12;
    CGFloat margin = WH *.5f;
    /// 滑块的滑动区域宽度
    CGFloat maxWidth = CGRectGetWidth(rect) + 2 * margin;
    /// 每次偏移量
    CGFloat offset = (maxWidth - WH)/(self.maximumValue - self.minimumValue);
    
    CGFloat H = WH;
    CGFloat Y = bounds.size.height*0.7;//滑块Y方向位置
    CGFloat W = H;
    CGFloat X = CGRectGetMinX(rect) - margin + offset *(value-self.minimumValue);
    CGRect r =  CGRectMake(X, Y, W, H);
    return r;
}
//滑动条
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.7, bounds.size.width, 4);
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLab.frame = CGRectMake(_trackRect.origin.x, self.height * 0.2, LabWidth, Labheight);
    _valueLab.frame = CGRectMake(_trackRect.size.width - LabWidth,self.height * 0.2, LabWidth, Labheight);
    
    if (self.didSetLayer) {
        return;
    }
    BOOL didSetLayer = NO;
    for (UIView *v in self.subviews) {
        if ([v isMemberOfClass:[UIImageView class]]) {
            v.contentMode = UIViewContentModeScaleAspectFill;
        }
        NSLog(@"slider subview:%@",v);
    }
    self.didSetLayer = didSetLayer;
}
@end
