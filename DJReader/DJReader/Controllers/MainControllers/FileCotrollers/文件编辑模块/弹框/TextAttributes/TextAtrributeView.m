//
//  TextAtrributeView.m
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "TextAtrributeView.h"
#import "CSNavBar.h"
@interface TextAtrributeView()
@property (nonatomic,strong)CSNavBar *menuBar;
@end
@implementation TextAtrributeView
- (instancetype)init{
    if (self = [super init]) {
    
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self menuBar];
}

- (CSNavBar *)menuBar{
    if (!_menuBar) {
        _menuBar = [[CSNavBar alloc]initWithFrame:self.frame];
        [self addSubview:_menuBar];
        
        [_menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIButton * fontNumItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [fontNumItem addTarget:self action:@selector(fontNumAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontNumItem setTitle:@"17px" forState:UIControlStateNormal];
        [fontNumItem setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];

        
        UIButton * fontTypeItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fontTypeItem addTarget:self action:@selector(fontTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontTypeItem setTitle:@"字体" forState:UIControlStateNormal];
        
        UIButton * fontBlodItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fontBlodItem addTarget:self action:@selector(fontTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        fontBlodItem.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [fontBlodItem setTitle:@"B" forState:UIControlStateNormal];
        
        UIButton * fontColorItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fontColorItem addTarget:self action:@selector(fontColorAction:) forControlEvents:UIControlEventTouchUpInside];
        [fontColorItem setTitle:@"颜色" forState:UIControlStateNormal];
        
        [self.menuBar setCenterItems:@[fontNumItem,fontBlodItem,fontTypeItem,fontColorItem]];
        [self.menuBar reloadItems];
    }
    return _menuBar;
}

- (void)fontNumAction:(UIButton*)sender
{
    
}

- (void)fontTypeAction:(UIButton*)sender
{
    
}

- (void)fontColorAction:(UIButton*)sender
{
    
}

@end
