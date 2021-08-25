//
//  AttributeCell.m
//  DJReader
//  首选项
//  Created by Andersen on 2020/6/23.
//  Copyright © 2020 Andersen. All rights reserved.

#import "AttributeCell.h"
@interface AttributeCell()
@property (nonatomic,strong)UISwitch *switchItem;
@end

@implementation AttributeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}
- (void)loadSubViews
{
    _switchItem = [[UISwitch alloc]init];
    _switchItem.onTintColor = [UIColor systemBlueColor];
    [_switchItem addTarget:self action:@selector(didSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchItem];
    [_switchItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self);
        make.width.mas_equalTo(@(80));
    }];
}

- (void)didSwitch:(UISwitch*)sender
{
    [DJReadManager shareManager].appPreference.readPosition = sender.on;
}
- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
