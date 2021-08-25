//
//  UserPreference.h
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorUnit.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserPreference : NSObject
@property (nonatomic,strong) NSString *fontName,*fontNum;
@property (nonatomic,strong) NSString *fontNameKey;//用于获取字体的字段

@property (nonatomic,strong) ColorUnit *colorUnit;
@property (nonatomic,assign) CGFloat penwidth;

@property (nonatomic,strong)NSMutableDictionary *fontsName;
@property (nonatomic,strong)NSMutableArray *fontsNum;
@property (nonatomic,strong)NSMutableArray *colorUnits;
@end

NS_ASSUME_NONNULL_END
