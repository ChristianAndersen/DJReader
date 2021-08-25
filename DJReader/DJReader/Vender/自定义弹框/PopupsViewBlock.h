//
//  PopupsView.h
//  Popups
//
//  Created by Arthur on 2018/5/30.
//  Copyright © 2018年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PopupsViewBlock : UIView
@property (nonatomic,copy)void(^completeHander)(NSString*title);
- (instancetype)initWithImage:(NSString *)imageName;
- (instancetype)initWithContentView:(UIView *)contentView;
- (instancetype)initCompleteHander:(void (^)(NSString*))hander;
- (void)showView;
- (void)dismissAlertView;
@end
