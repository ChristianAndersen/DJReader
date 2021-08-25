//
//  HandAttributeView.m
//  DJReader
//
//  Created by Andersen on 2020/3/17.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define leftBand 20

#import "HandAttributeView.h"
#import "CSSlider.h"
#import "CSColorSeletor.h"

@interface HandAttributeView()<ColorSeletorDelegate>
@property (nonatomic,strong)CSSlider *penSlider,*alphaSlider;
@property (nonatomic,strong)CSColorSeletor *colorSelector;
@property (nonatomic,strong)UIView *line;
@end

@implementation HandAttributeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self loadSubViews];
}

- (CGFloat)penWidth
{
    if (_penWidth < 1) {
        _penWidth = 3.0;
    }
    return _penWidth;
}

- (CGFloat)penAlpha
{
    if (_penAlpha <= 0) {
        _penAlpha = 1;
    }
    return _penAlpha;
}
- (ColorUnit*)unit
{
    if (_unit == nil) {
        _unit = [[ColorUnit alloc]init];
        _unit.r = 0;
        _unit.g = 0;
        _unit.b = 0;
    }
    return _unit;
}
- (void)loadSubViews
{
    [self penSlider];
    //[self alphaSlider];
    [self line];
    [self colorSelector];
}
- (UIView*)line
{
    if (!_line) {
        _line = [[UILabel alloc]init];
        _line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        [self addSubview:_line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.penSlider.mas_right).offset(leftBand);
            make.width.mas_equalTo(@(1));
            make.bottom.equalTo(self);
        }];
    }
    return _line;
}
- (CSColorSeletor*)colorSelector
{
    if (!_colorSelector) {
        UserPreference *preference = [DJReadManager shareManager].preference;
        _colorSelector = [[CSColorSeletor alloc]initWithPreference:preference];
        _colorSelector.curIndexPath = [NSIndexPath indexPathForRow:[preference.colorUnits indexOfObject:preference.colorUnit] inSection:0];
        _colorSelector.layer.shadowColor = [UIColor blackColor].CGColor;
        _colorSelector.layer.shadowOffset = CGSizeMake(2, 2);
        _colorSelector.layer.shadowOpacity = 0.5;
        _colorSelector.layer.shadowRadius = 4;
        _colorSelector.selectorDelegate = self;
        _unit = preference.colorUnit;
        [self addSubview:_colorSelector];
        [_colorSelector mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).offset(leftBand/2);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-leftBand/2);
        }];
    }
    return _colorSelector;
}
- (CSSlider*)alphaSlider{
    if (!_alphaSlider) {
        [self addSubview:_alphaSlider];
        _alphaSlider.value = 50;
        [_alphaSlider setTitleLabTitle:@"硬度"];
        [_alphaSlider setValueLabValue:[NSString stringWithFormat:@"50  %%"]];
        [_alphaSlider addTarget:self action:@selector(alphaSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _alphaSlider;
}
- (CSSlider*)penSlider{
    if (!_penSlider) {
        _penSlider = [[CSSlider alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.2, self.frame.size.width/3, self.frame.size.height*0.6)];
        _penSlider.minimumValue = 1.0;
        _penSlider.maximumValue =10.0;
        [_penSlider setTitleLabTitle:@"笔粗"];
        [self addSubview:_penSlider];
        [_penSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftBand);
            make.top.equalTo(self).offset(leftBand);
            make.height.mas_equalTo(@(100));
            make.width.mas_equalTo(@(self.frame.size.width/3));
        }];
        _penSlider.value = 3;
        _penWidth = 3.0;
        [_penSlider setValueLabValue:[NSString stringWithFormat:@"px  3"]];
        [_penSlider addTarget:self action:@selector(penSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _penSlider;
}
- (void)penSliderValueChange:(CSSlider*)slider
{
    _penWidth = (int)slider.value;
    [slider setValueLabValue:[NSString stringWithFormat:@"px  %d",(int)slider.value]];
}
- (void)alphaSliderValueChange:(CSSlider*)slider
{
    _penAlpha = slider.value/1;
    [slider setValueLabValue:[NSString stringWithFormat:@"%f  %d",(int)slider.value]];
}
- (void)colorSelector:(CSColorSeletor *)seletor colorUnit:(ColorUnit *)unit{
    _unit = unit;
}
@end
