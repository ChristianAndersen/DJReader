//
//  CSBottomAlert.h
//  CSBottomAlertView
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^determineBtnActionBlock)(void);

@interface CSBottomAlert : UIView
@property (copy, nonatomic) determineBtnActionBlock determineBtnBlock;
@property (assign,nonatomic)CGSize contenSize;
@property (assign,nonatomic)BOOL showBtn;
@property (assign,nonatomic)BOOL isShow;

- (void)show;
- (void)dismiss;
- (void)setContenSize:(CGSize)contenSize shouldReload:(BOOL)shouldReload;
@end

NS_ASSUME_NONNULL_END
