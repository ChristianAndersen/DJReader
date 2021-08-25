//
//  FileProgram.h
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgram.h"

NS_ASSUME_NONNULL_BEGIN
@class CSTabBarMainController;
@interface FileProgram : SmallProgram
@property (nonatomic,strong)UIView  *headView;
@property (nonatomic,strong)UIView  *desView;
@property (nonatomic,strong)UIColor *programColor;
@property (nonatomic,strong)NSArray *descripts;
@property (nonatomic,copy)NSString*headDescript;
@property (nonatomic,copy)NSString *fileFilterCondition;
- (void)fileSelected;
@end

NS_ASSUME_NONNULL_END
