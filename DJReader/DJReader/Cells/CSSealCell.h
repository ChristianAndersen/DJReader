//
//  CSSealCell.h
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSignSeal.h"
NS_ASSUME_NONNULL_BEGIN

@interface CSSealCell : UICollectionViewCell
@property (nonatomic,strong)DJSignSeal *unit;
- (void)cellSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
