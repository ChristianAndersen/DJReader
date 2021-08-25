//
//  CSSealCell.m
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSSealCell.h"
@interface CSSealCell()
@property (nonatomic,strong)UIImageView *sealView;
@property (nonatomic,strong)UILabel *resource;
@end


@implementation CSSealCell
- (void)setUnit:(DJSignSeal *)unit
{
    _unit = unit;
    [self loadSubViews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_sealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.height/8);
        make.left.equalTo(self.contentView).offset(self.width/4);
        make.right.equalTo(self.contentView).offset(-self.width/4);
        make.bottom.equalTo(self.contentView).offset(-self.height*3/8);
    }];
    [_resource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(20));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-self.height*1/10);
    }];
}
- (void)loadSubViews
{
    if (!self.sealView) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
        self.layer.borderWidth = 1;
        
        _sealView = [[UIImageView alloc]init];
        [self.contentView addSubview:_sealView];
        
        _sealView.image = _unit.sealImage;
        _resource =[[UILabel alloc]init];
        _resource.text = @"来源于: 点聚签章系统";
        _resource.font =[UIFont systemFontOfSize:10];
        _resource.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_resource];
    }

}

- (void)cellSelected:(BOOL)selected
{
    if (selected) {
        self.contentView.backgroundColor = ControllerDefalutColor;
    }else{
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
}
@end
