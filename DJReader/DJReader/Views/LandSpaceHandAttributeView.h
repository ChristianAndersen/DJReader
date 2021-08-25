//
//  LandSpaceHandAttributeView.h
//  DJReader
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSBottomAlert.h"
#import "ColorUnit.h"
NS_ASSUME_NONNULL_BEGIN
@protocol LandSpaceAttributeDelegate <NSObject>

- (void)penWidthChange:(int)penWidth;
- (void)penHardChange:(int)penHard;
- (void)penColorUnitSelected:(ColorUnit*)unit;
@end

@interface LandSpaceHandAttributeView : CSBottomAlert

@property (nonatomic,assign)CGFloat penWidth,penAlpha;
@property (nonatomic,strong)ColorUnit *unit;
@property (nonatomic,assign)id <LandSpaceAttributeDelegate>selectorDelegate;

@end

NS_ASSUME_NONNULL_END
