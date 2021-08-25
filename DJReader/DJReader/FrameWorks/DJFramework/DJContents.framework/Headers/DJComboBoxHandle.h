//
//  DJComboBoxHandle.h
//  DJContents
//
//  Created by dianju on 2018/9/14.
//  Copyright © 2018年 dianju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJComboBoxHandle : NSObject

@property (nonatomic,strong,readonly)NSArray *options;

@property (nonatomic,assign) int curOption;

@end
