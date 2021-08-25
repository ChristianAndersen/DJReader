//
//  InvitationAlert.m
//  DJReader
//
//  Created by Andersen on 2021/8/17.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "InvitationAlert.h"
//@interface AlertView()
//@end
//@implementation AlertView
//- (void)setImage:(UIImage*)image
//{
//    _image = image;
//    [self setNeedsDisplay];
//}
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    [self.image drawInRect:rect];
//}
//@end


@interface InvitationAlert()
@property (nonatomic,assign)CGRect alertFrame;
@end

@implementation InvitationAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat alertWidth = 370;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        self.alertFrame = CGRectMake((self.width - alertWidth)/2, self.centerY - 80 - alertWidth/2, alertWidth, alertWidth);
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView
{
    UIImageView *alert = [[UIImageView alloc]initWithFrame:self.alertFrame];
    [self addSubview:alert];
    alert.contentMode = UIViewContentModeScaleAspectFill;
    alert.image = [UIImage imageNamed:@"邀请好友弹框"];
    self.alertFrame = alert.frame;
    
    UIButton *cancel = [[UIButton alloc]init];
    [cancel addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [cancel setImage:[UIImage imageNamed:@"关闭邀请"] forState:UIControlStateNormal];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.mas_bottom).offset(20);
        make.centerX.equalTo(alert);
        make.width.equalTo(@(50));
        make.height.equalTo(@(45));
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(!CGRectContainsPoint(self.alertFrame,location))
        return;
    if (self.alertTouch) {
        [self close];
        self.alertTouch();
    }
}
- (void)close
{
    [self removeFromSuperview];
}
@end
