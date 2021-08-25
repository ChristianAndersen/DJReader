//
//  CertManagerController.h
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCertificate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertManagerController : UIViewController
@property (nonatomic,copy)void (^certSeletedComplete)(DJCertificate *certificate);
@end

NS_ASSUME_NONNULL_END
