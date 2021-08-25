//
//  NSObject+bitMap.h
//  DJContents
//
//  Created by dianju on 2018/9/28.
//  Copyright © 2018年 dianju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define OMDateFormat @"yyyy-MM-dd'T'HH:mm:ss.SSS"
#define OMTimeZone @"UTC"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (bitMap)
+(id)objectOfClass:(NSString *)object fromJSON:(NSDictionary *)dict;
+(id)objectOfClass:(NSString *)object fromArray:(NSArray *)array;

-(NSDictionary *)propertyDictionary;//遍历父系的类到NSObject为止
-(NSDictionary *)selfPropertyDictionary;
-(NSMutableArray*)propertyKeys;

@end

NS_ASSUME_NONNULL_END
