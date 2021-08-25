//
//  DJReadUser.h
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPreference.h"
NS_ASSUME_NONNULL_BEGIN

@interface DJReadUser : NSObject
@property (nonatomic,assign)int64_t id;
@property (nonatomic,assign)BOOL status;
@property (nonatomic,assign)int isvip;
@property (nonatomic,strong)UserPreference *preference;
@property (nonatomic,strong)NSMutableDictionary *vipInfo;
@property (nonatomic,copy) NSString *nickname,*account,*password,*name,*avatar,*openid,*uphone,*firsttime,*lasttime;

@end

NS_ASSUME_NONNULL_END
