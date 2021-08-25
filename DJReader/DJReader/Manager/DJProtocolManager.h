//
//  DJProtocolManager.h
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJSignSeal.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SignSelectorDelegate <NSObject>
- (void)selector:(id _Nullable)selector didSelected:(DJSignSeal*)signSeal;
@end

NS_ASSUME_NONNULL_END
