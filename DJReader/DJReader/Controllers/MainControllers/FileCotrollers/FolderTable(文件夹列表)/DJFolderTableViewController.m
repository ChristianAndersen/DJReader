//
//  DJFolderTableViewController.m
//  DJReader
//
//  Created by liugang on 2020/3/18.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJFolderTableViewController.h"
#import "CSNavBar.h"
#import "HEMenu.h"
#import "DJFolderTableView.h"
#import "DJFileTableViewController.h"//文件列表
#import "HWPopController.h"
#import "DJLocalDocumentTool.h"//跳转本地文件夹
#import "DJFloder.h"
#import "DJFileDocument.h"
#import "CSCoreDataManager.h"
#import "DJFilesSearchController.h"
#import "DJReadNetManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#define menuH 40
#define controllWidth self.view.width/5
#define controllBlank 10
#define HeadHeight 49

@interface DJFolderTableViewController ()<DJFolderTableViewDelegate>
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)CSNavBar *menu;
@property (nonatomic,strong)UIButton *suspensionControll;
@property (nonatomic,strong)DJFolderTableView * fileTableView;
@property (nonatomic,retain)NSMutableArray * folderArr;
@property (nonatomic,retain) NSURL * url;

@property (nonatomic,strong)NSMutableArray <DJFloder*> *foldersArr;//文件夹列表
@property (nonatomic,strong)NSMutableArray * folderNameArr;//文件夹名
@end

@implementation DJFolderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"文件夹列表";
}

- (void)viewDidLayoutSubviews
{
    [self setTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.originController.tabBarHidden = NO;
}

#pragma mark - setTableViewUI -
-(void)setTableView{
    //带菜单
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    self.fileTableView = [[DJFolderTableView alloc]initWithFrame:frame];
    self.fileTableView.folderDelegate = self;
    //数据
    self.fileTableView.dataArr = self.foldersArr;
    [self.view addSubview:self.fileTableView];
}


- (void)cretateSuspensionControll
{
    _suspensionControll = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspensionControll.frame = CGRectMake(self.view.width - controllWidth - controllBlank, self.view.height - controllWidth - controllBlank - k_TabBar_Height - k_NavBar_Height, controllWidth, controllWidth);

    [_suspensionControll setImage:[UIImage imageNamed:@"dj_xjwjj"] forState: UIControlStateNormal];
    [_suspensionControll addTarget:self action:@selector(suspensionControllAction:) forControlEvents:UIControlEventTouchUpInside];
    _suspensionControll.layer.masksToBounds = YES;
    _suspensionControll.layer.cornerRadius = controllWidth/2;
    
    [self.view addSubview:_suspensionControll];
    [self.view bringSubviewToFront:_suspensionControll];
}
#pragma mark - 文件夹方法 -
//创建文件夹
- (void)suspensionControllAction:(UIButton*)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"新建文件夹" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"创建文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alertController.textFields[0];
        NSLog(@"name:%@",name.text);
        [self.fileTableView newFolder:name.text];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
       textField.placeholder=@"请输入文件夹名称";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

//点击文件夹 跳转文件页面
-(void)fileTableListView:(DJFolderTableView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行 name == %@",indexPath.row,_foldersArr[indexPath.row].name);
    NSString *didSelectName = _foldersArr[indexPath.row].name;
    if ([didSelectName isEqualToString:@"本地文件"]) {
        [[DJLocalDocumentTool shareDJLocalDocumentTool] seleDocumentWithDocumentTypes:@[@"public.data"] Mode:UIDocumentPickerModeImport controller:self finishBlock:^(NSArray<NSURL *> *urls) {
                NSLog(@"打开文件的urls == %@",urls);
                self.url = urls[0];
            [self openURL:urls[0]];
        }];
        return;
    }
    //浏览收藏
    DJFileTableViewController * fileTableViewController = [[DJFileTableViewController alloc]init];
    fileTableViewController.titleStr = _foldersArr[indexPath.row].name;
    fileTableViewController.originController = self.originController;
    fileTableViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fileTableViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    self.originController.tabBarHidden = YES;
    
    NSMutableArray <DJFileDocument *>*fileModer;
    if ([didSelectName isEqualToString:@"最近浏览"]) {
        fileTableViewController.fileType = AllFile;
        NSPredicate *predicate;
        NSSortDescriptor *descriptor;
        descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
        fileModer =  [NSMutableArray arrayWithArray:[[CSCoreDataManager shareManager] fetchAllFileFromCoreData:predicate descriptors:descriptor]];
    }

    if ([didSelectName isEqualToString:@"收藏"]) {
        fileTableViewController.fileType = StarFile;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"star = %d",YES];
        NSSortDescriptor *descriptor;
        descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        fileModer = [NSMutableArray arrayWithArray:[[CSCoreDataManager shareManager] fetchAllFileFromCoreData:predicate descriptors:descriptor]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        fileTableViewController.fileModerArr = fileModer;
    });
}

