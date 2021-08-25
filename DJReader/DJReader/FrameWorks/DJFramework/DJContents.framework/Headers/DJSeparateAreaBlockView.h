//
//  DJSeparateAreaBlockView.h
//  DJContent

//  Created by yons on 14-10-20.
//  Copyright (c) 2014年 dianju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  DJSeparateAreaBlockViewParams: NSObject

@property (nonatomic,assign) double lineHeight;
@property (nonatomic,assign) double fontSize;
+ (DJSeparateAreaBlockViewParams*)paramsWithFontSize:(double)fontSize lineHeight:(double)lineHeight;
- (id)initWithFontSize:(double)fontSize lineHeight:(double)lineHeight;
@end

@interface DJSeparateAreaBlockView : UIView
@property (nonatomic,copy) NSString* userName;
@property (nonatomic,copy) NSString* areaName;

- (void)submit;
- (void)deleteBackward;
- (void)cleanBackward;
- (void)saveHands;
- (void)nextLineBackward;
- (void)spaceBackward;
- (UIView*)createPresentView:(CGRect)frame;
@end

