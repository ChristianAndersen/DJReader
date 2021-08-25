//
//  PopupsView.m
//  Popups
//
//  Created by Arthur on 2018/5/30.
//  Copyright © 2018年 Arthur. All rights reserved.
//

#import "PopupsViewBlock.h"
#define Interval 20
@interface PopupsViewBlock()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *contentView;

@end

@implementation PopupsViewBlock
- (instancetype)initWithImage:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView.frame = CGRectMake(0, 0, 300, 400);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(25, 100, 250, 250);
        self.imageView.image = [UIImage imageNamed:imageName];
        [self.imageView.image setAccessibilityIdentifier:imageName];
        [self.alertView addSubview:self.imageView];
    }
    return self;
}
- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView.frame = CGRectMake(0, 0, contentView.width + Interval*2, contentView.height + Interval*2);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];
        
        contentView.frame = CGRectMake(Interval, Interval, contentView.width, contentView.height);
        [self.alertView addSubview:contentView];
    }
    return self;
}
- (instancetype)initCompleteHander:(void (^)(NSString*))hander
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        _completeHander = hander;
        _contentView = [self createPopView];
        self.alertView.frame = CGRectMake(0, 0, _contentView.width + 40, _contentView.height + 40);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];
        [self.alertView addSubview:_contentView];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects]lastObject];
    CGPoint location = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.alertView.frame, location)) {
        [self dismissAlertView];
    }
}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 5;
    }
    return _alertView;
}
- (void)showView {
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
-(void)dismissAlertView {
    [UIView animateWithDuration:.2 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }completion:^(BOOL finish){
            [self removeFromSuperview];
        }];
    }];
}
//弹框
- (UITableView*)createPopView
{
    UITableView *popView = [[UITableView alloc]initWithFrame:CGRectMake(Interval, Interval, 300, 180)];
    popView.delegate = self;
    popView.dataSource = self;
    popView.tableHeaderView = [self tableViewHeader];
    return popView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* popIdent = @"popIdent";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popIdent];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:popIdent];
        cell.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"操作_输出为长图片"];
        cell.textLabel.text = @"输出为长图片";
        cell.detailTextLabel.text = @"将指定页面合成为一张图片";
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"操作_逐页输出图片"];
        cell.textLabel.text = @"逐页输出图片";
        cell.detailTextLabel.text = @"将指定页面分别输出为多张图片";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_completeHander) return;
        
    if (indexPath.row == 0) {
        _completeHander(Action_Option_images);
    }else if(indexPath.row == 1){
        _completeHander(Action_Option_images);
    }
}
- (UIView*)tableViewHeader
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    title.text = @"选择输出图片方式";
    return title;
}
- (void)dealloc{
    _completeHander = nil;
}
@end
