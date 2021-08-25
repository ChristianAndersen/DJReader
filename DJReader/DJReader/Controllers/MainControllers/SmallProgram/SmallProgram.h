//
//  SmallProgram.h
//  DJReader
//
//  Created by Andersen on 2021/3/11.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallProgram : UIViewController
@property (nonatomic,strong)UIView      *programBar;
@property (nonatomic,strong)UIColor     *backgroundColor;
@property (nonatomic,copy)  NSString    *programName;
@property (nonatomic,strong)NSArray     *tips;

- (void)openVIP;
- (UIImage *)drawShareWithTips:(NSArray*)tips;
- (UIImage *)drawShareImage;
@end

NS_ASSUME_NONNULL_END
