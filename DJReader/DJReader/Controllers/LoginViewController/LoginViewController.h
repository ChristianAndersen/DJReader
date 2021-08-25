//
//  LoginViewController.h
//  DJReader
//
//  Created by liugang on 2020/4/30.
//  Copyright © 2020 Andersen. All rights reserved.
//  审核时登录页面

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "CSTabBarMainController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseController
@property (nonatomic,weak)CSTabBarMainController* originController;
@end

NS_ASSUME_NONNULL_END
