//
//  CSColorSeletor.h
//  DJReader
//
//  Created by Andersen on 2020/3/21.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJReadManager.h"
NS_ASSUME_NONNULL_BEGIN
@class CSColorSeletor,ColorUnit;
@protocol ColorSeletorDelegate <NSObject>

- (void)colorSelector:(CSColorSeletor*)seletor colorUnit:(ColorUnit*)unit;

@end

@interface CSColorSeletor : UIView
@property (nonatomic,weak)id<ColorSeletorDelegate>selectorDelegate;
@property (nonatomic,strong)UserPreference *preference;
@property (nonatomic,strong)NSIndexPath *curIndexPath;

- (instancetype)initWithPreference:(UserPreference*)preference;

@end

NS_ASSUME_NONNULL_END
