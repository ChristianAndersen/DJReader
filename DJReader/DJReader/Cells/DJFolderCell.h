//
//  DJFolderCell.h
//  文件操作
//
//  Created by liugang on 2020/3/12.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFloder.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJFolderCell : UITableViewCell

/// 文件名数据
-(void)setDJFolderCellData:(DJFloder *)folderModel;

/// 点击回调
@property (nonatomic,copy) void(^folderOperation)(void);


@end

NS_ASSUME_NONNULL_END
