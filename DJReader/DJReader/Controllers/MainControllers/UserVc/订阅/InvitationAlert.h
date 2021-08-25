//
//  InvitationAlert.h
//  DJReader
//
//  Created by Andersen on 2021/8/17.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface InvitationAlert : UIView
@property (nonatomic,copy)void (^alertTouch)(void);
@end

NS_ASSUME_NONNULL_END
