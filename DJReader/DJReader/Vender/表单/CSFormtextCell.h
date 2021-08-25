//
//  CSFormtextCell.h
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"
NS_ASSUME_NONNULL_BEGIN
@interface CSFormtextModel : CSFormModel
@property (nonatomic,copy)NSString *placeholder;

@end
@interface CSFormtextCell : CSFormCell
@end

NS_ASSUME_NONNULL_END
