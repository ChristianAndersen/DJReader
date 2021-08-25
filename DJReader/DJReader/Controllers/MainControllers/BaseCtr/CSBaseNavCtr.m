//
//  CSBaseNavCtr.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSBaseNavCtr.h"

@interface CSBaseNavCtr ()

@end

@implementation CSBaseNavCtr

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return [self.visibleViewController preferredStatusBarStyle];
}
-(BOOL)prefersStatusBarHidden{
    return [self.visibleViewController prefersStatusBarHidden];
}
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    
    self.hidesBottomBarWhenPushed = NO;
    return [super popToRootViewControllerAnimated:animated];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if (self.viewControllers.count == 2) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return [super popViewControllerAnimated:animated];
}

@end
