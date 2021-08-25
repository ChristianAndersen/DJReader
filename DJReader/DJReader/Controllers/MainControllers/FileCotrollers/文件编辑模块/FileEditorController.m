//
//  FileEditorController.m
//  DJReader
//
//  Created by Andersen on 2020/3/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "FileEditorController.h"
#import "FIleEditorView.h"
#import "CSNavBar.h"
#import "HWPop.h"
#import "HEMenu.h"
#import "EditorNavBar.h"
#import "CSCoreDataManager.h"
#import "DJFileManager.h"
#import <UIKit/UIActivity.h>
#import "CSShareManger.h"
#import "LoginViewController.h"
#import "CSSheetManager.h"
#import "SuspensionView.h"
#import "CSImportImageView.h"
#define controllWidth self.view.width/4.5
#define controllBlank 10
#define controllBarHeight 120

@interface FileEditorController ()<EditorNavBarDelegate,SuspensionDelegate,CSSheetDelegate>

@property (nonatomic,strong)FIleEditorView *fileContainer;//文件页面
@property (nonatomic,strong)CSSheetView *sheetView;
@property (nonatomic,strong)SuspensionView *suspension;
@property (nonatomic,strong)EditorNavBar *editorNarBar;
@property (nonatomic,strong)UIButton *suspensionControll;
@property (nonatomic,assign)BottomActionType actionType;
@property (nonatomic,strong)NSDictionary *params;

@property (nonatomic,assign)CGFloat handSuspensionHeight,sealSuspensionHeight,textSuspensionHeight;
@end

