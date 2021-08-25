//
//  DJMainFileView.m
//  DJReader
//
//  Created by Andersen on 2020/6/20.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJMainFileView.h"
#import "HWPopController.h"
#import "FileEditorController.h"
#import "CSNavBar.h"
#import "HEMenu.h"
#import "DJFileDetailsViewController.h"
#import "CSCoreDataManager.h"
#import "JGCycleCollectionView.h"
#import "DJFileTableViewCell.h"
#import "CSSheetManager.h"
#import "DJReadNetManager.h"
#import "CSImagePicker.h"
#import "CSImportImageView.h"
#import <DJContents/DJContentView.h>
#import "CSIMagePickerResultVC.h"
#import "FileBrowseController.h"
#import "CSShareManger.h"

#define menuBarHeight 44
#define ScrWebViewHeight 160

@interface DJMainFileView ()<UITableViewDelegate,UITableViewDataSource,DJFileDetailsViewControllerDelegate,NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) UITableView * filesTableView;
@property (nonatomic,strong) CSNavBar * menu;
///滚动视图
@property (nonatomic,strong) JGCycleCollectionView *cycle;
///点击回调
@property (nonatomic,strong) void(^clickStar)(void);
@property (nonatomic,strong) NSMutableArray *allModels;
@property (nonatomic,strong) NSMutableArray *fileModels;
@property (nonatomic,strong) NSMutableArray *otherModels;

@property (nonatomic,strong) NSPredicate *predicate;
@property (nonatomic,strong) NSSortDescriptor *descriptor;
@end

@implementation DJMainFileView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
    [self initTableView:self.view.frame];
    self.view.userInteractionEnabled = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.filesTableView];
    [self.view addSubview:self.menu];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFileModel];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
///初始化文件视图
-(void)initTableView:(CGRect)frame{
    _filesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height) style:UITableViewStyleGrouped];
    _filesTableView.estimatedRowHeight = 0.01;
    _filesTableView.estimatedSectionFooterHeight = 0.01;
    _filesTableView.estimatedSectionHeaderHeight = 0.01;
    _filesTableView.dataSource = self;
    _filesTableView.delegate = self;
    _filesTableView.rowHeight = 80;
    [self.view addSubview:_filesTableView];
}
- (void)reloadData
{
    _allModels = [[CSCoreDataManager shareManager] fetchAllFileFromCoreData];
    [self.filesTableView reloadData];
}
- (void)loadFileModel
{
    _allModels = [[NSMutableArray alloc]init];
    _otherModels = [[NSMutableArray alloc]init];
    _fileModels = [[NSMutableArray alloc]init];
    NSPredicate *predicate;
    _allModels = (NSMutableArray*)[[CSCoreDataManager shareManager] fetchAllFileFromCoreData:predicate descriptors:self.descriptor];
          
    for (DJFileDocument *model in _allModels) {
        if ([[model.filePath pathExtension] isEqualToString:@"aip"]||[[model.filePath pathExtension] isEqualToString:@"ofd"]||[[model.filePath pathExtension] isEqualToString:@"pdf"]) {
            [_fileModels addObject:model];
        }else if([[model.filePath pathExtension] isEqualToString:@"doc"]||[[model.filePath pathExtension] isEqualToString:@"docx"]||[[model.filePath pathExtension] isEqualToString:@"ppt"]||[[model.filePath pathExtension] isEqualToString:@"pptx"]||[[model.filePath pathExtension] isEqualToString:@"xls"]||[[model.filePath pathExtension] isEqualToString:@"xlsx"]){
            [_otherModels addObject:model];
        }
    }
    [self reloadData];
}
- (void)reloadFileList
{
    [self loadFileModel];
    [self.filesTableView reloadData];
}
- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return @"文件";
}
#pragma UITabbleViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 300;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_fileModels.count>0) {//如果有aip，pdf，ofd格式文件
            return menuBarHeight + ScrWebViewHeight;
        }else{
            return ScrWebViewHeight;
        }
    }else{
        return 40;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    return footer;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self loadHeadView];
    }else{
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        lab.backgroundColor = CSBackgroundColor;
        lab.text = @"    其他格式";
        return lab;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_otherModels.count>0) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.fileModels.count;
    }else{
        return self.otherModels.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    DJFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[DJFileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId isOperational:YES];
    }
    @WeakObj(self)
    DJFileDocument *fileModel;
    if (indexPath.section == 0) {
        fileModel = [self.fileModels objectAtIndex:indexPath.row];
    }else{
        fileModel = [self.otherModels objectAtIndex:indexPath.row];
    }
    [cell setFileExpandBtn:^(UIButton * _Nonnull expandBtn) {
        [weakself clickedOperationWithModel:fileModel];
    }];
    [cell setDJFolderCellData:fileModel];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80.0;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        DJFileDocument *fileModel = [self.fileModels objectAtIndex:indexPath.row];
        FileEditorController *fileEditor = [[FileEditorController alloc]init];
        fileEditor.originController = self.originController;
        fileEditor.file = fileModel;
        fileEditor.modalPresentationStyle = 0;
        [self presentViewController:fileEditor animated:YES completion:nil];
    }else{
        DJFileDocument *fileModel = [self.otherModels objectAtIndex:indexPath.row];
        FileBrowseController *browseController = [[FileBrowseController alloc]init];
        browseController.file = fileModel;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:browseController];
        navc.modalPresentationStyle = 0;
        [self presentViewController:navc animated:YES completion:nil];
    }
}

