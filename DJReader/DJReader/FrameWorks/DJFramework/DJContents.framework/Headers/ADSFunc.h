//
//  ADSFunc.h
//  DJSIGN
//
//  Created by dianju on 15/11/19.
//  Copyright (c) 2015年 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"
#import <UIKit/UIKit.h>

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

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]


@interface ADSFunc : NSObject

+ (NSString *)stringToBase64String:(NSString *)text;
+ (NSString *)base64StringToString:(NSString *)base64;

+ (NSString *)encodeWithUrl:(NSString *)url;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) encodeStr;

//NSStringEncoding中没有的编码
+ (NSString *)encodeByGBKWithData:(NSData*)data;
+ (NSString *)encodeGBKWithString:(NSString*)string;
//获得时间戳
+ (NSString *)getTimeDate;
//判断当前时间点是否在一个指定的时间内
- (BOOL)isBetweenFromYear:(NSInteger)fromYear FromMonth:(NSInteger)fromMonth formDay:(NSInteger)fromDay toYear:(NSInteger)toYear toMonth:(NSInteger)toMonth toDay:(NSInteger)toDay;
+ (NSString *)md5:(NSString *)str;

+ (NSData   *)AESEncryptData:(NSData*)contentData withKey:(NSData*)keyData;
+ (NSData   *)AESDecryptData:(NSData*)contentData withKey:(NSData*)keyData;

+ (UIImage  *)imageWithColor:(UIColor *)color;
+ (UIImage  *)imageWithColor:(UIColor *)color andFrame:(CGRect)rect andConnerRadius:(double)radius;
+ (UIImage  *)layerToImage:(UILabel*)label;
@end

