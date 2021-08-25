//
//  FileMergeController.m
//  DJReader
//
//  Created by Andersen on 2021/6/7.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileMergeController.h"
#import "FileSelectCell.h"
#import <DJContents/DJContentView.h>
#import "DJFileManager.h"

@interface FileMergeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * filesTableView;
@end

@implementation FileMergeController
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}
- (void)mergeFile
{
    NSString * str = [NSString stringWithFormat:@"请输入文件名,否则不会进行文件合并"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alertController.textFields[0];
        if (name.text.length <=0) return;
        
        DJFileDocument *firstModel = self.fileModels.firstObject;
        NSString *fileName = [[NSString alloc]initWithFormat:@"%@.%@",name.text,firstModel.filePath.pathExtension];
        
        [DJContentView loginUser:@"Andersen" loadOtherNodes:YES];
        DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds aipFilePath:firstModel.filePath];
        for (int i = 1;i<self.fileModels.count;i++) {
            DJFileDocument *model = [self.fileModels objectAtIndex:i];
            [contentView mergeFile:model.filePath afterPage:contentView.pageCount];
        }
        [contentView saveToFile:[DJFileManager pathInOFDFloderDirectoryWithFileName:fileName]];
        ShowMessage(@"", @"合并成功，请去主页查看", self);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入文件名称";
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES  completion:nil];
    });
}
- (UITableView*)filesTableView
{
    if (!_filesTableView) {
        _filesTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _filesTableView.estimatedRowHeight = 0.01;
        _filesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _filesTableView.dataSource = self;
        _filesTableView.delegate = self;
        _filesTableView.tableHeaderView = [self tableViewHeader];
    }
    return _filesTableView;
}
- (void)loadSubViews
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    self.title = @"合并文档";
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
    
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sender setTitle:@"合并" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(mergeFile) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(20, self.view.height - k_TabBar_Height, self.view.width - 40, 40);
    sender.backgroundColor = [UIColor systemBlueColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3.0;
    [self.view addSubview:self.filesTableView];
    [self.view addSubview:sender];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FileSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[FileSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId isOperational:YES];
    }
    cell.model = [self.fileModels objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60.0;
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self)
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"移除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself deleteFile:indexPath];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        addTarget(self, action_01, action_02, @"是否从合并列表移除文件");
    }];
    NSArray *arr = @[deleteAction];
    return arr;
}

- (void)deleteFile:(NSIndexPath*)indexPath
{
    [self.fileModels removeObjectAtIndex:indexPath.row];
    [self.filesTableView reloadData];
}
- (UIView*)tableViewHeader
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    header.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.width - 40, 30)];
    lab.text = @"左滑文档从列表移除";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    lab.font = [UIFont systemFontOfSize:14];
    [header addSubview:lab];
    return header;
}

@end
