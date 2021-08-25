//
//  CSShareManger.h
//  CSShareDemo
//
//  Created by Andersen on 2020/4/17.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CSActivity : UIActivity
@end

@interface CSShareManger : UIView
+ (void)shareActivityController:(UIViewController*)controller withFile:(NSURL*)fileURL;
+ (void)shareActivityController:(UIViewController *)controller withImages:(NSArray *)images;
@end

NS_ASSUME_NONNULL_END
