//
//  SmallProgramSearchCell.h
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallProgramModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramSearchCell : UITableViewCell
@property (nonatomic,strong)SmallProgramModel *model;
@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)UIView * headBackView;

@property (nonatomic,strong)UILabel *title;
@end

NS_ASSUME_NONNULL_END
