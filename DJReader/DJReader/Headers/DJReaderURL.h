//
//  DJReaderURL.h
//  DJReader
//
//  Created by Andersen on 2020/6/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#ifndef DJReaderURL_h
#define DJReaderURL_h
#define AdminManager @"400800888888"
#define AdminVerifyCode @"110120"
#define ItunesURL @"https://itunes.apple.com/us/app/1517200440"
#define ShareInvitaitionURL @"http://ofd365.dianju.cn/sso/dianju/html/index.html?tcode=%@"

#define DJReader_BaseURL                        @"http://ofd365.dianju.cn"//地址
//#ifdef DEBUG
//#define DJReader_BaseURL                        @"http://47.105.164.141:8081"//地址
//#else
//#define DJReader_BaseURL                        @"http://ofd365.dianju.cn"//地址
//#endif

//POST
#define DJReader_verifyCode                     @"/sso/register/getVerifyCode"// 获取验证码
#define DJReader_Register                       @"/sso/register/registerUser"//注册
#define DJReader_Login                          @"/sso/login/login"//登录
#define DJReader_PostUserInfo                   @"/sso/user/operationalData"//上传用户所有信息
#define DJReader_LoginWechat                    @"/sso/login/wechatlogin"//微信登录
#define DJReader_PhoneBind                      @"/sso/user/phonenumBind"//手机号绑定
#define DJReader_VIPOpen                        @"/sso/user/openVip"//开通VIP
#define DJReader_CERTApply                      @"/sso/cert/apply"//证书申请
#define DJReader_CERTQuery                      @"/sso/cert/query"//证书查询
#define DJReader_CERTSign                       @"/sso/cert/sign"//证书签名
#define DJReader_CERTVerify                     @"/sso/cert/sign"//证书验签
#define DJReader_Appversion                     @"/sso/app/version"//版本信息管理
#define DJReader_GetUserInfo                    @"/sso/user/getUserInfo"//获取用户信息
#define DJReader_Feedback                       @"/sso/app/problem/feedback"//问题反馈
#define DJReader_VIPInfo                        @"/sso/user/getVipInfo"//获取VIP信息
#define DJReader_CeateSeal                      @"/sso/seal/create"//创建印章
#define DJReader_QuerySeal                      @"/sso/seal/query"//查询印章
#define DJReader_DeleteSeal                     @"/sso/seal/delete"//删除印章
#define DJReader_DeleteCert                     @"/sso/cert/revoke"//删除证书
#define DJReader_ConvertFile                    @"/sso/app/file"//转换文件
#define DJReader_GETConfig                      @"/sso/app/getConfig"//获取配置
#define DJReader_SETConfig                      @"/sso/app/setConfig"//设置配置
#define DJReader_DelConfig                      @"/sso/app/delConfig"//删除配置
#define DJReader_htmlConvertPdf                 @"/sso/app/html2pdf"//被邀请用户向服务端报道
#endif /* DJReaderURL_h */
