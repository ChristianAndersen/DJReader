//
//  FileSelectCell.h
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"
NS_ASSUME_NONNULL_BEGIN

@interface FileSelectCell : UITableViewCell
@property (nonatomic,strong) UIImageView *fileImageView;//文件夹图标
@property (nonatomic,strong) UILabel *selectLabel;
@property (nonatomic,strong) UILabel *fileNameLabel;//文件名称
@property (nonatomic,strong) UILabel *fileCreationTimeLabel;//创建时间
@property (nonatomic,strong) UILabel *fileSizeLabel;//文件大小

@property (nonatomic,assign) BOOL isMultiSelect;//是否是多选cell
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,strong) DJFileDocument *model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isOperational:(BOOL)operational;
- (void)setModel:(DJFileDocument*)model;
- (void)setSelectedNum:(NSString*)num;
@end

NS_ASSUME_NONNULL_END
