//
//  CSAppPayManager.m
//  DJReader
//
//  Created by Andersen on 2020/7/28.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSAppPayManager.h"
#import <StoreKit/StoreKit.h>
@interface CSAppPayManager()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic,strong)NSArray *products;
@property (nonatomic,assign)BOOL isObserver;
@end

@implementation CSAppPayManager
//- (void)productsInfo
//{
//    if ([SKPaymentQueue canMakePayments]) {
//        NSSet *IDSet = [NSSet setWithArray:@[@""]];
//        SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:IDSet];
//        productsRequest.delegate = self;
//        [productsRequest start];
//    }else{
//        showAlert(@"用户禁止付费", RootController);
//    }
//}
//- (void)verifyPruchaseWithID:(NSString*)productID
//{
//
//}
//
//- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
//    NSLog(@"%lu", (unsigned long)response.products.count);
//    NSArray *myProducts = response.products;
//    if (myProducts.count == 0) {
//        showAlert(@"无法获取产品信息列表", RootController);
//    }else{
//        self.products = [myProducts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            SKProduct *product1 = (SKProduct*)obj1;
//            SKProduct *product2 = (SKProduct*)obj2;
//            return product1.price.integerValue < product2.price.integerValue ? NSOrderedAscending : NSOrderedDescending;
//        }];
//        for (SKProduct *product in myProducts) {
//            NSLog(@"%@", [product localizedTitle]);
//            NSLog(@"%@", [product localizedDescription]);
//            NSLog(@"%@", [product price]);
//            NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol]);
//            NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
//            NSLog(@"%@", [product productIdentifier]);
//        }
//    }
//}
//- (void)startObserver
//{
//    if (self.isObserver) {
//        [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
//        self.isObserver = NO;
//    }
//}
//- (void)stopObserver
//{
//    if (self.isObserver) {
//        [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
//        self.isObserver = NO;
//    }
//}
//- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
//    SKPaymentTransaction *transaction = transactions.lastObject;
//    switch (transaction.transactionState) {
//        case SKPaymentTransactionStatePurchased:{///购买完成
//            NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle]appStoreReceiptURL] path]];
//            NSString *receipt = [data base64EncodedDataWithOptions:0];
//        }break;
//        case SKPaymentTransactionStateFailed:{//交易失败
//
//        }break;
//        case SKPaymentTransactionStateRestored:{///已购买过自己商品
//
//        }break;
//        case SKPaymentTransactionStatePurchasing:{///商品添加进列表
//
//        }break;
//        default:{
//
//        }break;
//    }
//}
//- (void)finshPay
//{
//    [[SKPaymentQueue defaultQueue]finishTransaction:nil];
//}


//- (void)requestProductData:(NSString*)type
//{
//    NSArray *product = [[NSArray alloc]initWithObjects:type, nil];
//    NSSet *set = [NSSet setWithArray:product];
//    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
//    request.delegate = self;
//    [request start];
//}
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//    NSLog(@"------------------------------收到产品反馈消息---------------------------------");
//    NSArray *products = response.products;
//    NSLog(@"productID:%@",response.invalidProductIdentifiers);
//    if (products.count == 0) {
//        return;///查找不到商品信息
//    }
//    SKProduct *myProduct = nil;
//    for (SKProduct *product in products) {
//        NSLog(@"%@", [product localizedTitle]);
//        NSLog(@"%@", [product localizedDescription]);
//        NSLog(@"%@", [product price]);
//        NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol]);
//        NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
//        NSLog(@"%@", [product productIdentifier]);
//        if ([product.productIdentifier isEqualToString:@""]) {
//            myProduct = product;
//        }
//        SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
//        NSLog(@"发送购买请求");
//        [[SKPaymentQueue defaultQueue]addPayment:payment];
//    }
//}
/////请求失败
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"支付失败\r\n");
//}
//- (void)requestDidFinish:(SKRequest *)request
//{
//    NSLog(@"请求结束\r\n");
//}
//- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
//    SKPaymentTransaction *transaction = transactions.lastObject;
//    switch (transaction.transactionState) {
//        case SKPaymentTransactionStatePurchased:{///购买完成
//            NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle]appStoreReceiptURL] path]];
//            NSString *receipt = [data base64EncodedStringWithOptions:0];
//        }break;
//        case SKPaymentTransactionStateFailed:{//交易失败
//
//        }break;
//        case SKPaymentTransactionStateRestored:{///已购买过自己商品
//
//        }break;
//        case SKPaymentTransactionStatePurchasing:{///商品添加进列表
//
//        }break;
//        default:{
//
//        }break;
//    }
//}
////从沙盒中获取交易凭证并且拼接成请求体数据
//- (void)verifyPurchaseWithPaymentTransaction:(NSNumber*)resultState
//{
//    NSURL *receiptUrl = [[NSBundle mainBundle]appStoreReceiptURL];
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
//}

