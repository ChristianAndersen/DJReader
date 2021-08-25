//
//  NSString+Methods.m
//  DJReader
//
//  Created by Andersen on 2020/3/9.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "NSString+Methods.h"
#import "DJReadNetManager.h"
@implementation NSString (Methods)

#pragma mark -
+ (NSString*)stringFromIndexPath:(NSIndexPath*)indexPath{
    return [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
}
#pragma mark -
+ (NSIndexPath*)indexPathFromString:(NSString*)string{
    NSArray* array = [string componentsSeparatedByString:@","];
    
    return [NSIndexPath indexPathForRow:((NSString*)[array objectAtIndex:1]).intValue inSection:((NSString*)[array objectAtIndex:0]).intValue];
}

#pragma mark - 时间戳转换
+ (NSString *)getDateStringWithTimeStr:(int64_t )str{
    NSString *string = [NSString stringWithFormat:@"%lld",str];
    NSTimeInterval time = [string doubleValue]/1000;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (long)getDateNumWithDateStr:(NSString*)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    NSTimeInterval interval = date.timeIntervalSince1970 * 1000;
    return interval;
}
#pragma mark - 文件大小格式转换
+ (NSString *)getDataLengthWithLengStr:(int64_t)leng{
    NSByteCountFormatter *format = [[NSByteCountFormatter alloc] init];
    if(leng<1024){
        format.allowedUnits = NSByteCountFormatterUseBytes;
    }else if (leng<1024*1024) {
        format.allowedUnits = NSByteCountFormatterUseKB;
    }else if (leng<1024*1024*1024) {
        format.allowedUnits = NSByteCountFormatterUseMB;
    }else{
        format.allowedUnits = NSByteCountFormatterUseGB;
    }
    //1024字节为1KB
    format.countStyle = NSByteCountFormatterCountStyleBinary;
    // 输出结果显示单位
    format.includesUnit =  YES;
    // 输出结果显示数据
    format.includesCount = YES;
    //是否显示完整的字节
    format.includesActualByteCount = NO;
    NSString *str = [format stringFromByteCount:leng];
    return str;
}


#pragma mark - 字典转json格式字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSDictionary*)toJsonDictionary:(NSDictionary*)dic
{
    NSString *json = [self dictionaryToJson:dic];
    return [self parseJSONStringToNSDictionary:json];
}
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
#pragma mark - 判断字符串是否手机号
- (BOOL)isPhone{
    NSString *pattern = @"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    return [self isTextWithPattern:pattern];
}
- (BOOL)isTextWithPattern:(NSString *)pattern{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [predicate evaluateWithObject:self];
}
#pragma mark - 判断字符串是否是URL
- (BOOL)isURL{
    if(self == nil) return NO;
    NSString*dUrl = [self stringByRemovingPercentEncoding];
    NSString *url;
    
    if (dUrl.length>4 && [[dUrl substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",dUrl];
    }else{
        url = dUrl;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}
#pragma mark - 判断字符串是合法邮箱地址
- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isIDCard {
    if (self.length != 18) return NO;
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    NSInteger idCardWiSum = 0;
    
    for(int i = 0; i<17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    NSInteger idCardMod=idCardWiSum % 11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) return NO;
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) return NO;
    }
    return YES;
}
+ (NSString*)dataToBase64:(NSData*)data
{
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64;
}
+ (NSData*)base64ToData:(NSString*)base64
{
    NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return base64Data;
}
- (CGSize)sizeWithFont:(UIFont*)font inWidth:(CGFloat)width
{
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 1;
    
    NSDictionary*attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize sz = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return sz;
}
+ (NSString*)getCurrentTimeDate
{
    NSDate *  senddate=[NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
   
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
//比较日期大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame){
        aa = 0;//相等
    }else if (result==NSOrderedAscending) {
        aa = 1;//bDate比aDate大
    }else if (result==NSOrderedDescending) {
        aa = -1;//bDate比aDate小
    }
    return aa;
}
@end
