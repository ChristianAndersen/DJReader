//
//  CSColorCell.h
//  DJReader
//
//  Created by Andersen on 2020/3/21.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorUnit.h"
NS_ASSUME_NONNULL_BEGIN

@interface CSColorCell : UICollectionViewCell
@property (nonatomic,strong)ColorUnit *unit;
- (void)setItemSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
