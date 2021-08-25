//
//  CSFormRadioCell.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFormRadioCell.h"
#import "CSRadio.h"
@interface CSFormRadioModel()
@end
@implementation CSFormRadioModel
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
@end
@interface CSFormRadioCell()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)NSMutableArray *radios;
@property (nonatomic,copy)NSString *selectedTitle;
@end
@implementation CSFormRadioCell
- (instancetype)initWithModel:(CSFormModel*)model
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier]) {
        
    }
    return self;
}

- (void)setModel:(CSFormModel *)model
{
    [super setModel:model];
    _radios = [[NSMutableArray alloc]init];
    [self loadSubviews];
}

- (void)loadSubviews
{
    [super layoutSubviews];
    CSFormRadioModel *radioModel = (CSFormRadioModel*)self.model;
    CGFloat interval = 50.0;
    CGFloat radioWidth = 80;
    CGFloat radioHeight = radioModel.font.pointSize*2;
    NSString *titleStr = [NSString stringWithFormat:@"%@:",self.model.name];
    CGSize size = [titleStr sizeWithFont:radioModel.font inWidth:self.contentView.width - interval];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(interval, 0, size.width, self.contentView.height)];
    _titleLab.text = titleStr;
    _titleLab.font = radioModel.font;
    [self.contentView addSubview:_titleLab];
    for (int i = 0; i<radioModel.items.count; i++) {
        NSString *itemTitle = [radioModel.items objectAtIndex:i];
        CSRadio *radio = [[CSRadio alloc]init];
        radio.title = itemTitle;
        radio.direction = 0;
        if ([self.model.value isEqualToString:itemTitle]) {
            radio.selected = YES;
        }
        [radio addTarget:self action:@selector(radioSelected:)];
        [self.contentView addSubview:radio];
        [radio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-radioWidth*i);
            make.width.mas_equalTo(@(radioWidth));
            make.height.mas_equalTo(@(radioHeight));
        }];
        [radio setNeedsDisplay];
        [self.radios addObject:radio];
    }
}

- (void)radioSelected:(CSRadio*)radio
{
    for (CSRadio *radioItem in self.radios) {
        radioItem.selected = NO;
    }
    radio.selected = YES;
    self.selectedTitle = radio.title;
    self.model.value = radio.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    
}

@end
