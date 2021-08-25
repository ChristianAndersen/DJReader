//
//  CSLandSpaceColorSeletor.h
//  DJReader
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPreference.h"
NS_ASSUME_NONNULL_BEGIN
@class CSLandSpaceColorSeletor,ColorUnit;
@protocol LandSpaceColorSeletorDelegate <NSObject>
- (void)colorSelector:(CSLandSpaceColorSeletor*)seletor colorUnit:(ColorUnit*)unit;
@end

@interface CSLandSpaceColorSeletor : UIView
@property (nonatomic,weak)id<LandSpaceColorSeletorDelegate>selectorDelegate;
@property (nonatomic,strong)UIColor *contentColor;
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,strong)UserPreference *preference;
- (instancetype)initWithPreference:(UserPreference *)preference;
@end

NS_ASSUME_NONNULL_END
