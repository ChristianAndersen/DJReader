//
//  CSSheetManager.h
//  ZmjPickView
//
//  Created by Andersen on 2020/9/22.
//  Copyright © 2020 郑敏捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSSheetView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSheetManager : NSObject
@property (nonatomic,strong)CSSheetView *sheet;
+ (void)showHud:(NSString*)msg atView:(UIView*)view;
+ (void)hiddenHud;
- (void)showView:(UIView*)view inParent:(UIView*)parent;
- (void)reloadContentHeight:(CGFloat)height;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
