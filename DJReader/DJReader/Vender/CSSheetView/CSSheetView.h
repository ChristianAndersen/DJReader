//
//  CSSheetView.h
//  ZmjPickView
//
//  Created by Andersen on 2020/9/22.
//  Copyright © 2020 郑敏捷. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class CSSheetView;
@protocol CSSheetDelegate <NSObject>
- (void)dismissSheetView:(CSSheetView*)sheet;
@end

@interface CSSheetView : UIView
@property (nonatomic,weak) id<CSSheetDelegate>delegate;

- (void)showView:(UIView*)view inParent:(UIView*)parent;
- (void)reloadContentHeight:(CGFloat)height;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
