//
//  PersonalDataViewController.h
//  DJReader
//
//  Created by liugang on 2020/5/14.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTabBarMainController.h"

@interface PersonalDataViewController : UIViewController
@property (nonatomic,weak)CSTabBarMainController* originController;
@property (nonatomic,copy)void (^loginOut)(void);
@end



