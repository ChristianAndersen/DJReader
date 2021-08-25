//
//  DJFileTableViewCell.h
//  文件操作
//
//  Created by liugang on 2020/3/17.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFloder.h"
#import "DJFileDocument.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJFileTableViewCell : UITableViewCell

//初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isOperational:(BOOL)operational;

//文件名数据
-(void)setDJFolderCellData:(DJFileDocument *)floderModel;

//点击回调
@property (nonatomic,copy) void(^fileExpandBtn)(UIButton *expandBtn);
@property (nonatomic,strong) UIButton * fileExpandButton;//文件扩展按钮

@end

NS_ASSUME_NONNULL_END
