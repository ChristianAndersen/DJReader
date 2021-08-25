//
//  SmallProgramSearchCell.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramSearchCell.h"

@implementation SmallProgramSearchCell
- (void)setModel:(SmallProgramModel *)model
{
    _model = model;
    [_headBackView removeFromSuperview];
    [_headView removeFromSuperview];
    [_title removeFromSuperview];
    CGFloat headUnit = self.contentView.height;
    
    _headBackView = [[UIView alloc]init];
    _headBackView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _headBackView.layer.masksToBounds = YES;
    _headBackView.layer.cornerRadius = headUnit/2;
    _headBackView.layer.borderColor = [UIColor grayColor].CGColor;
    _headBackView.layer.borderWidth = 1.0;
    _headBackView.contentMode = UIViewContentModeCenter;
    
    _headView = [[UIImageView alloc]init];
    _headView.image = _model.programHeader;
    _headView.contentMode = 2;
    [_headBackView addSubview:_headView];
    
    _title = [[UILabel alloc]init];
    _title.text = model.programName;
    _title.textColor = [UIColor grayColor];
    _title.font = [UIFont systemFontOfSize:12];
    _title.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_headBackView];
    [self.contentView addSubview:_title];
    [_headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(@(headUnit));
        make.height.mas_equalTo(@(headUnit));
        make.centerY.equalTo(self.contentView);
    }];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headBackView);
        make.width.mas_equalTo(@(headUnit/2));
        make.height.mas_equalTo(@(headUnit/2));
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBackView.mas_right).offset(10);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(120));
        make.centerY.equalTo(_headBackView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
