//
//  INPutTextCell.h
//  DJSignExample
//
//  Created by dianju on 2017/11/8.
//  Copyright © 2017年 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface INPutTextCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic)UITextField *textField;
@property (strong, nonatomic)UIButton *clearBtn,*leftBtn;
@property (strong, nonatomic)UIImageView *textFieldView;
@property (strong, nonatomic)UILabel *titleLabel;

@property (nonatomic, copy)void(^textValueChangedBlock)(NSString*);
@property (nonatomic, copy)void(^editDidEndBlock)(NSString*);

- (void)editDidEnd:(id)sender;
- (void)textvalueDidChange:(id)sender;
- (void)addLeftSender:(UIButton*)sender;
- (void)configTitle:(NSString*)title andPlaceholder:(NSString *)phStr andValue:(NSString *)valueStr;
@end
