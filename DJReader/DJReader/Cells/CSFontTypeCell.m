//
//  CSFontTypeCell.m
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFontTypeCell.h"
@interface CSFontTypeCell ()
@property (nonatomic,strong)UILabel *fontLab;
@end

@implementation CSFontTypeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (void)setFontName:(NSString*)name
{
    if (!_fontLab) {
        _fontLab = [[UILabel alloc]initWithFrame:self.bounds];
        _fontLab.font = [UIFont systemFontOfSize:12];
        _fontLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_fontLab];
    }
    _fontLab.text = name;
}

- (void)setItemSelected:(BOOL)selected
{
    if (selected) {
        self.contentView.backgroundColor =  ControllerDefalutColor;
    }else{
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

@end
