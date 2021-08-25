//
//  DJTextBlockHandle.h
//  DJContent
//
//  Created by yons on 15-1-15.
//  Copyright (c) 2015年 dianju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct DJAreaIndexPath{
    NSInteger areaType;  //区域类型
    NSInteger areaRow;   //区域所属页面
    NSInteger areaID;    //区域标识
};
typedef struct DJAreaIndexPath DJAreaIndexPath;

CG_INLINE DJAreaIndexPath

DJAreaIndexPathMake(NSInteger areaType,NSInteger areaRow,NSInteger areaID){
    DJAreaIndexPath areaIndexPath;
    areaIndexPath.areaType = areaType;
    areaIndexPath.areaRow  = areaRow;
    areaIndexPath.areaID   = areaID;
    return areaIndexPath;
}

@interface DJTextBlockHandle : NSObject
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,assign)DJAreaIndexPath areaIndexPath;
@property (nonatomic,assign)BOOL userInfo;
@property (nonatomic,strong)UIFont *font;

- (void)submitWithText:(NSString*)text;
- (void)setFont:(UIFont *)font;
- (void)setColor:(UIColor *)color;
@end
