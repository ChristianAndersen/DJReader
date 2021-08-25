//
//  DJTextAreaBlockHandle.h
//  DJContent
//
//  Created by yons on 14-10-13.
//  Copyright (c) 2014年 dianju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(int, DJAreaExt)
{
    DJAreaExtNone = 0,//普通区域
    DJAreaExtDATEMODE = 1,//对于编辑框，日期模式
    DJAreaExtINTEGERMODE =2,//对于编辑框，整数模式
    DJAreaExtFLOATMODE = 3,//对于编辑框，浮点数模式
    DJAreaExtJINEMODE = 4,//对于编辑框，大写金额模式
    DJAreaExtPICMODE = 5,//对于编辑框，图片模式
    DJAreaExtSEALMODE = 6,//对于编辑框，印章模式
    DJAreaExtCHNDATEMODE = 7,//对于编辑框，中文日期模式
    DJAreaExtFLOATFORMATMODE = 8,//对于编辑框，浮点数数值格式：固定小数为2，3位间加,
};
@interface DJTextAreaBlockHandle : NSObject

@property (nonatomic,assign)DJAreaExt ext;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *areaName;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,assign)BOOL userInfo;

- (void)submitWithText:(NSString*)text;
@end

