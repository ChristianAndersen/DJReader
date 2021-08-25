//
//  FIleEditorView.h
//  DJReader
//
//  Created by Andersen on 2020/3/10.
//  Copyright © 2020 Andersen. All rights reserved.
//  文件编辑视图

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"
#import "DJCertificate.h"
NS_ASSUME_NONNULL_BEGIN
@class FileEditorController;

@interface FIleEditorView : UIView
@property (nonatomic,strong)NSData *fileData;
@property (nonatomic,strong)DJFileDocument *fileDocument;
@property (nonatomic,strong)DJCertificate *certificate;
@property (nonatomic,weak)  FileEditorController *parentController;
- (void)parseParams:(NSDictionary*)params withControllType:(BottomActionType)type;
- (void)undo;
- (void)beganHand;
- (void)beganText;
- (void)beganMove;
- (void)beganEraser;
- (void)beganBrowse;
- (void)shareFile;
- (void)saveFile;
- (void)changeBarSeleted:(NSString*)title;
- (void)gotoPage:(int)page;
- (void)importImages;
- (void)importLongImage;
- (int)closeFile;

@end
NS_ASSUME_NONNULL_END
