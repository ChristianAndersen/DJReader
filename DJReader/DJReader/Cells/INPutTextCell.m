//
//  INPutTextCell.m
//  DJSignExample
//
//  Created by dianju on 2017/11/8.
//  Copyright © 2017年 Andersen. All rights reserved.
//

#import "INPutTextCell.h"

@implementation INPutTextCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadView];
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)reloadContainer
{
    //下划分割线
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(self.frame.size.height/5);
        make.width.mas_equalTo(@(60));
    }];
    if (!_leftBtn) {
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right).offset(0);
            make.right.equalTo(self.contentView).offset(-80);
        }];
    }else{
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.textField.mas_right);
            make.right.equalTo(self.contentView);
        }];
    }
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@(0.5));
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)loadView{
    self.backgroundColor = [UIColor clearColor];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = ControllerDefalutColor;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _textField = [[UITextField alloc]init];
    [_textField addTarget:self action:@selector(textvalueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    _textField.keyboardAppearance=UIKeyboardAppearanceAlert;
    _textField.returnKeyType =UIReturnKeyDone;   //return键变成什么键
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.keyboardType = UIKeyboardTypeNumberPad;   //设置键盘的样式
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ControllerDefalutColor;
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_textField];
    [self reloadContainer];
}

- (void)showLeftBtn
{
    [self addSubview:_leftBtn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制textField的长度不超过12位
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    if (text.length > 11 &&![string isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}
- (void)editDidEnd:(id)sender{
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (void)textvalueDidChange:(id)sender{
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}

- (void)addLeftSender:(UIButton*)sender
{
    if (_leftBtn != nil || sender == nil) return;


    self.leftBtn = sender;
    [self.contentView addSubview:self.leftBtn];
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-sender.width-20);
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.textField.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    UILabel *line  = [[UILabel alloc]initWithFrame:CGRectMake(_leftBtn.x, _leftBtn.y, 0.5, _leftBtn.height)];
    line.backgroundColor = [UIColor systemTealColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_leftBtn.mas_left);
        make.width.mas_equalTo(@(0.5));
        make.top.equalTo(self.contentView).offset(3);
        make.bottom.equalTo(self.contentView).offset(-3);
    }];
}
- (void)configTitle:(NSString*)title andPlaceholder:(NSString *)phStr andValue:(NSString *)valueStr{
    self.titleLabel.text = title;
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:phStr? phStr:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.textField.attributedPlaceholder = placeholder;
    self.textField.text = valueStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
