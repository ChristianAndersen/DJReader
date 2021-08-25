//
//  DJFileDocument.h
//  DJReader
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DJFileDocument : NSObject
@property (nonatomic,copy)NSString *name,*sourceName,*filePath;
@property (nonatomic,copy)NSString *fileExt;
@property (nonatomic,copy)NSMutableArray *superFloders;
@property (nonatomic,assign)BOOL star;
@property (readwrite,nonatomic, strong) NSDictionary *propertyArrayMap;
@property (nonatomic,assign)int64_t id,length,modificationDate,last_read_position,last_open_time,create_time,status;
@end

NS_ASSUME_NONNULL_END
