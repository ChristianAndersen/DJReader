//
//  CSSnowIDFactory.h
//  DJReader
//
//  Created by Andersen on 2020/3/31.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSSnowIDFactory : NSObject
+ (CSSnowIDFactory*)shareFactory;
- (NSString*)getSnowFlakeID;
- (long)nextID;

+ (NSString*)getCurrentTimeDate;
+ (int64_t)getCurrentTimeDateIntValue;
+ (NSString *)randomKey;///获取一个随机数
+ (int64_t)getCurrentDateInterval;

@end

NS_ASSUME_NONNULL_END
