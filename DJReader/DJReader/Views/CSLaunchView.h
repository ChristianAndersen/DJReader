//
//  CSLaunchView.h
//  DJReader
//
//  Created by Andersen on 2020/7/8.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CSLaunchDelegate <NSObject>

-(void)viewLoad:(UIView*)view;

@end
@interface CSLaunchView : UIView
@property (nonatomic,weak)id<CSLaunchDelegate>delegate;
- (void)showIn:(UIWindow*)keyWindow;
- (void)showIn:(UIView *)view atRootController:(UIViewController*)controller;
- (void)removeADView;
@end

NS_ASSUME_NONNULL_END
