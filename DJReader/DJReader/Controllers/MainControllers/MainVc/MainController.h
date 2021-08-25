//
//  FirstController.h
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "BaseController.h"
#import "CSTabBarMainController.h"
NS_ASSUME_NONNULL_BEGIN

#define ScrollWebViewHeight 200

@interface MainController : BaseController
@property (nonatomic,weak)CSTabBarMainController* originController;
@end

NS_ASSUME_NONNULL_END
