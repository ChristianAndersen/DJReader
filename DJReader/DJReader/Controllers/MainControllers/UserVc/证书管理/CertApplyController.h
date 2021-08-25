//
//  CertApplyController.h
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CertApplyController : UIViewController
@property (nonatomic,assign)NSInteger certType;
@property (nonatomic,strong)CSFormTableView *mainView;
@end

NS_ASSUME_NONNULL_END
