//
//  CSSignCell.m
//  DJReader
//
//  Created by Andersen on 2020/3/24.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSSignCell.h"
@interface CSSignCell()
@property (nonatomic,strong)UIImageView *signView;
@property (nonatomic,strong)UILabel *resource;
@property (nonatomic,strong)UIView *backView;
@end

@implementation CSSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setUnit:(DJSignSeal *)unit
{
    _unit = unit;
    [self loadSubViews];
}
- (void)loadSubViews
{
    _backView = [[UIImageView alloc]init];
    _backView.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.9 alpha:1.0] lightColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    _backView.layer.borderWidth = 1;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.height/8);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-self.height/8);
    }];

    _signView = [[UIImageView alloc]init];
    _signView.contentMode = UIViewContentModeScaleAspectFit;
    [_backView addSubview:_signView];
    [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(20);
        make.bottom.equalTo(self.backView).offset(-20);
        make.left.mas_equalTo(self.backView).offset(60);
        make.right.mas_equalTo(self.backView).offset(-60);
    }];
    _signView.image = _unit.sealImage;
    _resource =[[UILabel alloc]init];
    _resource.text = @"来源于: 点聚签章系统";
    _resource.font =[UIFont systemFontOfSize:10];
    _resource.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_resource];
    
    [_resource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(20));
        make.left.equalTo(self.signView);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.backView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)cellSelected:(BOOL)selected
{
    if (selected) {
        self.backView.backgroundColor = ControllerDefalutColor;
    }else{
        self.backView.backgroundColor = CSBackgroundColor;
    }
}
@end
