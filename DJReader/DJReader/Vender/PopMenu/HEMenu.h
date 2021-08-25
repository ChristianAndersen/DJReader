//
//  HEMenuC.h
//  YHMenu
//
//  Created by Boris on 2018/5/10.
//  Copyright © 2018年 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MenuView.h"
#import "MenuEnums.h"


@interface HEMenu : NSObject

+ (HEMenu *)shareManager;

// item.count != imgSource.count 或 imgSource.count == 0 时, 不显示图片, 只显示文本

/*
 * width menu的宽高
 * point 顶点的point
 * item  要显示的文本icon字典
 * style 单选还是多选
 * action 点击方法回调
 */
- (void) showMenuWithSize:(CGSize)width
                    point:(CGPoint)point
               itemSource:(NSDictionary *)item
                    style:(MenuStyle)style
                   action:(void (^)(NSMutableDictionary *indexes))action;
@end
