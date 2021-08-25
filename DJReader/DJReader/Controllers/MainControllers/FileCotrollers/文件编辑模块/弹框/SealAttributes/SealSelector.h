//
//  SealSelector.h
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJProtocolManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SealSelector : UIView
@property (nonatomic,strong)id <SignSelectorDelegate> selectorDelegate;
@end

NS_ASSUME_NONNULL_END
