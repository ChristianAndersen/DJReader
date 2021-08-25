//
//  CSKeyBoardView.m
//  DJReader
//
//  Created by Andersen on 2020/3/13.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define ImageHeight 75.0f
#define Interval 5.f
#define btnHeight 35
#define attributeSeletorHeight 49
#define keyBoardControllHeight 83
#import "CSKeyBoardView.h"
#import "CSTextAttributePickerView.h"
#import "CSTextColorSeletor.h"
#import "CSTextFontTypeSeletor.h"
#import "FIleEditorView.h"
@interface CSKeyBoardView()<UITextFieldDelegate,UITextViewDelegate,CSTextColorSeletorDelegate,CSTextFontSeletorDelegate>
@property (nonatomic,strong)UIButton * sureBtn;
@property (nonatomic,strong)UIView *attributes;
@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)CSTextColorSeletor *colorSeletor;
@property (nonatomic,strong)CSTextFontTypeSeletor *fontTypeSeletor;
@property (nonatomic,strong)CSTextFontTypeSeletor *fontNumbSeletor;
@property (nonatomic,strong)UserPreference*preference;
@property (nonatomic,assign)long curSenderTag;
@end

@implementation CSKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame preference:(UserPreference*)preference
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.curSenderTag = 0;
        self.preference = preference;
        [self addKeyBoardNotification];
        [self loadSubViews];
    }
    return self;
}

- (UIFont*)curFont
{
    _curFont = [UIFont fontWithName:self.preference.fontNameKey size:[self.preference.fontNum intValue]];
    if (_curFont == nil) {
        _curFont = [UIFont systemFontOfSize:[self.preference.fontNum intValue]];
    }
    return _curFont;
}

- (UIColor*)curColor
{
    _curColor = [UIColor colorWithRed:self.preference.colorUnit.r green:self.preference.colorUnit.g blue:self.preference.colorUnit.b alpha:1.0];
    return _curColor;
}

- (void)setHandle:(DJTextBlockHandle *)handle
{
    _handle = handle;
    if (![_handle.text isEqualToString:TextTipStr])
    {
       self.textView.text = handle.text;
    }
    [handle setFont:self.curFont];
    [handle setColor:self.curColor];
}

- (void)keyboardWillhide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.y = kScreen_Height - keyBoardControllHeight;
    self.height = keyBoardControllHeight;
    self.bgView.y = 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.bgView.y = 0;
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;
    
    self.frame = CGRectMake(self.x, 0, self.width, self.height);
    self.height = kScreen_Height;
    [UIView animateWithDuration:duration animations:^{
        self.bgView.y = keyboardY - k_TabBar_Height - (btnHeight*2 + Interval *3);
    }];
}

- (void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadSubViews
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.sureBtn];
    [self.bgView addSubview:self.attributeView];
    [self.textView becomeFirstResponder];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
//    tapGesture.numberOfTapsRequired=1;
//    [self addGestureRecognizer:tapGesture];
}


