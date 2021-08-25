//
//  HandAttributeView.h
//  DJReader
//
//  Created by Andersen on 2020/3/17.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorUnit.h"
#import "DJReadManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface HandAttributeView : UIView
@property (nonatomic,assign)CGFloat penWidth,penAlpha;
@property (nonatomic,strong)ColorUnit *unit;
@end

NS_ASSUME_NONNULL_END
