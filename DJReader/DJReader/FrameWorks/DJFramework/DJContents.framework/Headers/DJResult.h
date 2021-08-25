//
//  DJResult.h
//  DJContentsExample
//
//  Created by dianju on 16/7/13.
//  Copyright © 2016年 dianju. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DJRESULT_TYPE_SEALPLATFORM                      1002 //印章平台
#define DJRESULT_TYPE_DJSEAL                            1001 //无纸化
#define DJRESULT_TYPE_VERIFYPLATFORM                    1003 //印章平台


#define DJRESULT_SEAL_SAVE @"DJRESULT_ULAN_DOCUMENTSAVE"         //文件保存
#define SAVE_SUCESSFUL                                  0x100050 //保存成功
#define SAVE_FAILED                                     0x100051 //保存失败

#define DJRESULT_SEAL_INIT @"DJRESULT_FILE_INIT"
#define FILE_OPENFILE_ERROR                             0x100041 //文件未打开
#define FILE_LOGIN_ERROR                                0x100042 //用户登入错误
#define FILE_VERIFYLIC_ERROR                            0x100043 //用户授权验证错误
#define FILE_CACHEVERIFYLIC_ERROR                       0x100044 //本地缓存授权文件失效

#define DJRESULT_VERIFY @"DJRESULT_VERIFY"                       //授权平台问题
#define FILE_GETVERIFYLIC_ERROR                         0x200045 //授权平台获取的授权码错误
#define FILE_GETSEALLIST                                0x200046 //授权平台获取印章列表失败
#define FILE_SIGNBYSERVER_NOTVERIFY                     0x200047 //授权平台无可用授权文件
#define FILE_SIGNBYSERVER_MSGERROR                      0x200047 //授权平台返回信息有误
#define FILE_SIGNBYSERVER_SUCESSFUL                     0x200049 //授权平台数据签名成功
#define FILE_GETVERIFYLIC_SUCESSFUL                     0x20005A //授权平台获取授权文件成功验证成功
#define FILE_GETVERIFYLIC_MSGCHANGE                     0x20005A //授权平台数据被篡改

#define FILE_CONNECT_ERROR                              0x200051 //授权平台获取的授权码错误
#define FILE_REQUESTVERIFYLIC_ERROR                     0x200052 //授权平台获取授权文件错误

#define DJRESULT_SEAL @"DJRESULT_SEAL"//印章平台问题
#define FILE_GETSEALDATA                                0x300050 //授权平台获取印章数据失败
#define FILE_GETSEALDATA_SUCESSFUL                      0x300049 //授权平台获取印章数据成功



#define DJRESULT_SEAL_CONNECT @"DJRESULT_SEAL_CONNECT"//授权平台问题



#define CRASHERROR                                     -888888//crash
#define OTHERERROR                                     -999999//其他错误

//userInfo键值对键字段
//信息描述
#define ResultMessage @"resultMessage"
//文件路径
#define ResultFilePath @"filePath"

@interface DJResult : NSObject
//返回结果码
@property (nonatomic,assign)    NSInteger resultCode;
//返回结果域
@property (nonatomic,copy)      NSString *domain;
//返回结果信息
@property (nonatomic,strong)    NSDictionary *userInfo;
@property (nonatomic,assign)    int type;

-(NSString*)messageStr;
-(NSString*)filePath;
@end


