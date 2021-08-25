//
//  DJFileTableViewController.h
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTabBarMainController.h"
#import "DJFileDocument.h"
#import "MainController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FilType) {
    AllFile,
    StarFile,
};

@interface DJFileTableViewController :UIViewController
@property (nonatomic,strong) NSString * titleStr;
@property (nonatomic,weak)CSTabBarMainController* originController;
@property (nonatomic,strong) NSMutableArray <DJFileDocument *>* fileModerArr;
@property (nonatomic,assign) FilType fileType;
- (instancetype)initWithFristTable;
@end


NS_ASSUME_NONNULL_END
