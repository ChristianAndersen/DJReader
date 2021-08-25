//
//  SealUnit.h
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SealUnit : NSObject
@property (nonatomic,assign)int64_t id;
@property (nonatomic,assign)int64_t uid;
@property (nonatomic,assign)int64_t type;
@property (nonatomic,assign)int64_t create_time;
@property (nonatomic,assign)int64_t update_time;
@property (nonatomic,assign)int64_t version;

@property (nonatomic,strong)NSData*data;
@property (nonatomic,copy)NSString*source;
@property (nonatomic,copy)NSString*name;
@end

NS_ASSUME_NONNULL_END
