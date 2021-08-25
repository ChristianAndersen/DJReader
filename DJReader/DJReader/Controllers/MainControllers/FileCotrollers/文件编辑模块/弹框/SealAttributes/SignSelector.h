//
//  SignSelector.h
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SealUnit.h"
#import "DJProtocolManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignSelector : UIView
@property (nonatomic,strong)id <SignSelectorDelegate> selectorDelegate;
@property (nonatomic,strong)NSIndexPath *curIndexPath;

- (void)reloadSignSelector;
@end

NS_ASSUME_NONNULL_END
