//
//  AboutUsController.m
//  DJReader
//
//  Created by Andersen on 2020/9/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "AboutUsController.h"
#define AboutUs_Interval 30
#define AboutUs_HeadHeight 120
@interface AboutUsController ()
@property (nonatomic,strong)UIScrollView *mainView;
@property (nonatomic,strong)UIView *mainInfoView,*addressView,*versionView;
@property (nonatomic,strong)NSArray *message;
@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = CSBackgroundColor;
    [self loadData];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:[self mainInfoView]];
    [self.mainView addSubview:[self addressView]];
    [self.mainView addSubview:[self versionView]];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadData
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _message = @[@"点聚\r\r\t北京点聚信息技术有限公司成立于2004年,是国内较早涉足信创安全领域，在产品研发、适配应用服务及产品化推广方面积累了深厚行业经验的高新技术企业和双软认证企业。十六年来一直坚持以实现核心技术突破为战略方向, 坚定不移地走自主创新之路,自主研发了电子签章、手写签批、柜面无纸化、OFD版式文件等一系列信息安全无纸化产品。\n\n\t点聚自主研发的OFD版式软件是一款覆 盖版式文档全生命周期的产品，历经三年多的匠心打磨版本迭代，已在功能性、安全性、稳定性、扩展性和易用性等多个层次达到较高成熟度，并已通过国家OFD标准符合性测试与国产软硬件环境的适配，有效地解决关键基础软件的自主安全可控问题。",@"北京点聚信息技术有限公司\rAddress: 北京市海淀区中关村东升科技园加速器分站A7幢\rCompany Tel: 010-82211788;62277399"];
}

- (CGFloat)contentHeight
{
    CGFloat height = 0;
    CGFloat middleInterval = 20;
    CGFloat fotterHeight = 100;
    for (NSString *msg in self.message) {
        height = height + [msg sizeWithFont:[UIFont systemFontOfSize:12] inWidth:self.view.width - AboutUs_Interval*2].height;
    }
    height = height + AboutUs_HeadHeight + middleInterval + fotterHeight;
    return height;
}

- (UIScrollView*)mainView
{
    if (!_mainView) {
        _mainView = ({
            UIScrollView *scr = [[UIScrollView alloc]initWithFrame:self.view.bounds];
            scr.delegate = self;
            scr.backgroundColor = CSBackgroundColor;
            scr.contentInset = UIEdgeInsetsMake(AboutUs_Interval/2, 0, AboutUs_Interval/2, 0);
            scr.contentSize = CGSizeMake(self.view.width, self.contentHeight);
            scr;
        });
    }
    return _mainView;
}
- (UIView*)mainInfoView
{
    if (!_mainInfoView) {
        NSString *mainInfo = [_message objectAtIndex:0];
        CGFloat height = [mainInfo sizeWithFont:[UIFont systemFontOfSize:12] inWidth:self.view.width - AboutUs_Interval*2].height;
        UIView *mainInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, height + AboutUs_HeadHeight)];
        mainInfoView.backgroundColor = CSWhiteColor;
        mainInfoView.layer.masksToBounds = YES;
        mainInfoView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        mainInfoView.layer.borderWidth = 0.5;
        
        
        NSMutableAttributedString *infoAttributeStr = [[NSMutableAttributedString alloc]initWithString:mainInfo];
        NSMutableParagraphStyle *infoParagraphStyle= [[NSMutableParagraphStyle alloc]init];
        infoParagraphStyle.alignment = NSTextAlignmentLeft;
        infoParagraphStyle.lineSpacing = 2;
        
        NSMutableParagraphStyle *titleParagraphStyle= [[NSMutableParagraphStyle alloc]init];
        titleParagraphStyle.alignment = NSTextAlignmentCenter;
        titleParagraphStyle.lineSpacing = 2;
        
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"默认头像"];
        attach.bounds = CGRectMake(0, -10, 60, 60);
        
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [infoAttributeStr insertAttributedString:imageStr atIndex:0];
        
        [infoAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(1, 2)];
        [infoAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(5, mainInfo.length - 5)];
        [infoAttributeStr addAttribute:NSForegroundColorAttributeName value:CSAppIconColor range:NSMakeRange(1, 2)];
        //图标和文字标题居中设置
        [infoAttributeStr addAttribute:NSParagraphStyleAttributeName value:titleParagraphStyle range:NSMakeRange(0, 3)];
        [infoAttributeStr addAttribute:NSParagraphStyleAttributeName value:infoParagraphStyle range:NSMakeRange(5, mainInfo.length - 5)];
        UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(AboutUs_Interval, 0, self.view.width - AboutUs_Interval*2, height + AboutUs_HeadHeight)];
        infoLab.numberOfLines = 0;
        infoLab.attributedText = infoAttributeStr;
        [mainInfoView addSubview:infoLab];
        _mainInfoView = mainInfoView;
    }
    return _mainInfoView;
}
- (UIView*)addressView
{
    if (!_addressView) {
        NSString *mainInfo = [_message objectAtIndex:1];
        CGFloat height = [mainInfo sizeWithFont:[UIFont systemFontOfSize:12] inWidth:self.view.width - AboutUs_Interval*2].height;
        
        UIView *mainInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mainInfoView.y + self.mainInfoView.height + AboutUs_Interval/2, self.view.width, height + 30)];
        mainInfoView.backgroundColor = CSWhiteColor;
        mainInfoView.layer.masksToBounds = YES;
        mainInfoView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        mainInfoView.layer.borderWidth = 0.5;
        
        
        NSMutableAttributedString *infoAttributeStr = [[NSMutableAttributedString alloc]initWithString:mainInfo];
        [infoAttributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 12)];
        [infoAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(12, mainInfo.length - 12)];
        
        UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(AboutUs_Interval, 0, self.view.width - AboutUs_Interval*2, height + 30)];
        infoLab.numberOfLines = 0;
        infoLab.attributedText = infoAttributeStr;
        [mainInfoView addSubview:infoLab];
        _addressView = mainInfoView;
    }

    return _addressView;
}
- (UIView*)versionView
{
    if (!_versionView) {
        UIView *mainInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.addressView.y + self.addressView.height + AboutUs_Interval/2, self.view.width, AboutUs_HeadHeight)];
        UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(AboutUs_Interval, (AboutUs_HeadHeight - 30)/2, self.view.width - AboutUs_Interval*2, 30)];
        infoLab.numberOfLines = 0;
        infoLab.textColor = [UIColor grayColor];
        infoLab.text = @"@1.3_20200910";
        infoLab.textAlignment = NSTextAlignmentCenter;
        [mainInfoView addSubview:infoLab];
        _versionView = mainInfoView;
    }
    return _versionView;
}
@end
