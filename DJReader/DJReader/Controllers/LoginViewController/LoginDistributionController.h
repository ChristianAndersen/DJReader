//
//  LoginDistributionController.h
//  DJReader
//
//  Created by Andersen on 2020/9/8.
//  Copyright © 2020 Andersen. All rights reserved.
//  审核通过后登录页面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CSTabBarMainController;
@interface LoginDistributionController : UIViewController
@property (nonatomic,weak)CSTabBarMainController* originController;

@end

NS_ASSUME_NONNULL_END
