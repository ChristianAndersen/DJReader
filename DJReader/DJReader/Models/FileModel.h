//
//  FileModel.h
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileModel : NSObject

/**
 文件名
 */
@property (nonatomic,strong) NSString *fileName;

/**
 文件版本号
 */
@property (nonatomic,strong) NSString *fileVersionNumber;

/**
 文件大小
 */
@property (nonatomic,strong) NSString *fileSize;

/**
 文件创建时间
 */
@property (nonatomic,strong) NSString *fileCreationTime;

/**
 文件修改时间
 */
@property (nonatomic,strong) NSString *fileModificationTime;



@end

NS_ASSUME_NONNULL_END
