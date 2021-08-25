//
//  FileEditorController.h
//  DJReader
//
//  Created by Andersen on 2020/3/7.
//  Copyright © 2020 Andersen. All rights reserved.
//
//文件编辑器，悬浮按钮弹框类结构
//FileEditorController 里悬浮按钮点击，弹出弹框控制图 Suspension是弹框的总视图，EditorControllView是三个圆形按钮的父视图，一直处在SuspensionViewde 上方，sealAttributeView，HandAttributeView，TextAtrributeView，是三个圆形按钮点击分别移到SuspensionView前方，处于EditorCotrollView的下方


#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "DJFileDocument.h"
NS_ASSUME_NONNULL_BEGIN
@protocol FileActionDelegate <NSObject>
- (void)fileChange:(DJFileDocument*)file didStar:(BOOL)star;
@end

@class CSTabBarMainController;
@interface FileEditorController :UIViewController
@property (nonatomic,assign)id<FileActionDelegate>actionDelegate;
@property (nonatomic,strong)DJFileDocument *file;
@property (nonatomic,weak)CSTabBarMainController *originController;
- (void)changeBarType:(EditorNavBarType)type;
- (void)changeBarSelected:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
