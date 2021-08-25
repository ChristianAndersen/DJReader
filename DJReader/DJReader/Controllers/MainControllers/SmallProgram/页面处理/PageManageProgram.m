//
//  PageManageProgram.m
//  DJReader
//
//  Created by Andersen on 2021/6/3.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "PageManageProgram.h"
#import "DJFileDocument.h"
#import "FileSelectController.h"
#import "CSImagePicker.h"
#import <DJContents/DJContentView.h>
#import <MBProgressHUD.h>
#import "DJFileManager.h"
#import "CSSheetManager.h"

@interface PageManageProgram ()
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation PageManageProgram
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)fileSelected{
    @WeakObj(self);
    FileSelectController *selectController = [[FileSelectController alloc]init];
    selectController.fileFilterCondition = self.fileFilterCondition;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectController];
    nav.modalPresentationStyle = 0;
    selectController.programName = self.programName;
    
    selectController.fileSelectHander = ^(DJFileDocument * _Nonnull fileModel) {
        weakself.fileModel = fileModel;
        [weakself gotoImagePicker:fileModel];
    };
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)gotoImagePicker:(DJFileDocument*)fileModel
{
    @WeakObj(self);
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeImages;
    imagePicker.fileModel = fileModel;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        NSMutableArray *paths = [[NSMutableArray alloc]initWithArray:imagePaths];
        [weakself mergeFile:paths];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)mergeFile:(NSMutableArray*)imagePaths{
    [DJContentView verify:@"INXT" verifylicFile:@"XSLSjA36jgtp5xM9qypF4SXqM0KOksF5z9FE+IsRZzo="];
    [DJContentView loginUser:@"Andersen" loadOtherNodes:YES];
    
    DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds aipFilePath:[imagePaths firstObject]];
    for (int i = 1;i<imagePaths.count;i++) {
        NSString *path = [imagePaths objectAtIndex:i];
        [contentView mergeFile:path afterPage:contentView.pageCount];
    }
    [contentView saveToFile:self.fileModel.filePath];
    showAlert(@"编辑成功", self);
}
@end
