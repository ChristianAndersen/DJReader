//
//  SmallProgramIconView.h
//  DJReader
//
//  Created by Andersen on 2021/3/10.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallProgramModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramIconView : UICollectionViewCell
@property (nonatomic,strong)UIView * headBackView;
@property (nonatomic,strong)UIImageView * headView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)SmallProgramModel *model;
@end

NS_ASSUME_NONNULL_END
