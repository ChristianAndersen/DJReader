//
//  FileBrowseController.m
//  DJReader
//
//  Created by Andersen on 2021/6/29.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileBrowseController.h"
#import "CSCoreDataManager.h"
#import <WebKit/WebKit.h>
#import "CSSheetManager.h"
#import "DJReadNetManager.h"
#import "SmallProgramCollectionView.h"
#import "CSLaunchView.h"
#import "CSShareManger.h"
#import <DJContents/DJContents.h>

@interface FileBrowseController ()
@property (nonatomic,strong)WKWebView *mainView;
@property (nonatomic,strong)UIScrollView *backView;
@property (nonatomic,strong)NSString *displayFile;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)DJContentView *contentView;
@property (strong, nonatomic)CSLaunchView *expressView;
@end

@implementation FileBrowseController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CSWhiteBackgroundColor;
    [self loadNav];
    [self loadSubview];
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
    self.title = self.file.name;
}
- (void)convertDisplayFile:(NSString *)filePath
{
    NSString *fileName = [[[self.file.filePath lastPathComponent] componentsSeparatedByString:@"#"]lastObject];
    fileName = [[[fileName componentsSeparatedByString:@"."] firstObject] stringByAppendingFormat:@".pdf"];
    self.displayFile = [DJFileManager pathInDisplayDirectoryWithFileName:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:self.displayFile]){
        [self loadSubview];
    }else{
        //需要转换后才能打开的文件
        [CSSheetManager showHud:@"正在打开文件,请稍等" atView:self.view];
        [DJReadNetShare convertFile:self.file.filePath returnType:@"pdf" shouldJudge:NO complete:^(NSString *errMsg, NSString *fileBase64) {
                [CSSheetManager hiddenHud];
                if (errMsg) {
                    showAlert(errMsg, self);
                }else{
                    NSData *fileData = [[NSData alloc] initWithBase64EncodedString:fileBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    [fileData writeToFile:self.displayFile atomically:YES];
                    [self loadSubview];
                }
        }];
    }
}
- (void)starFile
{
    if (![CSCoreDataManager isLogin]) {
        ShowMessage(@"提示", @"游客身份无法保存编辑操作", self);
    }else{
        _file.star = !_file.star;
        [[CSCoreDataManager shareManager]updataFileToCoreData:_file];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserData object:nil];
    }
}
- (void)addFooterView
{
    CGFloat VH = 0;
    CGFloat flagW = 80;
    CGFloat actionH = 120;
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, VH, self.view.frame.size.width, 700)];
    self.footerView.backgroundColor = [UIColor clearColor];
    
    VH = 30.0;
    UILabel *flagLab = [[UILabel alloc]initWithFrame:CGRectMake((self.footerView.width - flagW)/2, VH, flagW, 30)];
    flagLab.text = @"文档结束了";
    flagLab.font = [UIFont systemFontOfSize:14.0];
    flagLab.textAlignment = NSTextAlignmentCenter;
    flagLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    flagLab.backgroundColor = [UIColor clearColor];
    [self.footerView addSubview:flagLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, VH + 15, (self.footerView.width - flagW)/2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self.footerView addSubview:line];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(((self.footerView.width - flagW)/2)+flagW, VH + 15, (self.footerView.width - flagW)/2, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self.footerView addSubview:line2];
    
    VH = VH + 30 + 50;
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake(5, VH, self.view.frame.size.width-10, actionH)];
    actionView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:actionView];
    
    UILabel *actionHead = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    actionHead.backgroundColor = [UIColor whiteColor];
    actionHead.font = [UIFont systemFontOfSize:13];
    actionHead.textColor = [UIColor grayColor];
    actionHead.text = @"常用功能";
    [actionView addSubview:actionHead];
    
    NSString *fileExt = self.file.filePath.pathExtension;
    NSMutableDictionary *items = [[NSMutableDictionary alloc]init];
    [items setObject:ProgramName_ShareFile forKey:ProgramName_ShareFile];
    [items setObject:ProgramName_WordConvertPDF forKey:ProgramName_WordConvertPDF];
    [items setObject:ProgramName_WordConvertOFD forKey:ProgramName_WordConvertOFD];
    
    SmallProgramCollectionView *actionMenu = [[SmallProgramCollectionView alloc]initWithFrame:CGRectMake(5, 35, self.view.frame.size.width-20, 70)];
    actionMenu.backgroundColor = [UIColor whiteColor];
    [actionMenu loadProgramData:items withFileExt:fileExt];
    [actionView addSubview:actionMenu];
    [self.footerView addSubview:actionView];
    actionMenu.itemClicked = ^(NSString* programeName){
        [self convertFile:programeName];
    };
    
    VH = VH + actionH + 20;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(5, VH, self.view.frame.size.width - 10, 300)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:contentView];
    [self.contentView addFooterView:self.footerView];
    
    self.expressView = [[CSLaunchView alloc]initWithFrame:contentView.bounds];
    [self.expressView showIn:contentView atRootController:self];
}
- (void)convertFile:(NSString*)programeName
{
    NSString *fileExt = @"pdf";
    if ([programeName isEqualToString:ProgramName_WordConvertOFD]) {
        fileExt = OFDFileExt;
    }else if([programeName isEqualToString:ProgramName_WordConvertPDF]){
        fileExt = PDFFileExt;
    }else if([programeName isEqualToString:ProgramName_ShareFile]){
        [self share:self.file.filePath];
    }
    NSString *fileName = [[[[[self.file.filePath.lastPathComponent componentsSeparatedByString:@"#"] lastObject] componentsSeparatedByString:@"."]firstObject] stringByAppendingFormat:@"%@", fileExt];
    NSString *filePath = [DJFileManager pathInOFDFloderDirectoryWithFileName:fileName];
    [self.contentView saveToFile:filePath];
    ShowMessage(@"", @"文件转换成功，在主页中可以查看", self);
}
- (void)share:(NSString*)filePath
{
    NSURL*fileURL = [[NSURL alloc]initFileURLWithPath:self.file.filePath];
    [CSShareManger shareActivityController:self withFile:fileURL];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadSubview
{
    _mainView = [[WKWebView alloc] initWithFrame:CGRectMake(25, 20, self.view.frame.size.width - 50, self.view.frame.size.height - 120) configuration:[[WKWebViewConfiguration alloc] init]];
    NSURL *fileURL = [NSURL fileURLWithPath:self.file.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [_mainView loadRequest:request];
    [self.view addSubview:_mainView];
}
- (void)dealloc{
    _mainView = nil;
}
@end
