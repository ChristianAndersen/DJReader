//
//  SuspensionView.h
//  DJReader
//
//  Created by Andersen on 2020/9/23.
//  Copyright © 2020 Andersen. All rights reserved.
//  悬浮弹框视图

#import <UIKit/UIKit.h>
#import "DJCertificate.h"
NS_ASSUME_NONNULL_BEGIN
@class SuspensionView;
@class FileEditorController;
@class CSTabBarMainController;

@protocol SuspensionDelegate <NSObject>
- (void)suspension:(UIView*)suspention actionType:(BottomActionType)actionType parms:(NSDictionary*)parmas;
- (void)suspension:(UIView*)suspension selectedCertificate:(DJCertificate*)certificate;
@end

@interface SuspensionView : UIView
@property (nonatomic,assign)id <SuspensionDelegate>actionDelegate;
@property (nonatomic,weak)FileEditorController *parentController;
@property (nonatomic,weak)CSTabBarMainController *originController;
@end

NS_ASSUME_NONNULL_END
