//
//  CSTextColorSeletor.h
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CSTextColorSeletor,ColorUnit;
@protocol CSTextColorSeletorDelegate <NSObject>
- (void)textColorSelector:(CSTextColorSeletor*)seletor indexPath:(NSIndexPath*)indexPath;
@end

@interface CSTextColorSeletor : UIView
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,weak)id<CSTextColorSeletorDelegate>selectorDelegate;
@property (nonatomic,strong)UIColor *contentColor;
- (instancetype)initWithFrame:(CGRect)frame colors:(NSMutableArray*)colors;
@end

NS_ASSUME_NONNULL_END
