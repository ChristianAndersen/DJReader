//
//  EditorControllView.h
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditorControllView;
NS_ASSUME_NONNULL_BEGIN


@protocol CSEditorControllViewDelegate <NSObject>
@optional
- (BOOL)controllView:(EditorControllView*)controllView shouldSelectControll:(NSInteger)selectIndex selected:(BOOL)selected;
- (void)controllView:(EditorControllView*)controllView didSelectControll:(NSInteger)selectIndex selected:(BOOL)selected;
@end

@interface EditorControllView : UIView
@property (nonatomic,assign)id <CSEditorControllViewDelegate> selectDelegate;
- (void)setControlls:(NSDictionary*)items;//设置标题和图片
- (void)setControllsWithImage:(NSArray*)items;//只设置图片
@end

NS_ASSUME_NONNULL_END
