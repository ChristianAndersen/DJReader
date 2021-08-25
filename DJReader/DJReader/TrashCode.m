//
//  TrashCode.m
//  DJReader
//
//  Created by Andersen on 2020/8/26.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "TrashCode.h"

@implementation TrashCode
//订阅支付->SubscribeController
//- (void)completeTransaction:(SKPaymentTransaction*)transaction
//{
//    [self hiddenHUD];
//    //验证凭据
//    NSURL *receiptURL = [[NSBundle mainBundle]appStoreReceiptURL];
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//
//    NSString *str = [[NSString alloc]initWithData:receiptData encoding:NSUTF8StringEncoding];
//    NSString *environment = [self environmentForReceipt:str];
//    NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@", environment);
//
//    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}",encodeStr];
//    NSURL *storeURL = nil;
//    if ([environment isEqualToString:@"environment=Sandbox"]) {///沙盒环境
//        storeURL = [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
//    }else{
//        storeURL = [[NSURL alloc]initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];//生产环境
//    }
//    NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
//    NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:storeURL];
//    [connectionRequest setHTTPMethod:@"POST"];
//    [connectionRequest setTimeoutInterval:50.0];
//    [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
//    [connectionRequest setHTTPBody:postData];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionTask *task = [session dataTaskWithRequest:connectionRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!error) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"请求成功后的数据:%@", dic);
//                //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
//                //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//                NSString *product = transaction.payment.productIdentifier;
//                NSLog(@"transaction.payment.productIdentifier++++%@", product);
//                if ([product length] > 0) {
//                    NSArray *tt = [product componentsSeparatedByString:@"."];
//                    NSString *bookid = [tt lastObject];
//                    if([bookid length] > 0) {
//                        [DJReadNetShare openVIP:^(DJService *service) {///发放虚拟物品
//                            showAlert(@"发放虚拟物品", self);
//                            NSDictionary *responseObject = service.dataResult;
//                            int code = [[responseObject objectForKey:@"code"]intValue];
//                            if (code == 0) {
//                                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//                            }else{
//                                ShowMessage(nil, @"物品发放失败，下次购买时，重新发放", RootController);
//                            }
//                        }];
//                    }
//                }
//            }else{
//                showAlert(error.localizedDescription, self)
//            }
//        });
//    }];
//  [task resume];
    //    NSError *error;
    //    NSData *responseData = [NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:&error];
    //    if (error) {
    //        NSLog(@"验证购买过程中发生错误，错误信息：%@", error.localizedDescription);
    //        return;
    //    }
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"请求成功后的数据:%@", dic);
    //    //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
    //    //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    //    NSString *product = transaction.payment.productIdentifier;
    //    NSLog(@"transaction.payment.productIdentifier++++%@", product);
    //    if ([product length] > 0) {
    //        NSArray *tt = [product componentsSeparatedByString:@"."];
    //        NSString *bookid = [tt lastObject];
    //        if([bookid length] > 0) {
    //            [DJReadNetShare openVIP:^(DJService *service) {///发放虚拟物品
    //                showAlert(@"发放虚拟物品", self);
    //            }];
    //        }
    //    }
    // 此方法为将这一次操作上传给我本地服务器,记得在上传成功过后一定要记得销毁本次操作。调用[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//}
@end