@implementation FileEditorController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (CGFloat)handSuspensionHeight
{
    if (isPad) {
        return 450;
    }
    return 250;
}
- (CGFloat)sealSuspensionHeight
{
    if (isPad) {
        return 600;
    }
    return 400;
}
- (CGFloat)textSuspensionHeight
{
    if (isPad) {
        return 150;
    }
    return 100;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavBar];
    [self createFileContainer:_file];
    [self cretateSuspensionControll];
}
- (void)createNavBar
{
    _editorNarBar = [[EditorNavBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, k_NavBar_Height) andType:EditorNavBarTypeBrowse];
    [self.editorNarBar setStar:self.file.star];
    _editorNarBar.delegate = self;
    [self.view addSubview:_editorNarBar];
}
- (void)createFileContainer:(DJFileDocument*)file
{
    if (!file) return;
    
    _fileContainer = [[FIleEditorView alloc]initWithFrame:CGRectMake(0, k_NavBar_Height, self.view.width, self.view.height - k_NavBar_Height)];
    _fileContainer.parentController = self;
    _fileContainer.fileDocument = file;
    [self.view addSubview:_fileContainer];

    if ([DJReadManager shareManager].appPreference.readPosition)
    {
        [_fileContainer gotoPage:(int)self.file.last_read_position];
    }
}
//创建悬浮控制按钮
- (void)cretateSuspensionControll
{
    _suspensionControll = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspensionControll.frame = CGRectMake(self.view.width - controllWidth - controllBlank, self.view.height - controllWidth - controllBlank - k_TabBar_Height, controllWidth, controllWidth);
    [_suspensionControll setImage:[UIImage imageNamed:@"suspension"] forState:UIControlStateNormal];
    [_suspensionControll addTarget:self action:@selector(suspensionControllAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_suspensionControll];
    [self.view bringSubviewToFront:_suspensionControll];
}
- (void)suspensionControllAction:(UIButton*)sender{
    if(![CSCoreDataManager isLogin]){
        GotoLoginControllerFrom(self);
    }else{
        _sheetView = [[CSSheetView alloc]init];
        _sheetView.delegate = self;
        _suspension = [[SuspensionView alloc]initWithFrame:CGRectMake(20, 0, self.view.width - 40, 600)];//600最大高度
        _suspension.actionDelegate = self;
        _suspension.parentController = self;
        _suspension.backgroundColor = CSBackgroundColor;
        [_sheetView showView:_suspension inParent:self.view];
        [_sheetView reloadContentHeight:self.handSuspensionHeight];
        [self.view addSubview:_sheetView];
    }
}
- (void)showBottom:(CGFloat)height
{
    _suspension.frame = CGRectMake(20, self.view.height - height, self.view.width - 40, height);
}
- (void)setFile:(DJFileDocument *)file
{
    _file = file;
}
#pragma SuspensionDelegate -- 弹框传回的消息
- (void)suspension:(UIView*)suspention actionType:(BottomActionType)actionType parms:(NSDictionary*)parmas
{
    _params = parmas;
    switch (actionType) {
        case BottomActionTypeWait:{
            _actionType  = BottomActionTypeWait;
        }break;
        case BottomActionTypeText:{
            _actionType  = BottomActionTypeText;
            [_sheetView reloadContentHeight:self.textSuspensionHeight];
        }break;
        case BottomActionTypeSeal:{
            _actionType  = BottomActionTypeSeal;
            [_sheetView reloadContentHeight:self.sealSuspensionHeight];
        }break;
        case BottomActionTypeHand:{
            _actionType  = BottomActionTypeHand;
            [_sheetView reloadContentHeight:self.handSuspensionHeight];
        }break;
        default:
            break;
    }
}
- (void)suspension:(UIView *)suspension selectedCertificate:(DJCertificate *)certificate
{
    [self.sheetView dismiss];
}
//弹框消失后
- (void)dismissSheetView:(CSSheetView *)sheet
{
    [self.fileContainer parseParams:self.params withControllType:_actionType];
}
- (void)changeBarType:(EditorNavBarType)type
{
    [self.editorNarBar changeType:type];
}
- (void)changeBarSelected:(NSString*)title
{
    [self.editorNarBar setSelectedSingleItem:title];
}
#pragma methods
- (void)back:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma EditorNavBarDelegate
- (void)navBar:(EditorNavBar *)bar type:(EditorNavBarType)type selectItem:(NSString *)title
{
    switch (type) {
        case EditorNavBarTypeBrowse:{
            [self browseBarAction:title];
        } break;
        case EditorNavBarTypeText:{
            [self textBarAction:title];
        } break;
        case EditorNavBarTypeSeal:{
            [self sealBarAction:title];
        } break;
        case EditorNavBarTypeHand:{
            [self handBarAction:title];
        } break;
        default:
            break;
    }
}
- (void)browseBarAction:(NSString*)title
{
    if ([title isEqualToString:Action_Back]) {
        [self closeFile];
    }
    if ([title isEqualToString:Action_Star]) {
        [self setStar];
    }
    if ([title isEqualToString:Action_Share]) {
        [self shareFile];
    }
    if ([title isEqualToString:Action_Save]) {
        [self saveFile];
    }
    if ([title isEqualToString:Action_ImportImage]) {
        CSImportImageView *popView = [[CSImportImageView alloc]initCompleteHander:^(NSString *title) {
            if ([title isEqualToString:Action_Option_images]) {
                [self importImages];
            }else if([title isEqualToString:AcTion_Option_longImage]){
                [self importLongImage];
            }
        }];
        [popView showView];
    }
}
- (void)sealBarAction:(NSString*)title
{
    if ([title isEqualToString:Action_Exit]) {
        [self.editorNarBar changeType:EditorNavBarTypeBrowse];
        [self.fileContainer beganBrowse];
    }
    if ([title isEqualToString:Action_Undo]) {
         [self.fileContainer undo];
     }
}
- (void)textBarAction:(NSString*)title
{
    if ([title isEqualToString:Action_Exit]) {
        [self.editorNarBar changeType:EditorNavBarTypeBrowse];
        [self.fileContainer beganBrowse];
    }
    if ([title isEqualToString:Action_LuRu]) {
        [self.fileContainer beganText];
    }
    if ([title isEqualToString:Action_PaiBan]) {
        [self.fileContainer beganMove];
    }
    if ([title isEqualToString:Action_Undo]) {
        [self.fileContainer undo];
    }
}
- (void)handBarAction:(NSString*)title
{
    if ([title isEqualToString:Action_PaiBan]) {
        [self.fileContainer beganMove];
    }
    if ([title isEqualToString:Action_Hand]) {
        [self.fileContainer beganHand];
    }
    if ([title isEqualToString:Action_Exit]) {
        [self.editorNarBar changeType:EditorNavBarTypeBrowse];
        [self.fileContainer beganBrowse];
    }
    if ([title isEqualToString:Action_Undo]) {
        [self.fileContainer undo];
    }
}
- (void)shareFile
{
    [self.fileContainer shareFile];
}
- (void)setStar
{
    if (![CSCoreDataManager isLogin]) {
        ShowMessage(@"提示", @"游客身份无法保存编辑操作", self);
    }else{
        _file.star = !_file.star;
        [[CSCoreDataManager shareManager] updataFileToCoreData:_file];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(fileChange:didStar:)]) {
            [self.actionDelegate fileChange:self.file didStar:_file.star];
        }else{
        }
    }
}

- (void)importImages
{
    [self.fileContainer importImages];
}
- (void)importLongImage
{
    [self.fileContainer importLongImage];
}
- (void)saveFile
{
    if (![CSCoreDataManager isLogin]) {
        ShowMessage(@"提示", @"游客身份无法保存编辑操作", self);
    }else{
        [self.fileContainer saveFile];
    }
}
- (void)closeFile
{
    self.file.last_read_position = [self.fileContainer closeFile];
    [[CSCoreDataManager shareManager] updataFileToCoreData:self.file];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.editorNarBar.backgroundColor = DrakModeColor;
        }else{
            self.editorNarBar.backgroundColor = LightModeColor;
        }
    } else {
            self.editorNarBar.backgroundColor = LightModeColor;
    }
}
@end
