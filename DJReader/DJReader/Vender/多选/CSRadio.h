//
//  CSRadio.h
//  DJReader
//
//  Created by Andersen on 2020/9/5.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSRadio : UIControl
@property (nonatomic,assign)SEL action;
@property (nonatomic,strong)id target;
@property (nonatomic,copy) NSString *title;
///方向右下：0；1；
@property (nonatomic,assign)NSInteger direction;
- (void)addTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
