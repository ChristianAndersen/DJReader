//
//  CSLoadingView.m
//  DJReader
//
//  Created by Andersen on 2020/6/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSLoadingView.h"
#define titleHeight 35
#define meassageHeight 35

@interface CSLoadingView()
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *content;
@property (nonatomic,strong)UILabel *meassage;
@end

@implementation CSLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if ([DJReadManager deviceType] == 0) {
            [self loadSubViews];
        }else{
            [self loadSubView_iPad];
        }
    }
    return self;
}

- (void)loadSubView_iPad
{
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleHeight)];
    _title.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.3 alpha:1.0] lightColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
    _title.font = [UIFont systemFontOfSize:15];
    _title.textColor = [UIColor drakColor:[UIColor colorWithWhite:0.98 alpha:1.0] lightColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    
    _title.layer.shadowColor = [UIColor blackColor].CGColor;
    _title.layer.shadowOffset = CGSizeMake(0, 0);
    _title.layer.shadowRadius = 1.0;
    _title.layer.shadowOpacity = 0.8;
    
    [self addSubview:_title];
    
    CGFloat contentHeight = MIN(self.frame.size.height,self.frame.size.width)/3;

    _content = [[UIImageView alloc]initWithFrame:CGRectMake(contentHeight, contentHeight, contentHeight, contentHeight)];
    [self addSubview:_content];
    
    _meassage = [[UILabel alloc]initWithFrame:CGRectMake(0, _content.frame.origin.y + contentHeight, self.frame.size.width, titleHeight)];
    if (@available(iOS 13.0, *)) {
        _meassage.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        _meassage.backgroundColor = [UIColor whiteColor];
    }
    _meassage.textAlignment = NSTextAlignmentCenter;
    _meassage.textColor = [UIColor drakColor:[UIColor whiteColor] lightColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    _meassage.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_meassage];
}
- (void)loadSubViews
{
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleHeight)];
    _title.backgroundColor = CSBackgroundColor;
    _title.font = [UIFont systemFontOfSize:15];
    _title.textColor = CSTextColor;
    
    [self addSubview:_title];
    
    CGFloat contentHeight = MIN((self.frame.size.height - titleHeight*6), (self.width - titleHeight*6));
    CGFloat y = (self.frame.size.height - contentHeight)/2 - titleHeight;

    _content = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - contentHeight)/2, y, contentHeight, contentHeight)];
    [self addSubview:_content];
    
    _meassage = [[UILabel alloc]initWithFrame:CGRectMake(0, _content.frame.origin.y + contentHeight, self.frame.size.width, titleHeight)];
    _meassage.backgroundColor = CSBackgroundColor;
    _meassage.textAlignment = NSTextAlignmentCenter;
    _meassage.textColor = CSTextColor;
    _meassage.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_meassage];
}

- (void)setTitle:(NSString *)title meassage:(NSString*)meassage content:(UIImage*)image
{
    _title.text = [NSString stringWithFormat:@"    %@",title];
    _meassage.text = meassage;
    _content.image = image;
}
@end
