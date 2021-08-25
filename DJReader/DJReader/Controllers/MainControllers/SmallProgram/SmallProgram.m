//
//  SmallProgram.m
//  DJReader
//
//  Created by Andersen on 2021/3/11.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgram.h"

@interface SmallProgram ()
@end

@implementation SmallProgram

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
}
- (void)loadProgramBar
{
    self.view.backgroundColor = CSBackgroundColor;
    CGFloat barWidth = self.view.width/4;
    CGFloat barHeight = 30;
    _programBar = [[UIView alloc]initWithFrame:CGRectMake(self.view.width*3/4 - 10, k_Height_NavContentBar, barWidth, barHeight)];
    _programBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _programBar.layer.masksToBounds = YES;
    _programBar.layer.cornerRadius = barHeight/2.0;
    [self.view addSubview:_programBar];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:[UIImage imageNamed:@"应用关闭"] forState:UIControlStateNormal];
    close.frame = CGRectMake(barWidth/2, 0, barWidth/2, barHeight);
    close.imageEdgeInsets = UIEdgeInsetsMake(barHeight/4, (barWidth/2 - barHeight/2)/2, barHeight/4, (barWidth/2 - barHeight/2)/2);
    [close addTarget:self action:@selector(programClose) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(barWidth/2, barHeight/4, 1, barHeight / 2)];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [_programBar addSubview:line];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:[UIImage imageNamed:@"应用分享"] forState:UIControlStateNormal];
    share.frame = CGRectMake(0, 0, barWidth/2, barHeight);
    share.imageEdgeInsets = UIEdgeInsetsMake(barHeight/4, (barWidth/2 - barHeight/2)/2, barHeight/4, (barWidth/2 - barHeight/2)/2);
    [share addTarget:self action:@selector(programShare) forControlEvents:UIControlEventTouchUpInside];
    
    [_programBar addSubview:close];
    [_programBar addSubview:share];
    [self.view addSubview:_programBar];
    [self.view bringSubviewToFront:_programBar];
}

- (void)loadSubView
{
    [self loadProgramBar];
}
- (void)programClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)programShare
{
    
}
- (void)openVIP
{
    [[DJReadManager shareManager]judgeUser:^(BOOL isLogin) {
        if (!isLogin) {GotoLoginControllerFrom(self);}
    } bindIPhone:^(BOOL bind) {
        if (!bind) {GotoBindPhoneControllerFrom(self);}
    } isVIP:^(BOOL isVIP) {
        GotoSubcribeControllerFrom(self);
    }];
}
- (UIImage *)drawShareWithTips:(NSArray*)tips
{
    CGFloat inset = 20;
    CGFloat codeW = 80;

    CGFloat width = self.view.size.width;
    CGFloat contentW = self.view.width - inset*2;
    CGFloat locationY = inset + 20;
    CGFloat contentLocationY = inset;
    
    NSString *userMeassage = [NSString stringWithFormat:@"来自[%@]的分享",[DJReadManager shareManager].loginUser.nickname];
    NSString *title = @"点聚OFD超级功能";
    NSString *footerTip = @"识别二维码进入点聚OFD,轻松使用此功能";
    
    UIImage *titleImage = [UIImage imageNamed:self.programName];
    UIImage *codeImage = [UIImage imageNamed:@"小程序分享二维码.jpg"];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //背景色
    [self.backgroundColor set];
    CGContextAddRect(context, self.view.bounds);
    CGContextFillPath(context);
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 1;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary*attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [userMeassage drawInRect:CGRectMake(inset, locationY, width - 40, 20) withAttributes:attribute];
    
    locationY = locationY + inset + 20;
    contentLocationY = locationY + inset/2;
    //中间白色区域
    [[UIColor whiteColor] set];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, nil, CGRectMake(inset, locationY, contentW, contentW), 10, 10);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    locationY = locationY + inset*2 + contentW;
    
    NSDictionary*titleAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor blackColor]};
    [title drawInRect:CGRectMake(inset*2, contentLocationY, contentW - inset*2, 20) withAttributes:titleAttribute];
    contentLocationY = contentLocationY + inset*2 + 20;
    
    [titleImage drawInRect:CGRectMake((width - codeW)/2, contentLocationY, codeW, codeW)];
    contentLocationY = contentLocationY + inset + codeW;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary*programNameAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.programName drawInRect:CGRectMake(inset*2, contentLocationY, contentW - inset*2, 20) withAttributes:programNameAttribute];
    contentLocationY = contentLocationY + inset + 20;

    [[UIColor colorWithWhite:0.8 alpha:1.0] set];
    CGPoint fromPoint = CGPointMake(inset*2, contentLocationY);
    CGPoint toPoint = CGPointMake(width - inset*2, contentLocationY);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);
    contentLocationY = contentLocationY + inset;
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary*tipAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
    
    for (int i = 0; i<tips.count; i++) {
        NSString *tip = [tips objectAtIndex:i];
        [tip drawInRect:CGRectMake(inset*2, contentLocationY, contentW - inset*2, 20) withAttributes:tipAttribute];
        contentLocationY = contentLocationY + 20;
    }
    //二维码
    [codeImage drawInRect:CGRectMake((width - codeW)/2, locationY, codeW, codeW)];
    locationY = locationY + inset + codeW;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary*footerAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [footerTip drawInRect:CGRectMake(inset, locationY, contentW, 20) withAttributes:footerAttribute];
    
    CGContextFillPath(context);
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

@end
