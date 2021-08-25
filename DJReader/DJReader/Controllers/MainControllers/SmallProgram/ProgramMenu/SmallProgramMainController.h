//
//  SmallProgramMainController.h
//  DJReader
//
//  Created by Andersen on 2021/3/10.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTabBarMainController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramMainController : UIViewController
@property (nonatomic,weak)CSTabBarMainController* originController;
@end

NS_ASSUME_NONNULL_END
