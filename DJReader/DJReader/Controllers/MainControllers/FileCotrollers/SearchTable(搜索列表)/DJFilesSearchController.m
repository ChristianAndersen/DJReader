//
//  DJFilesSearchController.m
//  DJReader
//
//  Created by liugang on 2020/3/26.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJFilesSearchController.h"
#import "DJResultsViewController.h"
#import "Masonry.h"

#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DJSearchHistories.plist"] // 搜索历史存储路径

@interface DJFilesSearchController ()<UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJResultsViewController *resultsController;
// 搜索历史
@property (nonatomic, strong) NSMutableArray *searchHistories;
// 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH
@property (nonatomic, copy) NSString *searchHistoriesCachePath;
// 搜索历史记录缓存数量，默认为10
@property (nonatomic, assign) NSUInteger searchHistoriesCount;

@end

@implementation DJFilesSearchController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.originController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.originController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchController.searchBar.placeholder = @"搜索内容";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
    self.searchController.delegate = self.originController;
    self.searchController.searchResultsUpdater = _resultsController;
    [self.searchController.searchBar sizeToFit];
    [self.view addSubview: self.tableView];
    self.tableView.tableHeaderView =  self.searchController.searchBar;
    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
}

- (DJResultsViewController *)resultsController{
    if (!_resultsController) {
        //搜索弹出来的的搜索控制器
        DJResultsViewController * resultsController   = [[DJResultsViewController alloc] init];
        resultsController.dataSource = self.dataArray;

        __weak typeof(self) _weakSelf = self;
          resultsController.didSelectText = ^(NSString *didSelectText) {
              
              if ([didSelectText isEqualToString:@"OFD格式"]) {
                  [self.searchController.searchBar resignFirstResponder];
              }
              else{
                  // 设置搜索信息
                  _weakSelf.searchController.searchBar.text = didSelectText;
                  // 缓存数据并且刷新界面
                  [_weakSelf saveSearchCacheAndRefreshView];
              }
          };
        
        
        _resultsController = resultsController;
    }
    return _resultsController;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height-self.searchController.searchBar.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
                 UILabel *footLabel = [[UILabel alloc] initWithFrame:footView.frame];
             
        
         if (@available(iOS 13.0, *)) {
               footLabel.textColor = [UIColor labelColor];
           } else {
              footLabel.textColor = [UIColor grayColor];
           }
             footLabel.font = [UIFont systemFontOfSize:13];
             footLabel.userInteractionEnabled = YES;
             footLabel.text = @"清空搜索记录";
             footLabel.textAlignment = NSTextAlignmentCenter;
             
             [footLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
             [footView addSubview:footLabel];

       _tableView.tableFooterView = footView;
    }
    return _tableView;
}


//进入搜索状态调用此方法
- (void)saveSearchCacheAndRefreshView
{
    UISearchBar *searchBar = self.searchController.searchBar;
    // 回收键盘
    [self.searchController.searchBar resignFirstResponder];
    // 先移除再刷新
    [self.searchHistories removeObject:searchBar.text];
    [self.searchHistories insertObject:searchBar.text atIndex:0];
    
    // 移除多余的缓存
    if (self.searchHistories.count > self.searchHistoriesCount) {
        // 移除最后一条缓存
        [self.searchHistories removeLastObject];
    }
    // 保存搜索信息
    BOOL arch = [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    if (arch) {
        [self.tableView reloadData];
    }
}

//点击单个清除
- (void)closeDidClick:(UIButton *)sender
{
    // 获取当前cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    // 移除搜索信息
    [self.searchHistories removeObject:cell.textLabel.text];
    // 保存搜索信息
    BOOL arch = [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
    if (self.searchHistories.count == 0) {
        self.tableView.tableFooterView.hidden = YES;
    }
    if (arch) {
        // 刷新
        [self.tableView reloadData];
    }
    
}

//点击清空历史按钮
- (void)emptySearchHistoryDidClick
{
    self.tableView.tableFooterView.hidden = YES;
    // 移除所有历史搜索
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    [self.tableView reloadData];
}

#pragma mark - 数据处理 -
- (NSArray *)dataArray{
    
    if (_dataArray == nil) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0 ; i< 5; i ++) {
            NSString *number = [NSString stringWithFormat:@"%d",i];
            [tempArray addObject:number];
        }
        _dataArray = tempArray.copy;
    }
    return _dataArray;
}

- (NSMutableArray *)searchHistories{
    if (!_searchHistories) {
        self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
        _searchHistoriesCount = 10;
    }
    return _searchHistories;
}

#pragma mark - Table view data source -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.tableFooterView.hidden = self.searchHistories.count == 0;
    return self.searchHistories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }
    cell.textLabel.text = self.searchHistories[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 缓存数据并且刷新界面
  //  [self saveSearchCacheAndRefreshView];
   
    // 取出选中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //数据上搜索框
    self.searchController.searchBar.text = cell.textLabel.text;
    //进入搜索状态（手动跳转）
    if (!self.searchController.isActive) {
    self.searchController.active = YES;
    }

 //   NSNotification * notice = [NSNotification notificationWithName:@"searchBarDidChange" object:nil userInfo:@{@"searchText":cell.textLabel.text}];
//    [[NSNotificationCenter defaultCenter]postNotification:notice];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchHistories.count != 0) {
    return @"搜索历史";
    }
    return @"无搜索历史";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
    
}

#pragma mark - 细节处理 -

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width+10;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    // 刷新
    self.searchHistories = nil;
    [self.tableView reloadData];
}


// 滚动时，回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
   // [self.searchController.searchBar resignFirstResponder];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    
    self.originController.tabBarHidden = YES;
    [self.searchController.searchBar becomeFirstResponder];
    
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    
    self.originController.tabBarHidden = NO;

}





@end
