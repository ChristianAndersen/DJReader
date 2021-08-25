//
//  CSImportImageView.h
//  DJReader
//
//  Created by Andersen on 2021/1/12.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSImportImageView : UIView
@property (nonatomic,copy)void(^completeHander)(NSString*title);
- (instancetype)initCompleteHander:(void (^)(NSString*))hander;
- (void)showView;
- (void)dismissAlertView;
@end

NS_ASSUME_NONNULL_END
