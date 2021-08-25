//
//  DJNetworkTool.h
//  DJReader
//
//  Created by liugang on 2020/4/28.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
/// 快速初始化
#define DJReadNetShare [DJReadNetManager sharedTool]
@class DJService;
/// 网络状态类型
typedef enum : NSUInteger {
    DJNetworkStatusNotReachable = 0,
    DJNetworkStatusWiFi = 1,
    DJNetworkStatus4G = 2,
    DJNetworkStatus3G = 3,
    DJNetworkStatus2G = 4
} DJNetworkStatus;
/// 网络请求类型
typedef enum : NSUInteger {
    DJNetPOST = 0,///POST请求
    DJNetGET = 1///GET请求
} DJNetType;

/** 请求结果 */
typedef void(^DJReponseResult)(DJService *service);
@interface DJReadNetManager : AFHTTPSessionManager
/// 网络状态
@property (nonatomic,assign,readonly) DJNetworkStatus status;
/// 网络工具类全局访问点
+(instancetype)sharedTool;
/// 网络请求方法
/// @param type 网络请求类型
/// @param urlString 网络请求路径
/// @param parameters 请求的参数
/// @param reponseResult 请求结果回调
-(void)requestAFN:(DJNetType)type
                  urlString:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
              reponseResult:(DJReponseResult)reponseResult;
-(void)requestAFN:(DJNetType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters showError:(BOOL)show reponseResult:(DJReponseResult)reponseResult;
///原生请求
- (void)requestJSON:(DJNetType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters reponseResult:(DJReponseResult)reponseResult;
///请求用户信息
- (void)requestUserInfo:(NSString *)phone andOpenid:(NSString*)openid complete:(void (^)(DJReadUser*user))hander;
///开通VIP
- (void)openWithParam:(NSMutableDictionary*)params complete:(void(^)(DJService *service))hander;
- (void)openVIP:(void(^)(DJService *service))hander;
///删除印章
- (void)deleteSeal:(NSString*)sealID complete:(void(^)(DJService *service))hander;
/// 转换文件
/// @param filePath 需要转换的文件
/// @param returnType 要转成的文件格式,支持pdf,ofd
/// @param hander 回调
- (void)convertFile:(NSString*)filePath returnType:(NSString*)returnType complete:(void(^)(NSString*errMsg,NSString *fileBase64))hander;
- (void)convertFile:(NSString*)filePath returnType:(NSString*)returnType shouldJudge:(BOOL)should complete:(void(^)(NSString*errMsg,NSString *fileBase64))hander
;
@end
#pragma mark =======================网络请求状态======================
///service 状态
typedef NS_ENUM(NSUInteger, DJServiceState)
{
    DJServiceStateNone                 = (0),  //没有进行访问
    DJServiceStateWorking              = (1),  //正在进行网络访问
    DJServiceStateComplete             = (2),  //完成访问，并且解析成功
    DJServiceStateTimeoutError         = (3),  //访问超时
    DJServiceStateDataFormatError      = (4),  //数据格式错误，无效数据
    DJServiceStateNetworkError         = (5),  //网络错误
    DJServiceStateServerError          = (6),  //服务器错误
    DJServiceStateUnkownError          = (7)   //未知一切错误
};

@interface DJService : NSObject
@property (nonatomic,assign) DJServiceState serviceState;
@property (nonatomic,strong) NSString *serviceMessage;
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) id dataResult;
@end
