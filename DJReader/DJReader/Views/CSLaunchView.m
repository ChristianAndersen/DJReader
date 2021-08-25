//
//  CSLaunchView.m
//  DJReader
//
//  Created by Andersen on 2020/7/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSLaunchView.h"
#import <libkern/OSAtomic.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import "BUAdSDK/BUSplashAdView.h"
#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUAdSlot.h>

#define fotterHeight 100
@interface CSLaunchView()<BUSplashAdDelegate,BUNativeExpressAdViewDelegate>
@property (strong, nonatomic) NSMutableArray<__kindof BUNativeExpressAdView *> *expressAdViews;
@property (strong, nonatomic) BUNativeExpressAdView *expressAdView;
@property (nonatomic,strong)UIImageView * LaunchView;
@property (nonatomic,strong)UIButton * skipButton;
@property (nonatomic,assign) CFTimeInterval startTime;
@property (nonatomic,strong) UIView *fotter;
@property (nonatomic,strong) BUNativeExpressAdManager *nativeExpressAdManager;
@property (nonatomic,strong) UIViewController *rootController;
@property (nonatomic,strong) UIView *loadView;
@property (nonatomic,copy)NSString *appID;
@end

@implementation CSLaunchView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (NSString*)appID
{
    return @"5084368";
}
- (void)layoutSubviews
{
    [self createFotterView];
}

- (void)showIn:(UIWindow*)keyWindow
{
    [BUAdSDKManager setAppID:self.appID];
    #if DEBUG
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
    #endif
        [BUAdSDKManager setIsPaidApp:NO];

    CGRect frame = [UIScreen mainScreen].bounds;
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height - fotterHeight);
    
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:@"887342951" frame:frame];
    splashView.tolerateTimeout = 5;
    splashView.delegate = self;

    self.startTime = CACurrentMediaTime();
    [splashView loadAdData];
    [self addSubview:splashView];
    [keyWindow.rootViewController.view addSubview:self];
    splashView.rootViewController = keyWindow.rootViewController;
}

- (void)showIn:(UIView *)view atRootController:(UIViewController*)controller
{
    [BUAdSDKManager setAppID:self.appID];
    #if DEBUG
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
    #endif
        [BUAdSDKManager setIsPaidApp:NO];

    self.loadView = view;
    self.rootController = controller;
    
    BUAdSlot *slot1 = [[BUAdSlot alloc] init];
    slot1.ID = @"946151412";
    slot1.AdType = BUAdSlotAdTypeFeed;
    BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot1.imgSize = imgSize;
    slot1.position = BUAdSlotPositionFeed;
    slot1.isSupportDeepLink = YES;
    
    if (!self.nativeExpressAdManager) {
        self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:CGSizeMake(view.width, view.height)];
    }
    self.nativeExpressAdManager.adSize = CGSizeMake(view.width, view.height);
    self.nativeExpressAdManager.delegate = self;
    [self.nativeExpressAdManager loadAd:1];
}

- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    [self.expressAdView removeFromSuperview];
    self.expressAdView = nil;
    _expressAdView = views.firstObject;
    _expressAdView.rootViewController = self.rootController;
    [_expressAdView render];
    [self.loadView addSubview:_expressAdView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewLoad:)]) {
        [self.delegate viewLoad:_expressAdView];
    }
}
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    //【重要】需要在点击叉以后 在这个回调中移除视图，否则，会出现用户点击叉无效的情况
}
- (void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView {
    //【重要】若开发者收到此回调，代表穿山甲会主动关闭掉广告，广告移除后需要开发者对界面进行适配
}
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView
{
}
- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {
}
- (void)createFotterView
{
    CGFloat headWidth = self.frame.size.width/9.0;
    self.fotter = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - fotterHeight, self.frame.size.width, fotterHeight)];
    UIImageView *fotterHeader = [[UIImageView alloc]initWithFrame:CGRectMake(headWidth*3, fotterHeight * 0.2, headWidth, headWidth)];
    fotterHeader.image = [UIImage imageNamed:@"AppIcon"];
    fotterHeader.layer.masksToBounds = YES;
    fotterHeader.layer.cornerRadius = 5;
    
    self.fotter.backgroundColor = [UIColor whiteColor];
    UILabel *chineseTitle = [[UILabel alloc]initWithFrame:CGRectMake(headWidth*4, fotterHeight*0.2, headWidth*2.3, headWidth*0.7)];
    chineseTitle.text = @"点聚OFD";
    chineseTitle.font = [UIFont systemFontOfSize:20.0];
    chineseTitle.textColor = [UIColor colorWithHexString:@"#A9A9A9"];
    chineseTitle.textAlignment = NSTextAlignmentCenter;
    UILabel *englishTitle = [[UILabel alloc]initWithFrame:CGRectMake(headWidth*4, fotterHeight*0.5, headWidth*2.3, headWidth*0.3)];
    englishTitle.text = @"DIAN JU OFD";
    englishTitle.font = [UIFont systemFontOfSize:13.0];
    englishTitle.textColor = [UIColor colorWithHexString:@"#DCDCDC"];
    englishTitle.textAlignment = NSTextAlignmentCenter;
    [self.fotter addSubview:fotterHeader];
    [self.fotter addSubview:chineseTitle];
    [self.fotter addSubview:englishTitle];
    [self addSubview:_fotter];
}
///穿山甲广告
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
    [self removeFromSuperview];
}
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [self removeFromSuperview];
    [splashAd removeFromSuperview];
}
- (void)removeADView
{
    [self.expressAdView removeFromSuperview];
    self.expressAdView = nil;
}
//自己的广告
- (void)loadLaunch:(UIView*)view
{
    float y = [UIScreen mainScreen].bounds.size.height/2;
    float x = [UIScreen mainScreen].bounds.size.width/2;
    
    //创建展示动画的imageView
    self.LaunchView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.LaunchView.center = CGPointMake(x, y);
    self.LaunchView.userInteractionEnabled = YES;
    self.LaunchView.image = [self launchImage];
    
    [view addSubview:self.LaunchView];
    [view bringSubviewToFront:self.LaunchView];
    
    self.skipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.skipButton.frame = CGRectMake(2*x - 80, 40, 70, 25);
    self.skipButton.layer.cornerRadius = 12.5;
    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.skipButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.skipButton.backgroundColor = [UIColor grayColor];
    [self.skipButton addTarget:self action:@selector(skipAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:self.skipButton];
    
    //跳过按钮的倒计时
    __block int32_t timeOutCount = timeIntence;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        OSAtomicDecrement32(&timeOutCount);
        if (timeOutCount == 0) {
            NSLog(@"timersource cancel");
            dispatch_source_cancel(timer);
        }
        [self.skipButton setTitle:[NSString stringWithFormat:@"%d 跳过",timeOutCount+1] forState:(UIControlStateNormal)];
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"timersource cancel handle block");
    });
    dispatch_resume(timer);
    //图片放大动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:timeIntence];
    
    self.LaunchView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5f, 1.5f);
    [UIView commitAnimations];
    //图片消失动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeIntence * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            self.LaunchView.alpha = 0;
            self.skipButton.alpha = 0;
        }];
    });
    //所有动画完成，删除图片和按钮
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timeIntence + 2.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.LaunchView removeFromSuperview];
        [self.skipButton removeFromSuperview];
    });
}

- (UIImage*)launchImage
{
    // 如果方法不存在直接返回
    if (![UIScreen instancesRespondToSelector:@selector(currentMode)]) return nil;
    CGSize viewSize = [UIScreen mainScreen].currentMode.size;//当前屏幕像素
    NSString *viewOrientation = @"Portrait";//竖屏
    //获取所有启动图信息
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {// 遍历的启动图信息
        if ([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            NSString *imageName = dict[@"UILaunchImageName"];// 获取图片名称
            UIImage *image = [UIImage imageNamed:imageName];// 生成图片
            CGFloat scale = image.scale;// 获取图片比例
            CGSize imageSize = CGSizeMake(image.size.width * scale, image.size.height * scale);// 获取图片真实像素
            // 对比图片像素与屏幕像素, 如果一致, 返回图片
            if (CGSizeEqualToSize(imageSize, viewSize)) {
                return image;
            }
        }
    }
    return nil;
}

//点击跳过按钮，删除图片和按钮
-(void)skipAction:(UIButton*)sender{
    [self.LaunchView removeFromSuperview];
    [self.skipButton removeFromSuperview];
}

@end
