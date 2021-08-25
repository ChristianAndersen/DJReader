//
//  UserDetailCell.m
//  DJReader
//
//  Created by Andersen on 2020/9/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UserDetailCell.h"
@interface UserDetailCell()
@property (nonatomic,strong)UILabel *meassage,*line,*valueLab;
@property (nonatomic,strong)UIButton *sender;
@end

@implementation UserDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
- (void)setLab:(NSString*)title andImage:(UIImage *)image andValue:(NSString*)value;
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _meassage = [[UILabel alloc]init];
    _meassage.numberOfLines = 0;
    
    _valueLab = [[UILabel alloc]init];
    _valueLab.textColor = [UIColor grayColor];
    _valueLab.textAlignment = NSTextAlignmentRight;
    _valueLab.text = [NSString stringWithFormat:@"%@",value];
    [self.contentView addSubview:_valueLab];
    [self.contentView addSubview:_meassage];
    
    _line = [[UILabel alloc]init];
    [self.contentView addSubview:_line];
    _line.backgroundColor = [UIColor grayColor];
    
    NSString *userInfo = [NSString stringWithFormat:@"%@",title];
    NSMutableAttributedString *userAttributeStr = [[NSMutableAttributedString alloc]initWithString:userInfo];
    NSMutableParagraphStyle *userParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    userParagraphStyle.alignment = NSTextAlignmentLeft;
    userParagraphStyle.lineSpacing = 5;
    
    [userAttributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range: NSMakeRange(0, userInfo.length)];
    [userAttributeStr addAttribute:NSParagraphStyleAttributeName value:userParagraphStyle range:NSMakeRange(0, userInfo.length)];
    [userAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range: NSMakeRange(0, title.length)];
    
//    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
//    attach.image = image;
//    attach.bounds = CGRectMake(0, -5, 22, 22);
//
//    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
//    [userAttributeStr insertAttributedString:imageStr atIndex:0];
    _meassage.attributedText = userAttributeStr;
}

- (void)addAction:(SEL)action toTargt:(id)target title:(NSString*)title
{
    if (!_sender) {
        _sender = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sender addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_sender setTitle:title forState:UIControlStateNormal];
        [_sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_sender];
        _sender.layer.masksToBounds = YES;
        _sender.layer.cornerRadius = 5;
        _sender.layer.borderColor = [UIColor grayColor].CGColor;
        _sender.layer.borderWidth = 1;
    }
}
- (void)reloadSubView
{
    @WeakObj(self);
    [_meassage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.contentView);
        make.left.equalTo(weakself.contentView);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(@(30));
    }];
    [_valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_meassage);
        make.left.equalTo(_meassage.mas_right);
        make.right.equalTo(weakself.contentView);
        make.height.mas_equalTo(@(30));
    }];
    if (_sender) {
        [_sender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.contentView);
            make.width.mas_equalTo(@(100));
            make.height.mas_equalTo(@(34));
            make.bottom.equalTo(weakself.line);
        }];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(1));
            make.right.bottom.equalTo(_valueLab);
            make.left.equalTo(weakself.meassage.mas_left).offset(-5);
        }];
    }else{
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(1));
            make.right.equalTo(weakself.valueLab);
            make.bottom.equalTo(weakself.valueLab).offset(10);
            make.left.equalTo(weakself.meassage);
        }];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
