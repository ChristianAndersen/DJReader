//
//  CSSignCell.h
//  DJReader
//
//  Created by Andersen on 2020/3/24.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSignSeal.h"
NS_ASSUME_NONNULL_BEGIN

@interface CSSignCell : UITableViewCell
@property (nonatomic,strong)DJSignSeal *unit;
- (void)cellSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
