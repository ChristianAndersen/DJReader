//
//  CSTextFontTypeSeletor.h
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSTextFontTypeSeletor;
NS_ASSUME_NONNULL_BEGIN
@protocol CSTextFontSeletorDelegate <NSObject>
- (void)fontTypeSelector:(CSTextFontTypeSeletor*)seletor indexPath:(NSIndexPath*)indexPath;
@end

@interface CSTextFontTypeSeletor : UIView
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,weak)id<CSTextFontSeletorDelegate>selectorDelegate;

- (instancetype)initWithFrame:(CGRect)frame fonts:(NSArray*)fontsName;
@end

NS_ASSUME_NONNULL_END
