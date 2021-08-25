//
//  DJMainFileView.h
//  DJReader
//
//  Created by Andersen on 2020/6/20.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTabBarMainController.h"
#import "DJFileDocument.h"
#import "MainController.h"

NS_ASSUME_NONNULL_BEGIN
@interface DJMainFileView : UIViewController
@property (nonatomic,strong) NSString * titleStr;
@property (nonatomic,weak)CSTabBarMainController* originController;
//@property (nonatomic,strong) NSMutableArray <DJFileDocument *>* fileModerArr;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
