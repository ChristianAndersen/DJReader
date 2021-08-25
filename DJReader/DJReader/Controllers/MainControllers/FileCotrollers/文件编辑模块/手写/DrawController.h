//
//  DrawController.h
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "ADSDrawView.h"
#import "ColorUnit.h"
#import "DJReadManager.h"
@interface DrawController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) ADSDrawView *drawView;
@property (nonatomic,copy)void (^imageSelectedBlcok)(UIImage *image);
@property (nonatomic,strong)ColorUnit *unit;
@property (nonatomic,assign)CGFloat penWidth;
@end
