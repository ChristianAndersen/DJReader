//  CSMethodMacroHead.h
//  DJReader
//  Created by Andersen on 2020/3/6.
//  Copyright © 2020 Andersen. All rights reserved.

#ifndef CSMethodMacroHead_h
#define CSMethodMacroHead_h

//App版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_Xs IS_IPHONE_X
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)
//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define k_Height_NavContentBar 44.0f
#define k_StatusBar_Height (IS_PhoneXAll? 44.0 : 20.0)
#define k_NavBar_Height (IS_PhoneXAll ? 88.0 : 64.0)
#define k_TabBar_Height (IS_PhoneXAll ? 83.0 : 49.0)

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kFrame_width self.view.frame.size.width
#define kFrame_height self.view.frame.size.height
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define DrakModeColor RGBACOLOR(40,40,40,1)
#define LightModeColor [UIColor colorWithWhite:0.9 alpha:1.0]
#define CSAppIconColor [UIColor colorWithRed:64/255.0 green:149/255.0 blue:231/255.0 alpha:1.0]
#define ControllerDefalutColor [UIColor colorWithRed:87/255.0 green:131/255.0 blue:246/255.0 alpha:1.0]
#define CSBackgroundColor [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:[UIColor colorWithWhite:1.0 alpha:1.0]]
#define CSSystemBackgroundColor [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:[UIColor systemBackgroundColor]]
#define CSWhiteBackgroundColor [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:[UIColor colorWithWhite:1.0 alpha:1.0]]
#define CSSeparatorColor [UIColor drakColor:[UIColor colorWithWhite:0.3 alpha:1.0] lightColor:[UIColor colorWithWhite:0.9 alpha:1.0]]
#define CSTextColor [UIColor drakColor:[UIColor colorWithWhite:0.98 alpha:1.0] lightColor:[UIColor colorWithWhite:0.2 alpha:1.0]]
#define CSWhiteColor [UIColor drakColor:[UIColor colorWithWhite:0.1 alpha:1.0] lightColor:[UIColor colorWithWhite:1.0 alpha:1.0]]
#define NavColor RGBACOLOR(28, 95, 168, 1)

//对字符串base64编码
#define STRING_TO_BASE64( text ) [ADSFunc stringToBase64String:text]
//base64字符串解码
#define BASE64_TO_TEXT( base64 ) [ADSFunc base64StringToString:base64]
//对Url特殊字符转码
#define ENCODE_URL( text ) [ADSFunc encodeWithUrl:text]
//对Url特殊字符解码
#define DECODE_URL( base64 ) [ADSFunc decodeFromPercentEscapeString:base64]
//GBK编码
#define GBKENCODE( data ) [ADSFunc encodeByGBKWithData:data]
//获取时间戳
#define GetTimesTemp [ADSFunc getTimeDate]
//判断当前时间点是否在一个时段内
#define IS_BetweenTime(fromYear,fromMonth,fromDay,toYear,toMonth,toDay) [ADSFunc isBetweenFromYear:fromYear FromMonth:fromMonth formDay:fromDay toYear:toYear toMonth:toMonth toDay:toDay]

//根据颜色画图片
#define ImageWithColor(color) [ADSFunc imageWithColor:color]
#define ImageWithColorAndRadius(color,frame,radius)     [ADSFunc imageWithColor:color andFrame:frame andConnerRadius:radius]
#define ImageWithLabel(label) [ADSFunc layerToImage:label]
#define RGBAColor(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define TitleFont(Font)[UIFont systemFontOfSize:(Font)]
#define WeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define ShowMessage(TITLE,MESSAGE,QUVC) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];[QUVC presentViewController:alertController animated:YES completion:nil];
#define showAlert(MESSAGE,QUVC) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[QUVC presentViewController:alertController animated:YES  completion:nil];});dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[alertController dismissViewControllerAnimated:YES completion:nil];});

#define RootController [UIApplication sharedApplication].windows[0].rootViewController
#define RootWindow [UIApplication sharedApplication].windows[0]

#define GotoMainRootController AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate gotoMainRootController];

#define GotoLoginControllerFrom(QUVC) AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate gotoLoginControllerFrom:QUVC];
#define GotoBindPhoneControllerFrom(QUVC) AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate gotoBindPhoneControllerFrom:QUVC];
#define GotoSubcribeControllerFrom(QUVC) AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate gotoSubcribeControllerFrom:QUVC];
#define launchProgram(programName,sectionName) AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate launchingProgram:programName programSection:sectionName];
#define SetRootController(QUVC) AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate setRootController:QUVC];


#ifdef DEBUG
#define DebugLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DebugLog(...);
#endif

#ifdef DEBUG
#define Log(fmt, ...) NSLog((@"\n""[函数名:%s]\n" fmt),  __FUNCTION__,  ##__VA_ARGS__);
#else
#define Log(...);
#endif

#endif /* CSMethodMacroHead_h */
