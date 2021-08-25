//
//  DJReadUser.m
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJReadUser.h"

@implementation DJReadUser
- (NSString*)firsttime
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:_firsttime];
    NSTimeInterval timeStamp= [inputDate timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld",(long long)timeStamp];
}
- (UserPreference*)preference
{
    if (!_preference) {
        _preference = [[UserPreference alloc]init];
    }
    return _preference;
}
- (NSString*)avatar
{
    if (_avatar.length <= 10) {
        _avatar = @"";
    }
    return _avatar;
}
- (NSString*)uphone
{
    if (_uphone.length <= 10) {
        _uphone = @"";
    }
    return _uphone;
}
- (NSString*)openid
{
    if (_openid.length <= 10) {
        _openid = @"";
    }
    return _openid;
}
@end
