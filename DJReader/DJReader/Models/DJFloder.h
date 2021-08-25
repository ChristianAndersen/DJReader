//
//  DJFloder.h
//  DJReader
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface DJFloder : NSObject
@property (nonatomic,strong) NSMutableArray * files;
@property (nonatomic,assign) int64_t id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL status;
@end

NS_ASSUME_NONNULL_END
