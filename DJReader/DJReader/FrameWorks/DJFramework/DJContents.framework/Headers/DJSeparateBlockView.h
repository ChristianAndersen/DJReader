//
//  DJBlockZoomView.h
//  DJContent
//
//  Created by yons on 14-8-28.
//  Copyright (c) 2014年 dianju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJSeparateBlockView : UIView
@property (nonatomic,assign) NSString *path;
@property (nonatomic,assign) UIImage *image;
@property (nonatomic,assign) int areaNum;
//DJContentView实例化方法返回的实例，下面两属性才有效
@property (nonatomic,assign) float handSize;
@property (nonatomic,assign) float handHeight;

@property (nonatomic,assign) double submitTimer;//提交的等待时间，小于0.5无效，需要手动提交
@property (nonatomic,assign) BOOL isHightLight;//提交的选中状态

- (void)submit;
- (void)submitComplete:(void (^)(UIImage* image))complete;// 手写笔迹回调，返回笔记图片
- (void)cleanBackward;
- (void)setDrawViewBackground:(UIImage*)image;//设置手写view背景

@end