- (UIView*)loadHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScrWebViewHeight)];
    if (!_cycle) {
        _cycle = [[JGCycleCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScrWebViewHeight)];
        _cycle.data = @[@"advert01",@"advert02",@"advert03"];
        _cycle.autoPage = YES;
        [self.view addSubview:_cycle];
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewClicked)];
        [_cycle addGestureRecognizer:labelTapGestureRecognizer];
    }
    [headView addSubview:_cycle];
    //更新菜单
    if (_fileModels.count > 0) {
        headView.frame = CGRectMake(0, 0, self.view.frame.size.width, menuBarHeight + ScrWebViewHeight);
        _menu = [[CSNavBar alloc]initWithFrame:CGRectMake(0, ScrWebViewHeight, self.view.frame.size.width, menuBarHeight)];
        _menu.backgroundColor = CSBackgroundColor;
        [_menu cleanItems];
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.backgroundColor = CSBackgroundColor;
        titleLab.text = @"    文档";
        titleLab.textAlignment = NSTextAlignmentLeft;
        [_menu setLetfItems:@[titleLab]];

        UIButton * item1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [item1 addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [item1 setTitle:@"排序" forState:UIControlStateNormal];
        [_menu setRightItem:@[item1]];
        [_menu reloadItems];
        [headView addSubview:_menu];
    }
    return headView;
}
//跳转至官网
-(void)scrollViewClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.dianju.cn"]];
}
- (void)clickedOperationWithModel:(DJFileDocument*)fileModel
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSMutableArray *itemsImage = [[NSMutableArray alloc]init];
    if ([[fileModel.filePath pathExtension] isEqualToString:@"aip"]||[[fileModel.filePath pathExtension] isEqualToString:@"ofd"]||[[fileModel.filePath pathExtension] isEqualToString:@"pdf"]) {
        [items addObject:ChangeName];
        [items addObject:AddStar];
        [items addObject:ShareFile];
        [items addObject:DeletedFile];
        [items addObject:Action_ImportImage];
        
        [itemsImage addObject:ChangeName_Image];
        [itemsImage addObject:StarFile_Image];
        [itemsImage addObject:ShareFile_Image];
        [itemsImage addObject:DeletedFile_Image];
        [itemsImage addObject:Action_ImportImage];
    }else{
        [items addObject:ChangeName];
        [items addObject:AddStar];
        [items addObject:ShareFile];
        [items addObject:DeletedFile];
        [items addObject:ChangeFilePDF];
        [items addObject:ChangeFileOFD];
        
        [itemsImage addObject:ChangeName_Image];
        [itemsImage addObject:StarFile_Image];
        [itemsImage addObject:ShareFile_Image];
        [itemsImage addObject:DeletedFile_Image];
        [itemsImage addObject:ChangeFilePDF_Image];
        [itemsImage addObject:ChangeFileOFD_Image];
    }
    DJFileDetailsViewController *fileDetailsVc = [[DJFileDetailsViewController alloc]initWithItems:items andImages:itemsImage];
    fileDetailsVc.fileDetailsVcDelegate = self;
    fileDetailsVc.fileModel = fileModel;
    HWPopController *popController = [[HWPopController alloc] initWithViewController:fileDetailsVc];
    popController.popPosition = HWPopPositionBottom;
    popController.popType = HWPopTypeBounceInFromBottom;
    popController.dismissType = HWDismissTypeSlideOutToBottom;
    popController.shouldDismissOnBackgroundTouch = YES;
    [popController presentInViewController:self.originController];

    fileDetailsVc.seleted = ^(NSString * _Nonnull title) {
        [popController dismissWithCompletion:nil];
        if ([title isEqualToString:ChangeName]) {
            [self changeFileName:fileModel];
        }else if([title isEqualToString:ShareFile]){
            [self shareFile:fileModel];
        }else if([title isEqualToString:AddStar]){
            [self addStar:fileModel];
        }else if([title isEqualToString:DeletedStar]){
            [self deletedStar:fileModel];
        }else if([title isEqualToString:DeletedFile]){
            [self deleteFile:fileModel];
        }else if([title isEqualToString:ChangeFileOFD]){
            [self changeFileOFD:fileModel];
        }else if([title isEqualToString:ChangeFilePDF]){
            [self changeFilePDF:fileModel];
        }else if([title isEqualToString:Action_ImportImage]){
            [self importImage:fileModel];
        }
    };
}
- (void)changeFileName:(DJFileDocument*)fileModel
{
    NSString * str = [NSString stringWithFormat:@"修改文件名"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alertController.textFields[0];
        if (name) {//cd改名
            fileModel.name = [NSString stringWithFormat:@"%@.%@",name.text,[fileModel.name pathExtension]];
            [[CSCoreDataManager shareManager] updataFileToCoreData:fileModel];
            [self loadFileModel];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入文件名称";
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES  completion:nil];
    });
}
- (void)deleteFile:(DJFileDocument*)fileModel
{
    NSString * str = [NSString stringWithFormat:@"是否删除文件"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CSCoreDataManager shareManager] deleteFileToCoreData:fileModel];
        [self loadFileModel];
        [self reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"不删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES  completion:nil];
    });

}
- (void)shareFile:(DJFileDocument*)fileModel
{
    NSURL*fileURL = [[NSURL alloc]initFileURLWithPath:fileModel.filePath];
    [CSShareManger shareActivityController:self withFile:fileURL];
}
- (void)deletedStar:(DJFileDocument*)fileModel
{
    if (![CSCoreDataManager isLogin]) {
        showAlert(@"游客身份无法进行此操作", self);
    }else{
        fileModel.star = 0;
        [[CSCoreDataManager shareManager] updataFileToCoreData:fileModel];
        self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    }
}
- (void)addStar:(DJFileDocument*)fileModel
{
    if (![CSCoreDataManager isLogin]) {
        showAlert(@"游客身份无法进行此操作", self);
    }else{
        fileModel.star = 1;
        [fileModel.superFloders addObject:@(DEFAULTME_FLODER_ID)];
        [[CSCoreDataManager shareManager] updataFileToCoreData:fileModel];
    }
}
- (void)changeFilePDF:(DJFileDocument*)fileModel
{
    [self.originController convertFile:fileModel toFormat:@"pdf"];
}
- (void)changeFileOFD:(DJFileDocument*)fileModel
{
    [self.originController convertFile:fileModel toFormat:@"ofd"];
}
- (void)importImage:(DJFileDocument*)fileModel
{
    CSImportImageView *popView = [[CSImportImageView alloc] initCompleteHander:^(NSString *title) {
        if ([title isEqualToString:Action_Option_images]) {
            [self importImages:fileModel];
        }else if([title isEqualToString:AcTion_Option_longImage]){
            [self importLongImage:fileModel];
        }
    }];
    [popView showView];
}
- (void)importImages:(DJFileDocument*)fileModel
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeImages;
    imagePicker.fileModel = fileModel;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        NSMutableArray *images = [NSMutableArray new];
        for (NSString *path in imagePaths) {
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
            [images addObject:image];
        }
        SaveToCamera(images, self.originController);
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self.originController presentViewController:nav animated:YES completion:^{
    }];
    NSLog(@"输出为长图片");
}
- (void)importLongImage:(DJFileDocument*)fileModel
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeLongImage;
    imagePicker.fileModel = fileModel;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CSIMagePickerResultVC *vc = [[CSIMagePickerResultVC alloc]init];
            vc.resource = imagePaths;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self.originController presentViewController:nav animated:YES completion:nil];
        });
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self.originController presentViewController:nav animated:YES completion:^{
    }];
    NSLog(@"逐页输出图片");
}
//top菜单排序
- (void)menuButtonAction:(UIButton*)sender{
    CGPoint point = CGPointMake(sender.x - (100 - sender.width)/2,ScrWebViewHeight + menuBarHeight*2 + self.navigationController.navigationBar.height);
        
    [[HEMenu shareManager]showMenuWithSize:CGSizeMake(90, 160) point:point itemSource:@{@"名字":@"排序",@"大小":@"排序",@"编辑时间":@"排序"} style:MenuStyleSingle action:^(NSMutableDictionary *indexes) {
        NSString * indexe =  [indexes objectForKey:@(1)];
        //打开时间
        if ([indexe isEqualToString:@"0"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
        }
        //名字排序
        if ([indexe isEqualToString:@"1"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
        }
        //大小排序
        if ([indexe isEqualToString:@"2"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"length" ascending:NO];
        }
        [self reloadFileList];
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ChangeUserNotifitionName object:nil];
}
@end
