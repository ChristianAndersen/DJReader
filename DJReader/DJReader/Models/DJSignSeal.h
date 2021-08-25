//
//  DJSignSeal.h
//  DJReader
//
//  Created by Andersen on 2020/9/24.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJSignSeal : NSObject
@property (nonatomic,copy)NSString *status,*dataStatus,*sealId,*userId,*sealType,*createTime,*updateTime,*keyWords;
@property (nonatomic,copy)NSString *sealHeight,*sealWidth,*sealName;
@property (nonatomic,copy)NSString *imgPreview,*sealData;

@property (nonatomic,strong)UIImage *sealImage;
@property (nonatomic,strong)NSString *path;
@end

NS_ASSUME_NONNULL_END
