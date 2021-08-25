//
//  CSColorCell.m
//  DJReader
//
//  Created by Andersen on 2020/3/21.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSColorCell.h"
@interface CSColorCell()
@property (nonatomic,strong)CALayer *circleLayer,*shadowLayer;
@end

@implementation CSColorCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (void)setUnit:(ColorUnit *)unit
{
    if (unit) {
        _unit = unit;
        [self loadSubviews];
    }
}
- (void)loadSubviews
{
    CGFloat inset = 1.0;

    _circleLayer = [CALayer layer];
    _circleLayer.frame = CGRectInset(self.bounds, inset, inset);

    _circleLayer.masksToBounds = YES;
    _circleLayer.cornerRadius = (self.width -2*inset)/2;
    _circleLayer.backgroundColor = [UIColor colorWithRed:_unit.r/255.0 green:_unit.g/255.0 blue:_unit.b/255.0 alpha:1].CGColor;

    [self.contentView.layer addSublayer:_circleLayer];
}

- (void)setItemSelected:(BOOL)selected
{
    [_circleLayer removeFromSuperlayer];
    if (selected) {
        CGFloat inset = 1.0;
        _circleLayer = [CALayer layer];
        _circleLayer.frame = CGRectInset(self.bounds, inset, inset);

        _circleLayer.masksToBounds = YES;
        _circleLayer.cornerRadius = (self.width -2*inset)/2;
        _circleLayer.backgroundColor = [UIColor colorWithRed:_unit.r/255.0 green:_unit.g/255.0 blue:_unit.b/255.0 alpha:1].CGColor;
        _circleLayer.borderColor = [UIColor whiteColor].CGColor;
        _circleLayer.borderWidth = inset*2;
            
        _circleLayer.shadowColor = [UIColor blackColor].CGColor;
        _circleLayer.shadowOffset = CGSizeMake(0, 0);
        _circleLayer.shadowRadius = 4;
        _circleLayer.shadowOpacity = 1.0;
        [self.contentView.layer addSublayer:_circleLayer];
    }else{
        CGFloat inset = 1.0;

        _circleLayer = [CALayer layer];
        _circleLayer.frame = CGRectInset(self.bounds, inset, inset);

        _circleLayer.masksToBounds = YES;
        _circleLayer.cornerRadius = (self.width -2*inset)/2;
        _circleLayer.backgroundColor = [UIColor colorWithRed:_unit.r/255.0 green:_unit.g/255.0 blue:_unit.b/255.0 alpha:1].CGColor;
            
        [self.contentView.layer addSublayer:_circleLayer];
    }
}
@end
