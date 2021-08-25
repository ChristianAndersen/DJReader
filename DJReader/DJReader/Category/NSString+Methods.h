//
//  NSString+Methods.h
//  DJReader
//
//  Created by Andersen on 2020/3/9.
//  Copyright © 2020 Andersen. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Methods)

+ (NSString*)stringFromIndexPath:(NSIndexPath*)indexPath;
+ (NSIndexPath*)indexPathFromString:(NSString*)string;
///时间戳转时间
+ (NSString *)getDateStringWithTimeStr:(int64_t )str;
/// 字节转KB/M
+ (NSString *)getDataLengthWithLengStr:(int64_t)leng;
/// 字典转json格式字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary*)toJsonDictionary:(NSDictionary*)dic;

///判断字符串是否手机号
- (BOOL)isPhone;
///判断是否是URL
- (BOOL)isURL;
///判断字符串是合法邮箱地址
- (BOOL)isEmail;
///判断是否是身份证
- (BOOL)isIDCard;
+ (NSString*)dataToBase64:(NSData*)data;
+ (NSString*)getCurrentTimeDate;
+ (NSData*)base64ToData:(NSString*)base64;
- (CGSize)sizeWithFont:(UIFont*)font inWidth:(CGFloat)width;


@end

NS_ASSUME_NONNULL_END
