//
//  UserInfoCell.m
//  DJReader
//
//  Created by Andersen on 2020/6/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UserInfoCell.h"
@interface UserInfoCell()
@property (nonatomic,copy)NSString *headName;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *line;
@end

@implementation UserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
- (void)loadSubViews{
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setHead:(nullable NSString*)imgName title:(NSString*)title
{
    [_titleLab removeFromSuperview];
    [_line removeFromSuperview];
    CGRect lineRect = CGRectZero;
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(44, 12, kScreen_Width - 44, 24)];
    _titleLab.text = title;
    if (imgName) {
        lineRect = CGRectMake(10, self.height- 0.5, kScreen_Width, 1.0);
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 20, 20)];
        _headView.image = [UIImage imageNamed:imgName];
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_headView];
    }else{
        lineRect = CGRectMake(44, self.height - 0.5, kScreen_Width, 1.0);
        _titleLab.font = [UIFont systemFontOfSize:14.0];
    }
    _titleLab.textColor = CSTextColor;
    [self.contentView addSubview:_titleLab];
    _line = [[UILabel alloc]initWithFrame:lineRect];
    _line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [self.contentView addSubview:_line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
