//
//  FileSelectController.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileSelectController.h"
#import "FileSelectCell.h"
#import "CSCoreDataManager.h"
#import "CSImagePicker.h"
#import "CSIMagePickerResultVC.h"
#import "FileMergeController.h"
@interface FileSelectController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * filesTableView;
@property (nonatomic,strong)NSMutableArray *fileModels;
@property (nonatomic,strong)NSMutableDictionary *selectedModels;
@property (nonatomic,assign)NSInteger selectedNum;
@end

@implementation FileSelectController
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)complete
{
    NSMutableArray *selects = [[NSMutableArray alloc]init];
    NSArray *keys = self.selectedModels.allKeys;
    if (keys.count <= 1){
        showAlert(@"只有一个文件，不需要合并",self);
        return;
    }
    for(NSString *key in keys){
        NSIndexPath *indexPath = [NSString indexPathFromString:key];
        DJFileDocument *model = [self.fileModels objectAtIndex:indexPath.row];
        [selects addObject:model];
    }
    FileMergeController *mergeController = [[FileMergeController alloc]init];
    mergeController.modalPresentationStyle = 0;
    mergeController.fileModels = selects;
    [self.navigationController pushViewController:mergeController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择文件";
    self.selectedNum = 0;
    [self loadFileModel];
    [self loadSubViews];
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
- (void)loadFileModel
{
    _fileModels = [[NSMutableArray alloc]init];
    _selectedModels = [NSMutableDictionary new];
    NSArray * allModels = [[CSCoreDataManager shareManager] fetchAllFileFromCoreData];
    if (self.fileFilterCondition && ![self.fileFilterCondition isEqualToString:@"docx"] && ![self.fileFilterCondition isEqualToString:@"doc"]){
        for (DJFileDocument *model in allModels) {
            if ([[model.filePath pathExtension] isEqualToString:self.fileFilterCondition]) {
                [_fileModels addObject:model];
            }
        }
    }else if([self.fileFilterCondition isEqualToString:@"docx"]||[self.fileFilterCondition isEqualToString:@"doc"]){
        for (DJFileDocument *model in allModels) {
            if ([[model.filePath pathExtension] isEqualToString:@"doc"]||[[model.filePath pathExtension] isEqualToString:@"docx"]) {
                [_fileModels addObject:model];
            }
        }
    }else{
        for (DJFileDocument *model in allModels) {
            if ([[model.filePath pathExtension] isEqualToString:@"pdf"]||[[model.filePath pathExtension] isEqualToString:@"ofd"]||[[model.filePath pathExtension] isEqualToString:@"ofd"]) {
                [_fileModels addObject:model];
            }
        }
    }
}
- (UIView*)tableViewHeader
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    header.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.width - 40, 30)];
    lab.text = @"文件选择中";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    lab.font = [UIFont systemFontOfSize:14];
    [header addSubview:lab];
    return header;
}
- (void)loadSubViews
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
    [self.view addSubview:self.filesTableView];
    
    if (self.isMultiSelect) {
        UIButton *complete =({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
            btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
            btn;
        });
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:complete];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.view addSubview:complete];
    }
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
    cell.isMultiSelect = self.isMultiSelect;
    cell.model = [self.fileModels objectAtIndex:indexPath.row];
    NSNumber *num = [self.selectedModels objectForKey:[NSString stringFromIndexPath:indexPath]];
    [cell setSelectedNum:num.stringValue];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.isMultiSelect) {
        FileSelectCell *cell = (FileSelectCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSString *key = [NSString stringFromIndexPath:indexPath];
        NSNumber *curNum = [self.selectedModels objectForKey:key];
        
        if (!curNum) {
            curNum = [NSNumber numberWithUnsignedLong:self.selectedModels.allValues.count + 1];
            [self.selectedModels setValue:curNum forKey:key];
        }else{
            [self.selectedModels removeObjectForKey:key];
            NSArray *keys = self.selectedModels.allKeys;

            for (NSString *key in keys) {
                NSNumber *num = [self.selectedModels objectForKey:key];
                if (curNum.intValue < num.intValue)
                    num = [NSNumber numberWithInt:num.intValue - 1];
                [self.selectedModels setValue:num forKey:key];
            }
            [cell setSelectedNum:@""];
        }
        [self.filesTableView reloadData];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            self.fileSelectHander([self.fileModels objectAtIndex:indexPath.row]);
        }];
    }
}
@end

