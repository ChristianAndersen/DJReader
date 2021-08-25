//
//  CSTextAttributePickerView.m
//  DJReader
//
//  Created by Andersen on 2020/3/18.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSTextAttributePickerView.h"
#define MainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
@implementation CSPickViewItem
- (instancetype)initWithCenterColorR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    if(self = [super init]) {
        _r = r;
        _g = g;
        _b = b;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat minWidth = MIN(self.frame.size.height, self.frame.size.width)/2;
    
    UILabel*center = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - minWidth)/2, self.frame.size.height/4, minWidth, minWidth)];
    center.backgroundColor = [UIColor colorWithRed:_r/255.0 green:_g/255.0 blue:_b/255.0 alpha:1.0];
    center.layer.masksToBounds = YES;
    center.layer.cornerRadius = minWidth/2;
    [self addSubview:center];
}

- (void)drawCenterR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    CGFloat minWidth = MIN(self.frame.size.height, self.frame.size.width)/2;
    if (!self.center) {
        self.center = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - minWidth)/2, self.frame.size.height/4, minWidth, minWidth)];
        self.center.backgroundColor = [UIColor colorWithRed:_r green:_g blue:_b alpha:1.0];
        self.center.layer.masksToBounds = YES;
        self.center.layer.cornerRadius = minWidth/2;
        [self addSubview:self.center];
    }
}

@end
@interface CSTextAttributePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView   *pickerView;

@property (strong, nonatomic) UIButton       *cancelBtn;
@property (strong, nonatomic) UIButton       *DetermineBtn;

@property (strong, nonatomic) UIView         *darkView;
@property (strong, nonatomic) UIView         *backView;

@property (strong, nonatomic) UIBezierPath   *bezierPath;
@property (strong, nonatomic) CAShapeLayer   *shapeLayer;

@property (strong, nonatomic) NSArray        *shengArray;
@property (strong, nonatomic) NSArray        *shiArray;
@property (strong, nonatomic) NSArray        *xianArray;

@property (strong, nonatomic) NSMutableArray *shiArr;
@property (strong, nonatomic) NSMutableArray *xianArr;

@property (strong, nonatomic) NSArray        *fontNumArray;
@property (strong, nonatomic) NSArray        *colorArray;
@property (strong, nonatomic) NSMutableArray        *fontNameArray;
@end

@implementation CSTextAttributePickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height + 300);
        [self initData];
        [self initGesture];
    }
    return self;
}

- (void)show {
    
    [self initView];
}

- (void)initView {
    [self showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.DetermineBtn];
    [self.backView addSubview:self.pickerView];
    
    [self bezierPath];
    [self shapeLayer];
}

- (void)initData {
    _fontNameArray = [[NSMutableArray alloc]init];
    
    _fontNumArray = @[@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    
    NSArray*fontFamilyArray = [UIFont familyNames];
    
    for (NSString* familyName in fontFamilyArray) {
        [_fontNameArray addObject:familyName];
    }
    _colorArray = @[@{@"id":@(1),@"r":@"233",@"g":@"180",@"b":@"120"},@{@"id":@(1),@"r":@"255",@"g":@"0",@"b":@"0"},@{@"id":@(1),@"r":@"0",@"g":@"255",@"b":@"0"},@{@"id":@(1),@"r":@"0",@"g":@"0",@"b":@"255"},@{@"id":@(1),@"r":@"80",@"g":@"120",@"b":@"230"},@{@"id":@(1),@"r":@"190",@"g":@"200",@"b":@"230"},@{@"id":@(1),@"r":@"233",@"g":@"200",@"b":@"130"},@{@"id":@(1),@"r":@"133",@"g":@"109",@"b":@"209"}];
}

- (void)initGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    [self addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGPoint point = self.center;
        point.y      -= 250;
        self.center   = point;
    } completion:^(BOOL finished) {
    }];
    
    [view addSubview:self];
}

- (void)dismiss {

    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y      += 250;
        self.center   = point;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return _fontNumArray.count;
            break;
        case 1:
            return _fontNameArray.count;
            break;
        case 2:
            return _colorArray.count;
            break;
        default:
            break;
    }
    return 0;
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return _fontNumArray[row];
            break;
        case 1:
            return _fontNameArray[row];
            break;
        case 2:
            return _colorArray[row][@"name"];
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    if (component == 0 ||component == 1) {
        return 20;
    }else{
        return 40;
    }
}

// 设置row字体，颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (component == 0 || component == 1) {
        UILabel* pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment   = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font            = [UIFont systemFontOfSize:16.0];
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    }else{
        CGFloat r = [_colorArray[row][@"r"] floatValue];
        CGFloat g = [_colorArray[row][@"g"] floatValue];
        CGFloat b = [_colorArray[row][@"b"] floatValue];
        
        CSPickViewItem *item = [[CSPickViewItem alloc]initWithCenterColorR:r g:g b:b];
        return item;
    }
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView                 = [[UIView alloc]init];
        _darkView.frame           = self.frame;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha           = 0.3;
    }
    return _darkView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 250);
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    }
    return _bezierPath;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = _backView.bounds;
        _shapeLayer.path = _bezierPath.CGPath;
        _backView.layer.mask = _shapeLayer;
    }
    return _shapeLayer;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView                 = [[UIPickerView alloc]init];
        _pickerView.frame           = CGRectMake(0, 50, kScreen_Width, 200);
        _pickerView.delegate        = self;
        _pickerView.dataSource      = self;
        _pickerView.backgroundColor = MainBackColor;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, 0, 50, 50);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(kScreen_Width - 50, 0, 50, 50);
        [_DetermineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DetermineBtn;
}

- (void)determineBtnAction:(UIButton *)button {
    
    NSInteger fontNumRow = [_pickerView selectedRowInComponent:0];
    NSInteger fontNameRow   = [_pickerView selectedRowInComponent:1];
    NSInteger colorRow  = [_pickerView selectedRowInComponent:2];
    
    if (self.determineBtnBlock) {
        self.determineBtnBlock([_fontNumArray[fontNumRow] integerValue],
                               _fontNameArray[fontNameRow] ,@{@"r":_colorArray[colorRow][@"r"],@"g":_colorArray[colorRow][@"g"],@"b":_colorArray[colorRow][@"b"]});
    }
    
    [self dismiss];
}

@end
