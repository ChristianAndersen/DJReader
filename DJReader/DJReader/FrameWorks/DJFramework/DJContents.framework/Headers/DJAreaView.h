//
//  PopupZoomView.h
//  DJContent
//
//  Created by yons on 14-8-7.
//  Copyright (c) 2014年 dianju. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(int, DJAreaAction)
{
    DJAreaActionWrite,
    DJAreaActionErase
};

/**
 红框偏移方向

 - DJAreaDirectionLeft: 向左偏移
 - DJAreaDirectionLeft: 向右偏移
 */
typedef NS_ENUM(int, DJAreaDirection)
{
    DJAreaDirectionLeft = 0,//向左偏移
    DJAreaDirectionRight,//向右偏移
};

@interface DJAreaHandle : NSObject

- (void)remove;

@end

@interface DJAreaView : UIView

@property (nonatomic) DJAreaAction currentAction;

/**
 提交的等待时间，小于0.5无效，需要手动提交
 */
@property (nonatomic,assign) double submitTimer;

/**
 自动换行范围(学安卓 搞成比例 虚线UI自己加)
 */
@property (nonatomic,assign) float turnFlag;

/**
 回退手写上一步
 */
- (void)undo;

/**
 撤销上一步回退操作
 */
- (void)redo;

/**
 清除所有手写的笔迹
 */
- (void)clear;

/**
 确定

 @return 手写区域
 */
- (DJAreaHandle*)submit;

/**
 设置文字

 @param meassage 添加文字
 @param timeStr 时间戳
 */
- (void)setMeassage:(NSString*)meassage timeStrig:(NSString*)timeStr;

/**
 编辑红框范围移动

 @param offsetUnit 边缘触发的范围
 @param direction 移动方向
 */
- (void)moveArea:(double)offsetUnit withType:(DJAreaDirection)direction;

/**
 红框位置获取

 @return CGRect
 */
- (CGRect)getAreaFrame;

/**
 设置红框初始位置

 @param offset CGPoint
 */
- (void)setAreaFrame:(CGPoint)offset;

@end


