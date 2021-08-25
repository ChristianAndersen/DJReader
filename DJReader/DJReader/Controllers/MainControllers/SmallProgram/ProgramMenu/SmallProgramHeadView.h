//
//  SmallProgramHeadView.h
//  DJReader
//
//  Created by Andersen on 2021/3/11.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramHeadView : UICollectionReusableView
@property (nonatomic,copy)NSString *sectionName;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *moreSender;
@property (nonatomic,strong)void(^moreHander)(NSString*title);
@end

NS_ASSUME_NONNULL_END
