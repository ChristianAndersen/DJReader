//
//  FileModel.m
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (NSString *)fileVersionNumber{
    return [NSString stringWithFormat:@"版本号:%@",self.fileVersionNumber];
}

- (NSString *)fileCreationTime{
    return [NSString stringWithFormat:@"创建时间:%@",self.fileCreationTime];
}

- (NSString *)fileModificationTime{
    return [NSString stringWithFormat:@"修改时间:%@",self.fileCreationTime];
}
@end