- (void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer
{
    [self endEditing:YES];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, btnHeight*2 + Interval *2)];
        
        UIView * bLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bgView.width, 0.5f)];
        bLine.backgroundColor = [UIColor grayColor];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:bLine];
    }
    return _bgView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(Interval, Interval, kScreen_Width - Interval * 3 - btnHeight * 1.5, btnHeight)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor= [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        _textView.scrollsToTop = NO;
        _textView.inputAccessoryView = nil;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        _textView.delegate = self;
        _textView.inputAccessoryView = nil;
    }
    return _textView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(kScreen_Width - btnHeight*1.5 - Interval, Interval, btnHeight*1.5, btnHeight);
        [_sureBtn setBackgroundColor:ControllerDefalutColor];
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView*)attributeView
{
    if (!_attributes) {
        CGFloat itemWith = 60;
        _attributes = [[UIView alloc]initWithFrame:CGRectMake(0, btnHeight + Interval*2, self.width, btnHeight)];
        _attributes.backgroundColor = [UIColor colorWithRed:210/255.f green:210/255.f blue:216/255.f alpha:1.0];
        
        UIButton * fontNumItem = [UIButton buttonWithType:UIButtonTypeCustom];
        fontNumItem.frame =CGRectMake(0, 0, itemWith, _attributes.height);
        [fontNumItem addTarget:self action:@selector(attributAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontNumItem setTitle:@"17px" forState:UIControlStateNormal];
        [fontNumItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fontNumItem.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [fontNumItem setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];
        [fontNumItem setImageEdgeInsets:UIEdgeInsetsMake(10, 40, 10, 10)];
        [fontNumItem setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
        fontNumItem.tag = 0x10000001;
        
        UIButton * fontTypeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        fontTypeItem.frame =CGRectMake(itemWith, 0, itemWith, _attributes.height);
        [fontTypeItem addTarget:self action:@selector(attributAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontTypeItem setTitle:@"字体" forState:UIControlStateNormal];
        [fontTypeItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fontTypeItem.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [fontTypeItem setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];
        [fontTypeItem setImageEdgeInsets:UIEdgeInsetsMake(10, 40, 10,10)];
        [fontTypeItem setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
        fontTypeItem.tag = 0x10000002;
        
        UIButton * fontColorItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [fontColorItem addTarget:self action:@selector(attributAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontColorItem setTitle:@"颜色" forState:UIControlStateNormal];
        fontColorItem.frame =CGRectMake(_attributes.width - itemWith, 0, itemWith, _attributes.height);
        [fontColorItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fontColorItem.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [fontColorItem setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];
        [fontColorItem setImageEdgeInsets:UIEdgeInsetsMake(10, 40, 10, 10)];
        [fontColorItem setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
        fontColorItem.tag = 0x10000003;
        
        [_attributes addSubview:fontNumItem];
        [_attributes addSubview:fontTypeItem];
        [_attributes addSubview:fontColorItem];
    }
    return _attributes;
}

- (void)sureAction{
    [self.handle submitWithText:self.textView.text];
    [self.handle setFont:self.curFont];
    [self.handle setColor:self.curColor];
    [self.parentView changeBarSeleted:Action_PaiBan];
    [self endEditing:YES];
}

- (void)showView
{
    [self setHidden:NO];
    [self.textView becomeFirstResponder];
}

- (void)hideView
{
    [self.textView resignFirstResponder];
    [self setHidden:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.handle submitWithText:self.textView.text];
    [self.handle setFont:self.curFont];
    [self.handle setColor:self.curColor];
    [self.parentView changeBarSeleted:Action_PaiBan];
    [self endEditing:YES];
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   if ([text isEqualToString:@"\n"]) {
       [self.handle submitWithText:self.textView.text];
       [self.handle setFont:self.curFont];
       [self.handle setColor:self.curColor];
       [self.parentView changeBarSeleted:Action_PaiBan];
       [self endEditing:YES];
       [textView resignFirstResponder];
       return NO;
   }else{
       return YES;
   }
}
- (void)attributAction:(UIButton*)sender
{
    CGFloat shrinkHeight = btnHeight*2 + Interval * 2;
    CGFloat popHeight = shrinkHeight + attributeSeletorHeight;
    CGFloat atributePopHeight = btnHeight + attributeSeletorHeight;
        
    if (self.bgView.height >= popHeight) {//弹出状态，点击当前按钮，应收回
        if (sender.tag == _curSenderTag) {
            [UIView animateWithDuration:0.2 animations:^{
                self.bgView.frame = CGRectMake(0, self.bgView.frame.origin.y + attributeSeletorHeight, kScreen_Width, shrinkHeight);
                self.attributes.frame = CGRectMake(self.attributes.frame.origin.x, self.attributes.frame.origin.y, self.attributes.frame.size.width, btnHeight);
            }];
        }
    }else{
            [UIView animateWithDuration:0.2 animations:^{
             self.bgView.frame = CGRectMake(0, self.bgView.frame.origin.y - attributeSeletorHeight, kScreen_Width, popHeight);
             self.attributes.frame = CGRectMake(self.attributes.frame.origin.x, self.attributes.frame.origin.y, self.attributes.frame.size.width, atributePopHeight);
            }];
    }
    _curSenderTag = sender.tag;
    switch (sender.tag) {
        case 0x10000001:{
            [self addFontNumbSeletorView];
        } break;
        case 0x10000002:{
            [self addFontTypeSeletorView];
        } break;
        case 0x10000003:{
            [self addColorSeletorView];
        } break;
        default:
            break;
    }
}

- (void)addColorSeletorView
{
    if (!self.colorSeletor ) {
        self.colorSeletor = [[CSTextColorSeletor alloc]initWithFrame:CGRectMake(0, keyBoardControllHeight, kScreen_Width, attributeSeletorHeight) colors:self.preference.colorUnits];
        self.colorSeletor.curIndexPath =[NSIndexPath indexPathForRow:[self.preference.colorUnits indexOfObject:self.preference.colorUnit] inSection:0];
        self.colorSeletor.layer.shadowColor = [UIColor blackColor].CGColor;
        self.colorSeletor.layer.shadowOffset = CGSizeMake(2, 2);
        self.colorSeletor.layer.shadowOpacity = 0.5;
        self.colorSeletor.layer.shadowRadius = 4;
        self.colorSeletor.selectorDelegate = self;
        [self.bgView addSubview:self.colorSeletor];
        _fontTypeSeletor.hidden = YES;
        _fontNumbSeletor.hidden = YES;
    }else{
        if (_colorSeletor.hidden == YES) {
            _colorSeletor.hidden = NO;
            _fontNumbSeletor.hidden = YES;
            _fontTypeSeletor.hidden = YES;
        }else{
            _colorSeletor.hidden = YES;
        }
    }
}

- (void)addFontNumbSeletorView
{
     if (!self.fontNumbSeletor ) {
         self.fontNumbSeletor = [[CSTextFontTypeSeletor alloc]initWithFrame:CGRectMake(0, keyBoardControllHeight, kScreen_Width, attributeSeletorHeight)fonts:self.preference.fontsNum];
         self.fontNumbSeletor.curIndexPath = [NSIndexPath indexPathForRow:[self.preference.fontsNum indexOfObject:self.preference.fontNum] inSection:0];
        self.fontNumbSeletor.layer.shadowColor = [UIColor blackColor].CGColor;
        self.fontNumbSeletor.layer.shadowOffset = CGSizeMake(2, 2);
        self.fontNumbSeletor.layer.shadowOpacity = 0.5;
        self.fontNumbSeletor.layer.shadowRadius = 4;
        self.fontNumbSeletor.selectorDelegate = self;
        _colorSeletor.hidden = YES;
        _fontTypeSeletor.hidden = YES;
        [self.bgView addSubview:self.fontNumbSeletor];
    }else{
        if (_fontNumbSeletor.hidden == YES) {
            _fontNumbSeletor.hidden = NO;
            _fontTypeSeletor.hidden = YES;
            _colorSeletor.hidden = YES;
        }else{
            _fontTypeSeletor.hidden = YES;
        }
    }
}

- (void)addFontTypeSeletorView
{
    if (!self.fontTypeSeletor ) {

        self.fontTypeSeletor = [[CSTextFontTypeSeletor alloc]initWithFrame:CGRectMake(0, keyBoardControllHeight, kScreen_Width, attributeSeletorHeight) fonts:self.preference.fontsName.allKeys];
        self.fontTypeSeletor.curIndexPath = [NSIndexPath indexPathForRow:[self.preference.fontsName.allKeys indexOfObject:self.preference.fontName] inSection:0];
        self.fontTypeSeletor.layer.shadowColor = [UIColor blackColor].CGColor;
        self.fontTypeSeletor.layer.shadowOffset = CGSizeMake(2, 2);
        self.fontTypeSeletor.layer.shadowOpacity = 0.5;
        self.fontTypeSeletor.layer.shadowRadius = 4;
        self.fontTypeSeletor.selectorDelegate = self;
        [self.bgView addSubview:self.fontTypeSeletor];
        _colorSeletor.hidden = YES;
        _fontNumbSeletor.hidden = YES;
    }else{
        if (_fontTypeSeletor.hidden == YES) {
            _fontTypeSeletor.hidden = NO;
            _colorSeletor.hidden = YES;
            _fontNumbSeletor.hidden = YES;
        }else{
            _fontTypeSeletor.hidden = YES;
        }
    }
}

#pragma attribute-delegate
- (void)fontTypeSelector:(CSTextFontTypeSeletor*)seletor indexPath:(NSIndexPath*)indexPath
{
    if ([seletor isEqual:_fontNumbSeletor]) {
        self.preference.fontNum = [self.preference.fontsNum objectAtIndex:indexPath.row];
    }else if ([seletor isEqual:_fontTypeSeletor]){
        self.preference.fontName = [self.preference.fontsName.allKeys objectAtIndex:indexPath.row];
        self.preference.fontNameKey = [self.preference.fontsName.allValues objectAtIndex:indexPath.row];
    }
    [_handle setFont:self.curFont];
}

- (void)textColorSelector:(CSTextColorSeletor *)seletor indexPath:(nonnull NSIndexPath *)indexPath
{
    self.preference.colorUnit = [self.preference.colorUnits objectAtIndex:indexPath.row];
    [_handle setColor:self.curColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
