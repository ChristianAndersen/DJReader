//
//  CSKeyChain.m
//  DJReader
//
//  Created by Andersen on 2020/7/23.
//  Copyright © 2020 Andersen. All rights reserved.
//
static NSString * const KEY_ALLINFO = @"com.dianju.OFD.Info";//所有信息
#import "CSKeyChain.h"

@implementation CSKeyChain
///以每个apple id 返回的唯一号作为标识
+ (void)saveMsg:(NSString*)msg forKey:(NSString*)key
{
    NSMutableDictionary *keyChainQuery = [self getKeyChainQuery:KEYCHAIN_USERINFO];
    NSMutableDictionary *keyChainInfo = [self getKeyDictionary:KEYCHAIN_USERINFO];
    SecItemDelete((CFDictionaryRef)keyChainQuery);
    
    [keyChainInfo setObject:msg forKey:key];
    [keyChainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:keyChainInfo] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keyChainQuery, NULL);
}

+ (NSString*)objectForKey:(NSString*)key withID:(NSString*)appleUserID
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyDictionary:appleUserID
                                          ];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_ALLINFO, e);
        } @finally {
        }
    }
    NSString *value;
    if ([ret isKindOfClass:[NSDictionary class]]) {
        NSDictionary * KeyDic = (NSDictionary *)ret;
        value = [KeyDic objectForKey:key];
    }
    return value;
}
+ (NSDictionary*)appleUserInfo
{
    return [self getKeyDictionary:KEYCHAIN_USERINFO];
}
+ (NSMutableDictionary*)getKeyChainQuery:(NSString*)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,service,(__bridge_transfer id)kSecAttrService,service, (__bridge_transfer id)kSecAttrAccount,(__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,nil];
}

+ (NSMutableDictionary *)getKeyDictionary:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keyChainQuery = [self getKeyChainQuery:key];
    [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keyChainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_ALLINFO, e);
        } @finally {
        }
    }
    if ([ret isKindOfClass:[NSDictionary class]]) {
        return ret;
    }else{
        return [[NSMutableDictionary alloc]init];
    }
}
@end
