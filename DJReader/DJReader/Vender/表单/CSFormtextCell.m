//
//  CSFormtextCell.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFormtextCell.h"

@implementation CSFormtextModel
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
@end

@interface CSFormtextCell()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *inputField;
@property (nonatomic,strong)UILabel *titleLab;
@end

@implementation CSFormtextCell
- (instancetype)initWithModel:(CSFormModel*)model
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier]) {
        self.model = model;
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
    CSFormtextModel *textModel = (CSFormtextModel*)self.model;
    CGFloat interval = 50.0;
    NSString *titleStr = [NSString stringWithFormat:@"%@:",self.model.name];
    CGSize size = [titleStr sizeWithFont:textModel.font inWidth:self.contentView.width - interval];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(interval, 0, size.width, self.contentView.height)];
    _titleLab.text = titleStr;
    _titleLab.font = textModel.font;
    [self.contentView addSubview:_titleLab];
    
    _inputField = [[UITextField alloc]initWithFrame:CGRectMake(interval+_titleLab.size.width + 10, 0, self.contentView.width - interval - _titleLab.size.width - 10, _titleLab.size.height)];
    _inputField.borderStyle = UITextBorderStyleNone;
    _inputField.delegate = self;
    _inputField.placeholder = textModel.placeholder;
    _inputField.font = textModel.font;
    if (textModel.value) {
        _inputField.text = textModel.value;
    }
    [_inputField addTarget:self action:@selector(textvalueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_inputField];
    

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (self.model.formType) {
        case 0:{
            _inputField.keyboardType = UIKeyboardTypeDefault;
        }break;
        case 1:{
            _inputField.keyboardType = UIKeyboardTypeNamePhonePad;
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",textField.text];
            [str replaceCharactersInRange:range withString:string];
            NSString *regex = @"[0-9]{0,11}";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isValid = [predicate evaluateWithObject:str];
            return isValid;
        }break;
        case 2:{
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",textField.text];
            [str replaceCharactersInRange:range withString:string];
            NSString *regex = @"[A-Za-z0-9]{0,18}";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isValid = [predicate evaluateWithObject:str];
            return isValid;
        }break;
        case 3:{
            _inputField.keyboardType = UIKeyboardTypeASCIICapable;
        }break;
        case 4:{
        }break;
        default:
            break;
    }
    return YES;
}
- (void)textvalueDidChange:(UITextField *)textField
{
    self.model.value = textField.text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
