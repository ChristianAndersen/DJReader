//
//  DJNetworkTool.m
//  DJReader
//
//  Created by liugang on 2020/4/28.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJReadNetManager.h"
#import "NSString+Methods.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <MJExtension.h>
#import "DJFileManager.h"
@class DJService;
/// 网络监控管理者
//@property (nonatomic,strong)  AFNetworkReachabilityManager *manger;
@implementation DJReadNetManager
#pragma mark - 初始化类方法
+(instancetype)sharedTool{
    static DJReadNetManager *instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
        //设置请求的时间
        [instace.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        instace.requestSerializer.timeoutInterval = 60.f;
        [instace.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        instace.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //打开状态栏的等待菊花
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        //设置返回数据类型为json类型
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        //去掉键值对里空键值
        response.removesKeysWithNullValues = YES;
        instace.responseSerializer = response;
        /** 设置请求服务器类型为json类型
         "系统异常：Content type 'application/x-www-form-urlencoded;charset=UTF-8' not supported"
          AFHTTPRequestSerializer 换 AFJSONRequestSerializer
         */
        AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
        //AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
        instace.requestSerializer = request;
        instace.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    });
    return instace;
}
#pragma mark - 网络请求方法
-(void)requestAFN:(DJNetType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters reponseResult:(DJReponseResult)reponseResult{
    [self requestAFN:type urlString:urlString parameters:parameters showError:YES reponseResult:reponseResult];
}
-(void)requestAFN:(DJNetType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters showError:(BOOL)show reponseResult:(DJReponseResult)reponseResult{
    if (urlString == nil)
        return;
    //处理url中包含中文
    urlString = [NSURL URLWithString:urlString]?urlString:[self stringEncodingWithSting:urlString];
    DJService *service = [DJService new];
    urlString = [NSString stringWithFormat:@"%@%@",DJReader_BaseURL ,urlString];
    /** 判断type类型 */
    if (type == DJNetPOST) {
        [self POST:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            service.serviceState = DJServiceStateWorking;
            service.dataResult = nil;
            //reponseResult(service);///进行中
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            /** 完成访问并解析数据成功 */
            int code = [[responseObject objectForKey:@"code"]intValue];
            service.code = code;
            service.serviceState = DJServiceStateComplete;
            service.serviceMessage = [responseObject objectForKey:@"msg"];
            service.dataResult = [responseObject objectForKey:@"data"];
            if (code != 0 && show) {
                @try {
                    NSString *errMsg = [NSString stringWithFormat:@"数据通信出错\r\n错误代码：%d\r\n错误信息：%@",code,[responseObject objectForKey:@"msg"]];
                    ShowMessage(@"提示", errMsg, RootController);
                } @catch (NSException *exception) {
                    ShowMessage(@"提示", @"出现异常数据", RootController);
                } @finally {
                }
                reponseResult(service);
            }else{
              reponseResult(service);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            service.dataResult = nil;
            if (error.code == NSURLErrorNotConnectedToInternet){
                //网络错误
                service.serviceState = DJServiceStateNetworkError;
                service.serviceMessage = @"网络无法连接";
                service.code = error.code;
                reponseResult(service);
            }else if (error.code == NSURLErrorTimedOut){
                //连接超时
                service.serviceState = DJServiceStateTimeoutError;
                service.serviceMessage = @"连接超时，请稍后重试！";
                service.code = error.code;
                reponseResult(service);
            }else if (error.code == NSURLErrorCannotDecodeRawData || error.code == NSURLErrorCannotDecodeContentData || error.code == NSURLErrorDataLengthExceedsMaximum){
                // 数据格式错误，无效数据
                service.serviceState = DJServiceStateDataFormatError;
                service.serviceMessage = [error localizedDescription];
                service.code = error.code;
                reponseResult(service);
            }else if (error.code == NSURLErrorBadServerResponse || error.code == NSURLErrorServerCertificateHasBadDate || error.code == NSURLErrorServerCertificateUntrusted || error.code == NSURLErrorServerCertificateHasUnknownRoot || error.code == NSURLErrorServerCertificateNotYetValid){
                // 服务器错误
                service.serviceState = DJServiceStateServerError;
                service.serviceMessage = [error localizedDescription];
                service.code = error.code;
                reponseResult(service);
            }else{
                //未知错误
                service.serviceState = DJServiceStateUnkownError;
                service.serviceMessage = [error localizedDescription];
                service.code = error.code;
                reponseResult(service);
            }
            service.dataResult = nil;
            if (show) {
                NSString *errMsg = [NSString stringWithFormat:@"请求出错%ld\r\n%@",(long)error.code,error.userInfo];
                ShowMessage(@"网络请求错误", errMsg, RootController);
            }
        }];
    }else if (type == DJNetGET){
        [self GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
             service.serviceState = DJServiceStateWorking;
             service.dataResult = nil;
             reponseResult(service);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //完成访问并解析数据成功
             service.serviceState = DJServiceStateComplete;
             service.dataResult = responseObject;
             reponseResult(service);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {//失败回调
           service.dataResult = nil;
           if (error.code == NSURLErrorNotConnectedToInternet){
               //网络错误
               service.serviceState = DJServiceStateNetworkError;
               service.serviceMessage = @"网络无法连接";
               service.code = error.code;
               reponseResult(service);
           }else if (error.code == NSURLErrorTimedOut){
               //连接超时
               service.serviceState = DJServiceStateTimeoutError;
               service.serviceMessage = @"连接超时，请稍后重试！";
               service.code = error.code;
               reponseResult(service);
           }else if (error.code == NSURLErrorCannotDecodeRawData || error.code == NSURLErrorCannotDecodeContentData || error.code == NSURLErrorDataLengthExceedsMaximum){
               // 数据格式错误，无效数据
               service.serviceState = DJServiceStateDataFormatError;
               service.serviceMessage = [error localizedDescription];
               service.code = error.code;
               reponseResult(service);
           }else if (error.code == NSURLErrorBadServerResponse || error.code == NSURLErrorServerCertificateHasBadDate || error.code == NSURLErrorServerCertificateUntrusted || error.code == NSURLErrorServerCertificateHasUnknownRoot || error.code == NSURLErrorServerCertificateNotYetValid){
               // 服务器错误
               service.serviceState = DJServiceStateServerError;
               service.serviceMessage = [error localizedDescription];
               service.code = error.code;
               reponseResult(service);
           }else{
               //未知错误
               service.serviceState = DJServiceStateUnkownError;
               service.serviceMessage = [error localizedDescription];
               service.code = error.code;
               reponseResult(service);
           }
        }];
    }
}
- (void)requestUserInfo:(NSString *)phone andOpenid:(NSString*)openid complete:(void (^)(DJReadUser*user))hander;{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (phone.length == 11)
        [params setValue:phone forKey:@"phonenum"];
    if (openid.length > 0)
        [params setValue:openid forKey:@"openid"];
    if (!params.allValues)
        return;
    
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_GetUserInfo parameters:params reponseResult:^(DJService *service) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = service.code;
            if (code == 0) {
                NSDictionary *userInfo = service.dataResult;
                [DJReadUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                        @"status":@"status",
                        @"account":@"u_account",
                        @"name":@"u_name",
                        @"nickname":@"u_nickname",
                        @"avatar":@"avatar",
                        @"openid":@"u_openid",
                        @"uphone":@"u_phone",
                        @"isvip":@"u_isvip",
                    };
                }];
                DJReadUser *loginUser = [DJReadUser mj_objectWithKeyValues:userInfo];
                NSLog(@"%@",loginUser.firsttime);
                if (hander) hander(loginUser);
            }
        });
    }];
}
- (void)openWithParam:(NSMutableDictionary*)params complete:(void(^)(DJService *service))hander
{
    NSString* phonenum = [DJReadManager shareManager].loginUser.uphone;
    [params setValue:phonenum forKey:@"phonenum"];
    [self requestAFN:DJNetPOST urlString:DJReader_VIPOpen parameters:params showError:NO reponseResult:hander];
}
-(void)openVIP:(void(^)(DJService *service))hander
{
    NSString* phonenum = [DJReadManager shareManager].loginUser.uphone;
    if (phonenum.length != 11) {
        ShowMessage(@"提示", @"手机号有误", RootController);
        return;
    }
    NSDictionary *params = @{
        @"phonenum":phonenum,
        @"viptype":@"1",
    };
    [self requestAFN:DJNetPOST urlString:DJReader_VIPOpen parameters:params reponseResult:hander];
}
- (void)deleteSeal:(NSString*)sealID complete:(void(^)(DJService *service))hander
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *openid = [DJReadManager shareManager].loginUser.openid;
    NSString *mobile = [DJReadManager shareManager].loginUser.uphone;
    [params setValue:openid forKey:@"openId"];
    [params setValue:sealID forKey:@"sealId"];
    [params setValue:mobile forKey:@"mobile"];
    [self requestAFN:DJNetPOST urlString:DJReader_DeleteSeal parameters:params reponseResult:hander];
}
- (void)convertFile:(NSString*)filePath returnType:(NSString*)returnType shouldJudge:(BOOL)should complete:(void(^)(NSString*errMsg,NSString *fileBase64))hander
{
    if (should) {
        [self convertFile:filePath returnType:returnType complete:hander];
    }else{
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSString * sourceBase64 = [fileData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString * extension = [filePath pathExtension];
        NSDictionary *param = @{
            @"fileType":extension,
            @"fileBase64":sourceBase64,
            @"returnType":returnType,
        };
        [self requestAFN:DJNetPOST urlString:DJReader_ConvertFile parameters:param showError:NO reponseResult:^(DJService *service) {
            NSInteger code = service.code;
            NSDictionary *dataResult = service.dataResult;
            if (code == 0) {
                NSString *fileBase64 = [dataResult objectForKey:@"base64"];
                if (hander)  hander(nil,fileBase64);
            }else{
                NSString *errMsg = service.serviceMessage;
                if (hander) hander(errMsg,nil);
            }
        }];
    }
}
- (void)convert:(NSString*)file returnExt:(NSString*)ext complete:(void (^)(NSString * msg,NSString* fileBase64))hander
{
    NSString *sourceExt = file.pathExtension;
    NSString *returnExt = ext;
    NSData *fileData = [[NSData alloc]initWithContentsOfFile:file];
    NSString *sourceBase64 = [fileData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *parm = @{
        @"fileType":sourceExt,
        @"fileBase64":sourceBase64,
        @"returnType":returnExt,
    };
    [self requestAFN:DJNetPOST urlString:DJReader_ConvertFile parameters:parm showError:NO reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        NSDictionary *dataResult = service.dataResult;
        if (code == 0) {
            NSString *fileBase64 = [dataResult objectForKey:@"base64"];
            if (hander)  hander(nil,fileBase64);
        }else{
            NSString *errMsg = service.serviceMessage;
            if (hander) hander(errMsg,nil);
        }
    }];
}
- (void)convertFile:(NSString*)filePath returnType:(NSString*)returnType complete:(void(^)(NSString*errMsg,NSString *fileBase64))hander
{
    [DJFileManager judgeFile:filePath support:^{
        if (hander) hander(@"文件格式不需要转换",nil);
    } unSupport:^{
        [self convert:filePath returnExt:returnType complete:hander];
    } unKnown:^{
        if (hander) hander(@"文件格式不支持转换",nil);
    }];
}

- (void)requestJSON:(DJNetType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters reponseResult:(DJReponseResult)reponseResult
{
    if (urlString == nil)
        return;
    urlString = [NSURL URLWithString:urlString]?urlString:[self stringEncodingWithSting:urlString];
    DJService *service = [DJService new];
    urlString = [NSString stringWithFormat:@"%@%@",DJReader_BaseURL ,urlString];
    
    switch (type) {
        case DJNetGET:{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            request.HTTPMethod = @"POST";
            request.timeoutInterval = 30;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

            NSURLSession*session = [NSURLSession sharedSession];
            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    //完成访问并解析数据成功
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    service.serviceState = DJServiceStateComplete;
                    service.dataResult = response;
                    reponseResult(service);
                }else{
                    service.dataResult = nil;
                    if (error.code == NSURLErrorNotConnectedToInternet){
                        //网络错误
                        service.serviceState = DJServiceStateNetworkError;
                        service.serviceMessage = @"网络无法连接";
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorTimedOut){
                        //连接超时
                        service.serviceState = DJServiceStateTimeoutError;
                        service.serviceMessage = @"连接超时，请稍后重试！";
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorCannotDecodeRawData || error.code == NSURLErrorCannotDecodeContentData || error.code == NSURLErrorDataLengthExceedsMaximum){
                        // 数据格式错误，无效数据
                        service.serviceState = DJServiceStateDataFormatError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorBadServerResponse || error.code == NSURLErrorServerCertificateHasBadDate || error.code == NSURLErrorServerCertificateUntrusted || error.code == NSURLErrorServerCertificateHasUnknownRoot || error.code == NSURLErrorServerCertificateNotYetValid){
                        // 服务器错误
                        service.serviceState = DJServiceStateServerError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else{
                        //未知错误
                        service.serviceState = DJServiceStateUnkownError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }
                }
            }];
            [task resume];
        }break;
        case DJNetPOST:{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                request.HTTPBody = [[DJReadNetManager getJsonWith:parameters] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            request.HTTPMethod = @"POST";
            request.timeoutInterval = 30;
            [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

            NSURLSession*session = [NSURLSession sharedSession];
            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    service.serviceState = DJServiceStateComplete;
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    service.dataResult = response;
                    reponseResult(service);
                    if (reponseResult) reponseResult(service);
                }else{
                    service.dataResult = nil;
                    /** 失败回调 */
                    //NSLog(@"错误信息为%@",error);
                    if (error.code == NSURLErrorNotConnectedToInternet){
                        /** 网络错误 */
                        service.serviceState = DJServiceStateNetworkError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorTimedOut){
                        /** 连接超时 */
                        service.serviceState = DJServiceStateTimeoutError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorCannotDecodeRawData || error.code == NSURLErrorCannotDecodeContentData || error.code == NSURLErrorDataLengthExceedsMaximum){
                        /** 数据格式错误，无效数据 */
                        service.serviceState = DJServiceStateDataFormatError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else if (error.code == NSURLErrorBadServerResponse || error.code == NSURLErrorServerCertificateHasBadDate || error.code == NSURLErrorServerCertificateUntrusted || error.code == NSURLErrorServerCertificateHasUnknownRoot || error.code == NSURLErrorServerCertificateNotYetValid){
                        /** 服务器错误 */
                        service.serviceState = DJServiceStateServerError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }else{
                        /** 未知错误 */
                        service.serviceState = DJServiceStateUnkownError;
                        service.serviceMessage = [error localizedDescription];
                        service.code = error.code;
                        reponseResult(service);
                    }
                }
            }];
            [task resume];
        }break;
        default:
            break;
    }
}
#pragma mark - 中文字符串格式转换
-(NSString *)stringEncodingWithSting:(NSString *)string{
     return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
+ (NSString*)getJsonWith:(NSDictionary*)dic
{
    NSString *json = nil;
    if ([NSJSONSerialization isValidJSONObject:dic]) {
       NSError *error;
       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
       if(!error) {
           json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       }else {
           NSLog(@"JSON parse error: %@", error);
       }
    }else {
        NSLog(@"Not a valid JSON object: %@", dic);
    }
    return json;
}
@end

@implementation DJService
@end
