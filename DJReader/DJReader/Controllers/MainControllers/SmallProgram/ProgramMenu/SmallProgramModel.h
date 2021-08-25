//
//  SmallProgramModel.h
//  DJReader
//
//  Created by Andersen on 2021/3/10.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmallProgramModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramModel : NSObject
@property (nonatomic,copy) NSString *programName;
@property (nonatomic,copy) NSString *programSection;
@property (nonatomic,strong)UIImage *programHeader;
@end

NS_ASSUME_NONNULL_END
