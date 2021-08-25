//
//  SignManagerController.h
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJProtocolManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SignManagerController : UIViewController
@property (nonatomic,strong)id <SignSelectorDelegate> selectorDelegate;
@property (nonatomic,strong)NSIndexPath *curIndexPath;
- (void)addSignImage:(UIImage*)signImage;
@end

NS_ASSUME_NONNULL_END
