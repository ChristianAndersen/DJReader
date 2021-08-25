//
//  CertificateCell.m
//  DJReader
//
//  Created by Andersen on 2020/8/10.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define intervalH 5.0
#define intervalW 15.0

#import "CertificateCell.h"

@interface CertificateCell ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UILabel *headLab;
@property (nonatomic,strong)UILabel *ownerLab;
@property (nonatomic,strong)UILabel *startTimeLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,assign)BOOL isLoad;

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)UIButton *deleted;
@end

@implementation CertificateCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.isLoad) {
        _isLoad = YES;
        //[self loadWithSize:self.frame.size];
        [self loadSubViews];
    }
    return;
}
//删除按钮
- (void)loadWithSize:(CGSize)size
{
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(intervalW, intervalH, size.width - intervalW*2, size.height - intervalH*2)];
    _myScrollView.delegate = self;
    _myScrollView.contentSize = CGSizeMake(size.width - intervalW*2 + 100, size.height - intervalH*2);
    _myScrollView.backgroundColor = [UIColor redColor];
    _myScrollView.bounces = NO;
    _myScrollView.userInteractionEnabled = YES;
    _myScrollView.layer.masksToBounds = YES;
    _myScrollView.layer.cornerRadius = 5;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    
    _deleted = [[UIButton alloc]initWithFrame:CGRectMake(size.width - intervalW*2, 0, 100, size.height - intervalH*2)];
    [_deleted addTarget:self action:@selector(scrollDeletedAction) forControlEvents:UIControlEventTouchUpInside];
    _deleted.backgroundColor = [UIColor blueColor];
    [_deleted setTitle:@"删除" forState:UIControlStateNormal];
    [_deleted setTitleColor:[UIColor systemPinkColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.myScrollView];
    [self.myScrollView addSubview:self.deleted];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  [scrollView setContentOffset:scrollView.contentOffset animated:YES];
  [self scrollViewDidEnd:scrollView];
}
- (void)scrollViewDidEnd:(UIScrollView*)scrollView
{
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    CGPoint point = scrollView.contentOffset;
    if (point.x > 50) {
        [UIView animateWithDuration:2.0 animations:^{
            [self.myScrollView setContentOffset:CGPointMake(100, 0) animated:YES];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  CGPoint offset = scrollView.contentOffset;
  if (offset.x < 0 ) {//左边不弹性
    offset.x = 0;
    [scrollView setContentOffset:offset animated:NO];
  }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    [self scrollViewDidEnd:scrollView];
}
- (void)hideButtonsWithAnimation
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self layoutIfNeeded];
}
- (void)scrollDeletedAction
{
    if (self.scrollDeleted) {
        self.scrollDeleted(self.indexPath);
    }
}
//删除按钮结束
- (void)setCertificate:(DJCertificate *)certificate
{
    _certificate = certificate;
    [self loadAttribute];
}
- (void)loadSubViews
{
    CGFloat contentWidth = self.contentView.width - intervalW*2;
    CGFloat headWidth = self.contentView.height - intervalW*2 - intervalH*2;
    CGFloat labWidth = headWidth/10;
    @WeakObj(self);
    _backView = [[UIView alloc]initWithFrame:CGRectMake(intervalW, intervalH, self.frame.size.width - intervalW*2, self.frame.size.height - intervalH*2)];
    _backView.backgroundColor = RGBACOLOR(231, 238, 246, 1);
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 10;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-intervalW);
        make.top.equalTo(self).offset(intervalH);
        make.left.equalTo(self).offset(intervalW);
        make.bottom.equalTo(self).offset(-intervalH);
    }];
    
    _headView = [[UIView alloc]init];
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = 10;
    _headView.layer.borderColor = [UIColor grayColor].CGColor;
    _headView.layer.borderWidth = 1.0;
    
    [self.contentView addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(intervalW);
        make.top.equalTo(self.backView).offset(intervalW);
        make.bottom.equalTo(self.backView).offset(-intervalW);
        make.width.mas_equalTo(@(headWidth));
    }];
    
    _headLab = [[UILabel alloc]init];
    _headLab.numberOfLines = 0;
    [self.headView addSubview:_headLab];
    [_headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.headView);
    }];
    _ownerLab = [[UILabel alloc]init];
    _ownerLab.numberOfLines = 0;
    [self.backView addSubview:_ownerLab];
    [_ownerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(intervalW);
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.width.mas_equalTo(@(contentWidth - headWidth - intervalH*2));
        make.height.mas_equalTo(@(labWidth*6));
    }];
    
    
    _endTimeLab = [[UILabel alloc]init];
    _endTimeLab.font = [UIFont systemFontOfSize:8];
    _endTimeLab.numberOfLines = 0;
    _endTimeLab.textColor = CSTextColor;
    [self.backView addSubview:_endTimeLab];
    [_endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(intervalW*3);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-intervalH/4);
        make.width.mas_equalTo(@(contentWidth - headWidth - intervalW*2));
        make.height.mas_equalTo(@(labWidth));
    }];
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = CSTextColor;
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTimeLab);
        make.bottom.equalTo(self.endTimeLab.mas_top).offset(-intervalH/2);
        make.width.mas_equalTo(@(contentWidth - headWidth - intervalW*6));
        make.height.mas_equalTo(@(1));
    }];
    _startTimeLab = [[UILabel alloc]init];
    _startTimeLab.font = [UIFont systemFontOfSize:8];
    _startTimeLab.numberOfLines = 0;
    _startTimeLab.textColor = CSTextColor;
    [self.backView addSubview:_startTimeLab];
    [_startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(intervalW*3);
        make.bottom.equalTo(line.mas_top).offset(-intervalH/2);
        make.width.mas_equalTo(@(contentWidth - headWidth - intervalW*2));
        make.height.mas_equalTo(@(labWidth));
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormatter];
    NSDate *startDate = [dateFormatter dateFromString:[NSString getCurrentTimeDate]];
    NSDate *endDate = [dateFormatter dateFromString:self.certificate.endtime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
        * 要比较的时间单位,常用如下,可以同时传：
        *    NSCalendarUnitDay : 天
        *    NSCalendarUnitYear : 年
        *    NSCalendarUnitMonth : 月
        *    NSCalendarUnitHour : 时
        *    NSCalendarUnitMinute : 分
        *    NSCalendarUnitSecond : 秒
    */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    NSString *flagImage = @"";
    NSString *labImage = @"";
    if (delta.day < 30 && delta.day >= 0) {
        flagImage = @"期限将至_下标";
        labImage = @"即将过期_标签";
    }else if(delta.day < 0){
        flagImage = @"期限已至_下标";
        labImage = @"证书到期_标签";
    }else{
        flagImage = @"期限未致_下标";
        labImage = @"证书有效_标签";
    }
    
    UIImageView *timeFlagView = [[UIImageView alloc]init];
    timeFlagView.image = [UIImage imageNamed:flagImage];
    [self.backView addSubview:timeFlagView];
    [timeFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.ownerLab);
        make.top.equalTo(weakself.startTimeLab);
        make.bottom.equalTo(weakself.endTimeLab);
        make.width.mas_equalTo(@(intervalW));
    }];
    
    UIImageView *certStatusView = [[UIImageView alloc]init];
    certStatusView.image = [UIImage imageNamed:labImage];
    certStatusView.contentMode = 1;
    [self.backView addSubview:certStatusView];
    [certStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.backView).offset(-intervalW);
        make.top.equalTo(weakself.backView);
        make.bottom.equalTo(weakself.ownerLab);
        make.width.mas_equalTo(@(intervalW));
    }];
    
    [self loadAttribute];
}
- (void)loadAttribute
{
    NSArray *info = [self.certificate.dn componentsSeparatedByString:@","];
    NSMutableDictionary *infoMap = [[NSMutableDictionary alloc]init];
    BOOL isIndividual = YES;
    for (NSString *item in info) {
        if ([item containsString:@"Individual"]) {
            isIndividual = YES;
            [infoMap setValue:@"个人" forKey:@"certType"];
        }else if([item containsString:@"Organizational"]){
            isIndividual = NO;
            [infoMap setValue:@"企业" forKey:@"certType"];
        }
    }
    NSString *certType = [infoMap objectForKey:@"certType"];
    NSString *headStr = [NSString stringWithFormat:@"%@\r\r密钥类型\r\nSM2",certType];

    NSMutableAttributedString *headAttributeStr = [[NSMutableAttributedString alloc]initWithString:headStr];
    NSMutableParagraphStyle *headParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    headParagraphStyle.alignment = NSTextAlignmentCenter;
    
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:@"个人证书_02"];
    attach.bounds = CGRectMake(-4, -4, 44, 25);

    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [headAttributeStr insertAttributedString:imageStr atIndex:certType.length + 1];

    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range: NSMakeRange(0, certType.length)];
    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range: NSMakeRange(certType.length + 3, 4)];
    [headAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range: NSMakeRange(certType.length + 9, 3)];
    
    [headAttributeStr addAttribute:NSForegroundColorAttributeName value:CSTextColor range: NSMakeRange(0, headStr.length + 1)];
    [headAttributeStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(136, 187, 236, 1.0) range: NSMakeRange(0, certType.length)];
    [headAttributeStr addAttribute:NSParagraphStyleAttributeName value:headParagraphStyle range:NSMakeRange(0, headStr.length + 1)];

    self.headLab.attributedText = headAttributeStr;
    NSString *ownerStr = [NSString stringWithFormat:@"%@\r\n%@",_certificate.certname,_certificate.bussinessCode];
    
    NSMutableAttributedString *ownerAttributeStr = [[NSMutableAttributedString alloc]initWithString:ownerStr];
    NSMutableParagraphStyle *ownerParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    ownerParagraphStyle.alignment = NSTextAlignmentCenter;

    [ownerAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range: NSMakeRange(0, _certificate.certname.length)];
    [ownerAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range: NSMakeRange(_certificate.certname.length, ownerStr.length - _certificate.certname.length)];
    [ownerAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.8 alpha:1.0] range: NSMakeRange(_certificate.certname.length, ownerStr.length - _certificate.certname.length)];

    self.ownerLab.attributedText = ownerAttributeStr;
    self.endTimeLab.text = self.certificate.starttime;
    self.startTimeLab.text = self.certificate.endtime;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
