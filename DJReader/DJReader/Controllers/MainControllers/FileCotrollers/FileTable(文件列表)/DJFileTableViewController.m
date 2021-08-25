//
//  DJFileTableViewController.m
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "DJFileTableViewController.h"
#import "DJFileTableView.h"
#import "HWPopController.h"
#import "FileEditorController.h"
#import "CSNavBar.h"
#import "HEMenu.h"
#import "DJFileDetailsViewController.h"
#import "CSCoreDataManager.h"
#import "FileBrowseController.h"

#define menuBarHeight 35
@interface DJFileTableViewController ()<DJFileTableViewDelegate,DJFileDetailsViewControllerDelegate>
@property (nonatomic,strong) DJFileTableView * fileTableView;
@property (nonatomic,strong) CSNavBar * menu;
//点击回调
@property (nonatomic,strong) void(^clickStar)(void);
@property (nonatomic,strong) NSPredicate *predicate;
@property (nonatomic,strong) NSSortDescriptor *descriptor;
@property (nonatomic,assign) BOOL fristTable;
@end

@implementation DJFileTableViewController
- (instancetype)initWithFristTable
{
    self = [super init];
    if (self) {
        _fristTable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    self.view.userInteractionEnabled = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.fileTableView];
    [self.view addSubview:self.menu];
}
- (void)loadNav
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - setTableViewUI -
//菜单
- (CSNavBar *)menu{
    if (!_menu) {
    _menu = [[CSNavBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, menuBarHeight)];
        _menu.backgroundColor = CSBackgroundColor;
    }
    return _menu;
}
- (DJFileTableView *)fileTableView{
    
    if (!_fileTableView) {
           CGRect frame = CGRectMake(0, menuBarHeight, self.view.frame.size.width,self.view.frame.size.height - menuBarHeight);
           _fileTableView = [[DJFileTableView alloc]initWithFrame:frame];
           _fileTableView.fileTableViewDelegate = self;
    }
    return _fileTableView;
}
#pragma mark - data -
- (void)setFileType:(FilType)fileType{
    _fileType = fileType;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.title = [NSString stringWithFormat:@"%@文件夹",_titleStr];
}
//数据
- (void)setFileModerArr:(NSMutableArray <DJFileDocument *>*)fileModerArr{
    if (!_fileModerArr){
        _fileModerArr = fileModerArr;
    }
    //更新表
    [self.fileTableView setFileTableDataArr:_fileModerArr];
    //更新菜单
    [_menu cleanItems];
    UILabel *titleLab = [[UILabel alloc]init];
    NSString * str ;
    if([_titleStr isEqualToString:@"收藏"]){
        str = @"收藏列表";
    }else{
        str = @"文档";
    }
    titleLab.text = str;
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    [_menu setLetfItems:@[titleLab]];
    if(!_fileModerArr.count){//无文件不排序
        [_menu reloadItems];
        return;
    }
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [item1 addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [item1 setTitle:@"排序" forState:UIControlStateNormal];
    [_menu setRightItem:@[item1]];
    [_menu reloadItems];
}
#pragma mark - 文件操作代理 -
- (void)fileTableView:(DJFileTableView *)tabelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(nonnull DJFileDocument *)fileModel{
    if ([[fileModel.filePath pathExtension] isEqualToString:@"aip"]||[[fileModel.filePath pathExtension] isEqualToString:@"pdf"]||[[fileModel.filePath pathExtension] isEqualToString:@"ofd"]) {
        FileEditorController *fileEditor = [[FileEditorController alloc]init];
        fileEditor.originController = self.originController;
        fileEditor.file = fileModel;
        fileEditor.modalPresentationStyle = 0;
        [self presentViewController:fileEditor animated:YES completion:nil];
    }else{
        FileBrowseController *browseController = [[FileBrowseController alloc]init];
        browseController.file = fileModel;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:browseController];
        navc.modalPresentationStyle = 0;
        [self presentViewController:navc animated:YES completion:nil];
    } 
}
//点击文件操作
- (void)clickedOperationWithModel:(nonnull DJFileDocument *)fileModel{
    //文件操作详情页
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSMutableArray *itemsImage = [[NSMutableArray alloc]init];
    if ([[fileModel.filePath pathExtension] isEqualToString:@"aip"]||[[fileModel.filePath pathExtension] isEqualToString:@"aip"]||[[fileModel.filePath pathExtension] isEqualToString:@"aip"]) {
        [items addObject:ChangeName];
        [items addObject:AddStar];
        [items addObject:DeletedFile];
        
        [itemsImage addObject:ChangeName_Image];
        [itemsImage addObject:StarFile_Image];
        [itemsImage addObject:DeletedFile_Image];
    }else{
        [items addObject:ChangeName];
        [items addObject:AddStar];
        [items addObject:DeletedFile];
        [items addObject:ChangeFilePDF];
        [items addObject:ChangeFileOFD];
        
        [itemsImage addObject:ChangeName_Image];
        [itemsImage addObject:StarFile_Image];
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
    [popController presentInViewController:self];
    fileDetailsVc.seleted = ^(NSString * _Nonnull title) {
        [popController dismissWithCompletion:nil];
        if ([title isEqualToString:ChangeName]) {
            [self changeFileName:fileModel];
        }else if([title isEqualToString:AddStar]){
            [self addStar:fileModel];
        }else if([title isEqualToString:DeletedStar]){
            [self deletedStar:fileModel];
        }else if([title isEqualToString:DeletedFile]){
            [self deleteFile:fileModel];
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
            //cd刷新
            if (self.fileType == StarFile) {
                self.predicate  = [NSPredicate predicateWithFormat:@"star = %d",1];
            }
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
            self.fileTableView.fileTableDataArr = [[[CSCoreDataManager shareManager]fetchAllFileFromCoreData:self.predicate descriptors:self.descriptor] mutableCopy];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入文件夹名称";
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
        //刷新
        if (self.fileType == StarFile) {
            self.predicate  = [NSPredicate predicateWithFormat:@"star = %d",1];
        }
        self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        self.fileTableView.fileTableDataArr = [[[CSCoreDataManager shareManager]fetchAllFileFromCoreData:self.predicate descriptors:self.descriptor] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"不删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES  completion:nil];
    });

}
- (void)addStar:(DJFileDocument*)fileModel
{
    if (![CSCoreDataManager isLogin]) {
        showAlert(@"游客身份无法进行此操作", self);
    }else{
        fileModel.star = 1;
        [[CSCoreDataManager shareManager] updataFileToCoreData:fileModel];
        if (self.fileType == StarFile)
        {
            self.predicate = [NSPredicate predicateWithFormat:@"star = %d",1];
        }
        self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        //更新界面
        self.fileTableView.fileTableDataArr = [[[CSCoreDataManager shareManager]fetchAllFileFromCoreData:self.predicate descriptors:self.descriptor] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
    }
}
- (void)deletedStar:(DJFileDocument*)fileModel
{
    if (![CSCoreDataManager isLogin]) {
        showAlert(@"游客身份无法进行此操作", self);
    }else{
        fileModel.star = 0;
        [[CSCoreDataManager shareManager] updataFileToCoreData:fileModel];
        
        if (self.fileType == StarFile) {
            self.predicate  = [NSPredicate predicateWithFormat:@"star = %d",1];
        }
        self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        // 更新界面
        self.fileTableView.fileTableDataArr = [[[CSCoreDataManager shareManager]fetchAllFileFromCoreData:self.predicate descriptors:self.descriptor] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
    }
}
//top菜单
- (void)menuButtonAction:(UIButton*)sender{
    
    __block DJFileTableViewController *strongSelf = self;
    CGFloat viewH;
    if (_fristTable) {
        viewH = ScrollWebViewHeight;
    }else{
        viewH = 0;
    }
    CGPoint point = CGPointMake(sender.x - (100 - sender.width)/2,viewH + menuBarHeight*2 + self.navigationController.navigationBar.height);
        
    [[HEMenu shareManager]showMenuWithSize:CGSizeMake(90, 160) point:point itemSource:@{@"名字":@"排序",@"大小":@"排序",@"打开时间":@"排序"} style:MenuStyleSingle action:^(NSMutableDictionary *indexes) {
        NSString * indexe =  [indexes objectForKey:@(1)];
          switch (self.fileType){
              case AllFile://全部
                  break;
              case StarFile://标星
                  self.predicate  = [NSPredicate predicateWithFormat:@"star = %d",1];
                  break;
              default:
                  break;
          }
        //打开时间
        if ([indexe isEqualToString:@"0"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
        }
        //名字排序
        if ([indexe isEqualToString:@"1"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        }
        //大小排序
        if ([indexe isEqualToString:@"2"]) {
            self.descriptor = [NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES];
        }
        [strongSelf.fileTableView setFileTableDataArr:[[[CSCoreDataManager shareManager] fetchAllFileFromCoreData: self.predicate descriptors: self.descriptor] mutableCopy]];
    }];
}

@end