///判断是否具备支付权限
//- (BOOL)canMakePayments
//{
//    if ([SKPaymentQueue canMakePayments]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//- (void)createProductRequest:(NSArray*)productIdentifiers
//{
//    NSSet *set = [NSSet setWithArray:productIdentifiers];
//    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
//    request.delegate = self;
//    [request start];
//}
/////查询结果将通过SKProductsRequestDelegate得到
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//    NSLog(@"%lu", (unsigned long)response.products.count);
//    NSArray *myProducts = response.products;
//    if (myProducts.count == 0) {
//        showAlert(@"无法获取产品信息列表", RootController);
//    }else{
//        self.products = [myProducts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            SKProduct *product1 = (SKProduct*)obj1;
//            SKProduct *product2 = (SKProduct*)obj2;
//            return product1.price.integerValue < product2.price.integerValue ? NSOrderedAscending : NSOrderedDescending;
//        }];
//        for (SKProduct *product in myProducts) {
//            NSLog(@"%@", [product localizedTitle]);
//            NSLog(@"%@", [product localizedDescription]);
//            NSLog(@"%@", [product price]);
//            NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol]);
//            NSLog(@"%@", [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
//            NSLog(@"%@", [product productIdentifier]);
//        }
//    }
//}
/////获取请求完成和失败的结果
//- (void)requestDidFinish:(SKRequest *)request
//{
//}
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
//{
//}
/////创建支付
//- (void)createPayment:(SKProduct*)product
//{
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
//    [[SKPaymentQueue defaultQueue]addPayment:payment];
//}
/////添加支付交易的Observer
//- (void)addObserver
//{
//    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
//}
//- (void)removeObserver
//{
//    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
//}
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
//{
//    SKPaymentTransaction *transaction = [transactions lastObject];
//    switch (transaction.transactionState) {
//        case SKPaymentTransactionStatePurchased:
//            [self completeTransaction:transaction];
//            break;
//        case SKPaymentTransactionStateFailed:
//            [self failedTransaction:transaction];
//            break;
//        case SKPaymentTransactionStateRestored:
//            [self restoreTransaction:transaction];
//            break;
//        case SKPaymentTransactionStatePurchasing:
//            NSLog(@"商品添加进列表");
//            break;
//        default:
//            break;
//    }
//}
//- (void)completeTransaction:(SKPaymentTransaction*)transaction
//{
//
//}
//- (void)failedTransaction:(SKPaymentTransaction*)transaction
//{
//
//}
//- (void)restoreTransaction:(SKPaymentTransaction*)transaction
//{
//
//}
//
/////App Store验证
/////1:获取票据
//- (NSString*)iapReceipt
//{
//    NSString *receiptString = nil;
//    NSURL *receiptURL = [[NSBundle mainBundle]appStoreReceiptURL];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]]) {
//        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//        receiptString = [receiptData base64EncodedStringWithOptions:0];
//    }
//    return receiptString;
//}
/////2:如果此时未获取到票据的信息，使用SKReceiptRefreshRequest来刷新票据结果
//- (void)refreshReceipt
//{
//    SKReceiptRefreshRequest *refreshReceiptRequest = [[SKReceiptRefreshRequest alloc]initWithReceiptProperties:@{}];
//    refreshReceiptRequest.delegate = self;
//    [refreshReceiptRequest start];
//}
/////由于审核时，审核人员为沙盒状态，注意状态码“21007”
//- (void)verifyRequestData:(NSString*)base64Data url:(NSString*)url transaction:(SKPaymentTransaction*)transaction success:(void (^)(void))successBlock failure:(void (^)(NSError*error))failureBlock
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:base64Data forKey:@"receipt-data"];
//    [params setValue:@"shareSecreKey" forKey:@"password"];
//
//    NSError *jsonError;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&jsonError];
//    if (jsonError) {
//        NSLog(@"verifyRequestData failed: error = %@",jsonError);
//    }
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    request.HTTPBody = jsonData;
//    request.HTTPMethod = @"POST";
//    __weak typeof (self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSError *error;
//        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!data) {
//                return;///失败
//            }
//            NSError *jsonError;
//            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//            if (!responseJSON) {
//                if (failureBlock != nil) {
//                    failureBlock(jsonError);
//                }
//            }
//            static NSString *statusKey = @"status";
//            NSInteger statusCode = [responseJSON[statusKey] integerValue];
//            static NSInteger successCode = 0;
//            static NSInteger sandboxCode = 21007;
//            if (statusCode == successCode) {
//                ///成功
//            }else if (statusCode == sandboxCode){
//                ///沙盒数据
//            }else{
//                ///失败
//            }
//        });
//    });
//}







- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}
@end
