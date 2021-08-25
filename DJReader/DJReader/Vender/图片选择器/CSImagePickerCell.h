//
//  CSImagePickerCell.h
//  DJReader
//
//  Created by Andersen on 2021/1/6.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSImagePickerModel.h"
#import "CSImagePickerBtn.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CSImagePickerCellAction) (void);
@interface CSImagePickerCell : UICollectionViewCell
/// 行数
@property (nonatomic, assign)NSInteger row;
@property (nonatomic, strong)CSImagePickerModel *model;
@property (nonatomic, strong)CSImagePickerBtn *selectButton;
@property (nonatomic, copy)  CSImagePickerCellAction action;

@property (nonatomic, strong)UILabel *num;
@property (nonatomic, strong)UIImageView *imageView;
/// 是否被选中
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
