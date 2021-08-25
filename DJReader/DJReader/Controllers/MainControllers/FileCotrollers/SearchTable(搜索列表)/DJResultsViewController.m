//
//  DJResultsViewController.m
//  DJReader
//
//  Created by liugang on 2020/3/26.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJResultsViewController.h"
#import <Masonry.h>
#import "DJFileTableViewCell.h"
#import "FileEditorController.h"
#import "CSCoreDataManager.h"
#import "DJFileDocument.h"

@interface DJResultsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray <DJFileDocument *>* searchDataSource; //搜索大数据
@end

@implementation DJResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_equalTo(-k_NavBar_Height);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
}

#pragma mark - 懒加载 -

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        //取消分割线
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"7777"]];
        _tableView.scrollEnabled = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)searchDataSource
{
    if (_searchDataSource == nil) {
        //cd
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}


#pragma mark - UISearchResultsUpdating -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    searchController.searchResultsController.view.hidden = NO;
   
    if([searchController.searchBar.text isEqual:@""]) {
         [self.searchDataSource removeAllObjects];
         [self.tableView reloadData];
         return;
    }
    
    [self.searchDataSource removeAllObjects];
    
    NSString * str = [NSString stringWithFormat:@"*%@*",searchController.searchBar.text];
   
     // 创建模糊查询条件。这里设置的带通配符的查询
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",str];
    NSSortDescriptor *descriptor;
    
     //CD查找
     self.searchDataSource = [[[CSCoreDataManager shareManager]fetchAllFileFromCoreData:predicate descriptors:descriptor] mutableCopy];
    

     [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //控制无数据时的展示图
    if (self.searchDataSource.count) {
          _tableView.backgroundView = nil;
      }else{
          _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"7777"]];
      }
    return self.searchDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DJFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" isOperational:NO];
    }
    //这里传model
    [cell setDJFolderCellData:self.searchDataSource[indexPath.row]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchDataSource.count != 0) {
        
        return @"搜索结果";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      // 取消选中
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      //搜索历史
      self.didSelectText(self.searchDataSource[indexPath.row].name);
      NSLog(@"点击搜索结果%@", self.searchDataSource[indexPath.row].filePath);
    
      FileEditorController *fileEditor = [[FileEditorController alloc]init];
      fileEditor.file = self.searchDataSource[indexPath.row];
      fileEditor.modalPresentationStyle = 0;
      [self presentViewController:fileEditor animated:YES completion:nil];
   
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
}




@end

