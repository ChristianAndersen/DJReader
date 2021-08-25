//
//  CSFormCustomCell.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFormCustomCell.h"
@interface CSFormCustomModel()
@end
@implementation CSFormCustomModel
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
@end

@interface CSFormCustomCell()
@property (nonatomic,strong)UILabel *titleLab;
@end

@implementation CSFormCustomCell
- (instancetype)initWithModel:(CSFormModel*)model
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier]) {

    }
    return self;
}
- (void)setModel:(CSFormModel *)model
{
    [super setModel:model];
    [self loadSubviews];
}

- (void)loadSubviews
{
    [super layoutSubviews];
    CSFormCustomModel *customModel = (CSFormCustomModel*)self.model;
    CGFloat interval = 44.0;
    NSString *titleStr = [NSString stringWithFormat:@"%@:",self.model.name];
    CGSize size = [titleStr sizeWithFont:customModel.font inWidth:self.contentView.width - interval];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(interval, 0, size.width, interval)];
    _titleLab.text = titleStr;
    _titleLab.font = customModel.font;
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:customModel.content];
    @WeakObj(self)
    [customModel.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.titleLab.mas_bottom);
        make.bottom.equalTo(weakself.contentView).offset(-20);
        make.left.equalTo(weakself.contentView).offset(weakself.contentView.width/4);
        make.right.equalTo(weakself.contentView).offset(-weakself.contentView.width/4);
    }];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
