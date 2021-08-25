//
//  EditorNavBar.h
//  DJReader
//
//  Created by Andersen on 2020/3/13.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EditorNavBar;

@protocol EditorNavBarDelegate <NSObject>
- (void)navBar:(EditorNavBar*)bar type:(EditorNavBarType)type selectItem:(NSString*)title;
@end

@interface EditorNavBar : UIView

@property (nonatomic,weak)id<EditorNavBarDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andType:(EditorNavBarType)type;
- (void)setRightItem:(NSString*)title target:(id)target action:(SEL)action;
- (void)setLeftItems:(NSString*)title target:(id)target action:(SEL)action;
- (void)reloadItems;
- (void)changeType:(EditorNavBarType)type;
- (void)setStar:(BOOL)star;
- (void)setSelectedSingleItem:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
