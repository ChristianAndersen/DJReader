//
//  CSSlider.h
//  CSSliderView
//
//  Created by Andersen on 2020/3/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSSlider : UISlider
- (void)setValueLabValue:(NSString*)value;

- (void)setTitleLabTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
