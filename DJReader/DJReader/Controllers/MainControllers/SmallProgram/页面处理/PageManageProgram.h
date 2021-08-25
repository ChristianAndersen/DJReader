//
//  PageManageProgram.h
//  DJReader
//
//  Created by Andersen on 2021/6/3.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileProgram.h"
#import "DJFileDocument.h"
NS_ASSUME_NONNULL_BEGIN

@interface PageManageProgram : FileProgram
@property (nonatomic,strong)DJFileDocument *fileModel;
@end

NS_ASSUME_NONNULL_END
