//
//  CSFunctions.h
//  DJReader
//
//  Created by Andersen on 2020/3/31.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString* fileMD5WithPath(NSString *path);
void addTarget(UIViewController *vc,UIAlertAction* sureAction,UIAlertAction* cancelAction, NSString *msg);
void addActionsToTarget(UIViewController *vc,NSArray<UIAlertAction*>* actions);
/**
 保存图片到相册,
  @param images 保存到相册的图片
 @param target 提示框所在的控制器
 */
void SaveToCamera(NSArray *images,UIViewController *target);

