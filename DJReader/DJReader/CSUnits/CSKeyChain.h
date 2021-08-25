//
//  CSKeyChain.h
//  DJReader
//
//  Created by Andersen on 2020/7/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSKeyChain : NSObject
+ (void)saveMsg:(NSString*)msg forKey:(NSString*)key;
+ (NSString*)objectForKey:(NSString*)key;
+ (NSDictionary*)appleUserInfo;
@end

NS_ASSUME_NONNULL_END