//点击文件夹操作按钮 跳出操作界面
-(void)clickFolderOperation:(DJFolderTableView *)listView indexPath:(nonnull NSIndexPath *)indexPath name:(nonnull NSString *)name{
    //不可操作文件夹
    NSArray * arr =[NSArray new];
    arr = @[@"最近浏览",@"本地文件",@"收藏"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([name isEqualToString:obj]){
            NSString * str =[NSString stringWithFormat:@"%@文件夹不可操作",obj];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
    }];
    
    //可操作文件夹
    NSLog(@"点击了%ld,name= %@",indexPath.row,name);
    NSString * nameString = [NSString stringWithFormat:@"%@",name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nameString preferredStyle:UIAlertControllerStyleAlert];
          //文件夹改名
    [alertController addAction:[UIAlertAction actionWithTitle:@"改名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *nameField = alertController.textFields[0];
            [self.fileTableView folderRename:(int)indexPath.row newName:nameField.text];
    }]];
    //删除某个文件夹
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除文件夹" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.fileTableView removeOneFolder:(int)indexPath.row];
    }]];
    //不操作
    [alertController addAction:[UIAlertAction actionWithTitle:@"不操作" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入文件夹名称";
    }];
     
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (CGFloat)DJFolderTableView:(DJFolderTableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)DJFolderTableView:(DJFolderTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeadHeight;
}
- (UIView*)DJFolderTableView:(DJFolderTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (UIView*)DJFolderTableView:(DJFolderTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat interval = 8;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.fileTableView.width, HeadHeight)];
    headView.backgroundColor = CSBackgroundColor;
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(interval, interval, self.fileTableView.width - interval*2, HeadHeight - interval*2)];
    [search addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    search.titleLabel.font = [UIFont systemFontOfSize:14];
    [search setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [search setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    search.imageEdgeInsets = UIEdgeInsetsMake((HeadHeight - 30)/2, (self.fileTableView.width - 30)/2 - 18, (HeadHeight - 30)/2, (self.fileTableView.width - 30)/2 + 18);
    search.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    search.layer.masksToBounds = YES;
    search.layer.cornerRadius = (HeadHeight - interval*2)/2;
    [headView addSubview:search];
    return headView;
}

- (void)searchAction
{
    DJFilesSearchController *search = [[DJFilesSearchController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - top菜单 -
- (void)menuButtonAction:(UIButton*)sender{
    [[HEMenu shareManager]showMenuWithSize:CGSizeMake(100, 160) point:CGPointMake(sender.x - (100 - sender.width)/2, sender.y + sender.height) itemSource:@{@"发起群聊":@"diannao",@"添加朋友":@"jiahaoyou",@"扫一扫":@"saoyisao",@"收付款":@"select1",@"小程序":@"select2"} style:MenuStyleSingle action:^(NSMutableDictionary *indexes) {
        NSLog(@"selected:%@",indexes);
    }];
}

#pragma mark - Data操作 -
- (NSMutableArray<DJFloder *> *)foldersArr{
    if (!_foldersArr) {
        NSArray *folders  = [[CSCoreDataManager shareManager]fetchAllFlodersFromCoreData];
        _foldersArr = [NSMutableArray arrayWithArray:folders];
    }
    return _foldersArr;
}

-(NSMutableArray *)folderNameArr{
    if (!_folderNameArr) {
         _folderNameArr = [NSMutableArray array];
        for (DJFloder *floder in self.foldersArr) {
            [_folderNameArr addObject:floder.name];
        }
    }
    return _folderNameArr;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
}
-(void)openURL:(NSURL *)url{
    NSString *path = [url.path pathExtension];
    NSString *fileName = [url.path lastPathComponent];
    NSString *returnType = @"pdf";
    fileName = [[[fileName componentsSeparatedByString:@"."]firstObject]stringByAppendingFormat:@".%@",returnType];
    
    if ([path isEqualToString:@"aip"]||[path isEqualToString:@"pdf"]||[path isEqualToString:@"ofd"]) {
        //跳转打开文件
        [self.originController setShareFileURL:url];
    }else if ([path isEqualToString:@"doc"]||[path isEqualToString:@"docx"]||[path isEqualToString:@"ppt"]||[path isEqualToString:@"xls"]||[path isEqualToString:@"xlsx"]) {
        [self.originController setShareFileURL:url];
    }else{
        //提示不支持
        NSString * str = [NSString stringWithFormat:@"不支持%@格式文件",path];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)showHUD:(NSString*)msg
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = msg;
    [_hud showAnimated:YES];
}
- (void)hiddenHUD
{
    [_hud hideAnimated:YES];
}
@end
