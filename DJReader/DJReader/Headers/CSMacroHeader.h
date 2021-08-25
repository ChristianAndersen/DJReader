//
//  CSMacroHeader.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/28.
//  Copyright © 2019 Andersen. All rights reserved.
//

#ifndef CSMacroHeader_h
#define CSMacroHeader_h


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

#define ControllerDefalutColor [UIColor colorWithRed:87/255.0 green:131/255.0 blue:246/255.0 alpha:1.0]

#define CSBackgroundColor [UIColor drakColor:[UIColor colorWithWhite:0.2 alpha:1.0] lightColor:[UIColor colorWithWhite:0.96 alpha:1.0]]
#define CSTextColor [UIColor drakColor:[UIColor colorWithWhite:0.98 alpha:1.0] lightColor:[UIColor colorWithWhite:0.2 alpha:1.0]]

#define DateFormatter @"yyyy-MM-dd HH:mm:ss"
#define DEFAULTUSER_NAME @"DJReader_admin"
#define DEFAULTUSER_ACOUNT @"DefaultAccount"
#define DEFAULTUSER_PWD @"00000000"
#define DEFAULTUSER_ID 10000001
#define DEFAULTBROWSE_FLODER_ID 20000001
#define DEFAULTLOCA_FLODER_ID 20000002
#define DEFAULTME_FLODER_ID 20000003
#define DEFAULTBROWSE_FLODER_NAME @"最近浏览"
#define DEFAULTLOCA_FLODER_NAME @"本地文件"
#define DEFAULTME_FLODER_NAME @"收藏"
///文件编辑导航栏
#define TextTipStr @"请输入文字"
#define Action_PaiBan @"排版"
#define Action_LuRu @"录入"
#define Action_Undo @"撤销"
#define Action_Star @"标星"
#define Action_Hand @"手写"
#define Action_Exit @"退出状态"
#define Action_Back @"返回"
#define Action_Share @"分享"
#define Action_Save @"保存"
#define Action_ImportImage @"导出图片"
#define Action_Option_images @"逐页输出图片"
#define AcTion_Option_longImage @"输出为长图片"

#define Action_ShareFriend @"邀请好友"
#define Action_ShareForum @"分享到朋友圈"

#define ProgramSection_imageOperation @"图片处理"
#define ProgramName_imagesConvertPDF @"图片转PDF"
#define ProgramName_imagesConvertOFD @"图片转OFD"
#define ProgramName_images @"逐页输出图片"
#define ProgramName_longImage @"输出为长图片"

#define ProgramSection_PDFOperation @"PDF处理"
#define ProgramName_PDFMerge @"PDF合并"
#define ProgramName_PDFConvertOFD @"PDF转OFD"
#define ProgramName_WordConvertPDF @"Word转PDF"
#define ProgramName_PDFPageManager @"PDF页面管理"
#define ProgramName_PDFConvertWord @"PDF转Word"
#define ProgramName_HTMLConvertPDF @"html转PDF"


#define ProgramSection_OFDOperation @"OFD处理"
#define ProgramName_OFDConvertPDF @"OFD转PDF"
#define ProgramName_WordConvertOFD @"Word转OFD"
#define ProgramName_OFDPageManager @"OFD页面管理"
#define ProgramName_OFDMerge @"OFD合并"
#define ProgramName_OFDConvertWord @"OFD转Word"


#define ProgramSection_AIPOperation @"AIP处理"
#define ProgramName_AIPConvertPDF @"AIP转PDF"
#define ProgramName_AIPConvertOFD @"AIP转OFD"



#define DJReadUser_DIRECTORY @"用户"
#define DJReadFloder_DIRECTORY @"OFD文件夹"
#define DJReadSeal_DIRECTORY @"印章文件夹"
#define DJReadDatabase_DIRECTORY @"DJReadDatabase"
#define DJReadFloder_DISPLAY @"display"

#define ProgramName_ShareFile @"分享"

#define RefreshUserData @"RefreshUserData"
#define ChangeUserNotifitionName @"ChangeUserNotifitionName"
#define timeIntence 3.0//Launch图片放大的时间


///钥匙串键值对
#define KEYCHAIN_USERINFO @"com.dianju.OFD.currnetAppleUserInfo"
#define KEYCHAIN_USERID @"com.dianju.OFD.userID"
#define KEYCHAIN_USERID @"com.dianju.OFD.userID"
#define KEYCHAIN_USERNAME @"com.dianju.OFD.userName"
#define KEYCHAIN_EMAIL @"com.dianju.OFD.email"
#define KEYCHAIN_AUTHORIZATIONCODE @"com.dianju.OFD.authorizationCode"
#define KEYCHAIN_IDENTITYTOKEN @"com.dianju.OFD.identityToken"
#define KEYCHAIN_FIRSTLOGIN @"com.dianju.OFD.firstLogin"


///微信第三方
#define WeChat_APPID @"wxd60e5a883ae5d4fc"
#define WeChat_AppSecret @"8217269e8be086e071dcaea9cdf07db0"
#define UTLSFileOpenNotificationName @"UTLSFileOpenNotificationName"

#define OLD_OFDLICFILE @"vFFcR3Vl7wJp5xM9qypF4TyyH+w8vm9m"
#define NEW_OFDLICFILE @"XSLSjA36jgtp5xM9qypF4SXqM0KOksF5z9FE+IsRZzo="

#define AIPFileExt @"aip"
#define PDFFileExt @"pdf"
#define OFDFileExt @"ofd"

#define CSIconWidth 20
#endif /* CSMacroHeader_h */
