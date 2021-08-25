//
//  SmallProgramIconView.m
//  DJReader
//
//  Created by Andersen on 2021/3/10.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramIconView.h"

@implementation SmallProgramIconView
- (void)setModel:(SmallProgramModel *)model
{
    _model = model;
    [self loadSubView];
}
- (void)loadSubView
{
    [_headView removeFromSuperview];
    [_titleLab removeFromSuperview];
    
    CGFloat headUnit = self.contentView.height/4;
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(headUnit, headUnit/2, headUnit*2, headUnit*2)];
    _headView.image = self.model.programHeader;
    _headView.contentMode = 2;
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, headUnit*2.8, self.contentView.width, headUnit)];
    _titleLab.text = self.model.programName;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:10];
    _titleLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:_headView];
    [self.contentView addSubview:_titleLab];
}
@end
