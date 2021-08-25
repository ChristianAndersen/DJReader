//
//  CSKeyBoardView.h
//  DJReader
//
//  Created by Andersen on 2020/3/13.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJContents/DJContents.h>
#import "ColorUnit.h"
#import "UserPreference.h"
NS_ASSUME_NONNULL_BEGIN
@class FIleEditorView;
@interface CSKeyBoardView : UIView
@property (nonatomic,weak)FIleEditorView *parentView;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)DJTextBlockHandle *handle;
@property (nonatomic,copy)UIFont * curFont;
@property (nonatomic,strong)UIColor *curColor;
- (instancetype)initWithFrame:(CGRect)frame preference:(UserPreference*)preference;
- (void)showView;
- (void)hideView;
@end

NS_ASSUME_NONNULL_END
