//
//  CSTextAttributePickerView.h
//  DJReader
//
//  Created by Andersen on 2020/3/18.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^determineBtnActionBlock)(NSInteger fontNum, NSString* fontName, NSDictionary*colorRGB);

@interface CSPickViewItem : UIView
@property (nonatomic,assign)CGFloat r,g,b;
@property (nonatomic,strong)UILabel *center;
@end

@interface CSTextAttributePickerView : UIView

@property (copy, nonatomic) determineBtnActionBlock determineBtnBlock;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
