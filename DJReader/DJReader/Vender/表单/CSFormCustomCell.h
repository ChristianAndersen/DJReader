//
//  CSFormCustomCell.h
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"
NS_ASSUME_NONNULL_BEGIN
@interface CSFormCustomModel : CSFormModel
@property (nonatomic,strong)UIView *content;
@end

@interface CSFormCustomCell : CSFormCell
@end

NS_ASSUME_NONNULL_END
