//
//  LandSpaceHandAttributeView.m
//  DJReader
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "LandSpaceHandAttributeView.h"
#import "CSSlider.h"
#import "CSLandSpaceColorSeletor.h"
#import "DJReadManager.h"

@interface LandSpaceHandAttributeView()<LandSpaceColorSeletorDelegate>
@property (nonatomic,strong)CSSlider *penSlider,*alphaSlider;
@property (nonatomic,strong)CSLandSpaceColorSeletor *colorSelector;

@end

@implementation LandSpaceHandAttributeView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubViews];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self loadSubViews];
}

- (void)loadSubViews
{
    if (self.frame.size.width < 100)
        return;
    if (!_penSlider) {
        _penSlider = [[CSSlider alloc]init];
        _penSlider.minimumValue = 1.0;
        _penSlider.maximumValue =10.0;
        [_penSlider setTitleLabTitle:@"笔粗"];
        [self addSubview:_penSlider];
        
        [_penSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.height.equalTo(self);
            make.width.mas_equalTo(@(self.frame.size.width/4));
        }];
    }
    
    _penSlider.value = 3;
    [_penSlider setValueLabValue:[NSString stringWithFormat:@"px  3"]];
    [_penSlider addTarget:self action:@selector(penSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    if (!_colorSelector) {
        UserPreference *preference = [DJReadManager shareManager].loginUser.preference;
        _colorSelector = [[CSLandSpaceColorSeletor alloc]initWithPreference:[DJReadManager shareManager].preference];
        _colorSelector.curIndexPath = [NSIndexPath indexPathForRow:[preference.colorUnits indexOfObject:preference.colorUnit] inSection:0];
        _colorSelector.layer.shadowColor = [UIColor blackColor].CGColor;
        _colorSelector.layer.shadowOffset = CGSizeMake(2, 2);
        _colorSelector.layer.shadowOpacity = 0.5;
        _colorSelector.layer.shadowRadius = 4;
        _colorSelector.selectorDelegate = self;
        
        [self addSubview:_colorSelector];
        [_colorSelector mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.penSlider.mas_right).offset(30);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-20);
        }];
    }
}

- (void)penSliderValueChange:(CSSlider*)slider
{
    self.penWidth = (int)slider.value;
    
    [slider setValueLabValue:[NSString stringWithFormat:@"px  %f",slider.value]];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(penWidthChange:)]) {
        [self.selectorDelegate penWidthChange:_penWidth];
    }
}

- (void)alphaSliderValueChange:(CSSlider*)slider
{
    _penAlpha = slider.value / 100.0;
    [slider setValueLabValue:[NSString stringWithFormat:@"%f  %%",slider.value]];
    
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(penHardChange:)]) {
        [self.selectorDelegate penHardChange:_penAlpha];
    }
}

- (void)colorSelector:(CSLandSpaceColorSeletor *)seletor colorUnit:(ColorUnit *)unit
{
    _unit = unit;
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(penColorUnitSelected:)]) {
        [self.selectorDelegate penColorUnitSelected:unit];
    }
}

@end
