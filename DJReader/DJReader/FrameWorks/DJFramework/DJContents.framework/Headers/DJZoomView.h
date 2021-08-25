//
//  DJZoomView.h
//  DJContent
//
//  Created by yons on 14-8-18.
//  Copyright (c) 2014年 dianju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, DJZoomAction)
{
    DJZoomActionPath,
    DJZoomActionSeal
};

@interface DJZoomView : UIView
@property (nonatomic,strong) NSArray *paths;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) DJZoomAction currentAction;
@property (nonatomic,copy)   NSString *pathsString;

//用于提交笔迹至文件——————————————————————————————————————————————————
- (void)undo;
- (void)redo;
- (void)clear;
- (void)submit;//提交笔迹
//end————————————————————————————————————————————————————————————————

//用于提交印章————————————————————————————————————————————————————————————————
 ;//清除印章,此接口调用后与手写View对应的印章数据清除，不应再持有DJZoomView实例
- (void)clearSeal;
- (void)submitSealComplete:(void(^)(UIImage * image))complete;//提交印章
- (void)submitSeal:(UIImage*)seal;//重新设直印章图片
- (void)setSealDefaultImage:(UIImage*)defaultImage;
//end————————————————————————————————————————————————————————————————
- (void)setDrawViewBackground:(UIImage*)image;
@end
