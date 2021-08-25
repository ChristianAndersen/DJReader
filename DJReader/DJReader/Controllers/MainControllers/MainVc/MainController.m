//
//  FirstController.m
//  分栏控制器
//
//  Created by Andersen on 2019/7/24.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "MainController.h"
#import "CSCoreDataManager.h"
#import "DJReadNetManager.h"
#import "DJMainFileView.h"
#import "CSLoadingView.h"
#import "CSLaunchView.h"

@interface  MainController()<UIScrollViewDelegate>
@property (nonatomic,strong) DJMainFileView * fileListView;
@property (nonatomic,strong) CSLoadingView *loading;
@end

@implementation MainController
- (instancetype)initWithFrame:(CGRect)frame withHTML:(NSString *)html
{
    if (self) {
    }
    return self;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
// 支持横竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewAttributes];
    [self.view addSubview:self.fileListView.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readLocaFile) name:ChangeUserNotifitionName object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.originController.tabBar.hidden = NO;
    [self readLocaFile];
}
- (void)setViewAttributes
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = CSBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title  = @"点聚OFD";
}
- (void)writeGuideOFD
{
    NSString *guidePath = [[NSBundle mainBundle]pathForResource:@"点聚OFD使用指南" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:guidePath];
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES).lastObject stringByAppendingPathComponent:@"点聚OFD使用指南.pdf"];
    [data writeToFile:dirPath atomically:YES];
}
///根据文件名选择本地文件
- (void)readLocaFile
{
    NSString *diretory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSMutableDictionary *filePaths = [NSMutableDictionary dictionary];
    [[DJFileManager shareManager] readLocaFile:diretory writeTo:filePaths];
    for (NSString *sourcePath in filePaths.allValues) {//没有写进CoreData的文件写一遍
        [[CSCoreDataManager shareManager] writeSourceFile:sourcePath];
    }
    [self.fileListView reloadData];
}
- (DJMainFileView*)fileListView{
    if (!_fileListView) {
        _fileListView = [[DJMainFileView alloc]initWithFrame:self.view.frame];
        _fileListView.originController = self.originController;
        [self addChildViewController:_fileListView];
        [self.view addSubview:_fileListView.view];
            
        [self.fileListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.equalTo(self.view);
            make.left.width.equalTo(self.view);
        }];
    }
    return _fileListView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ChangeUserNotifitionName object:nil];
}
@end

