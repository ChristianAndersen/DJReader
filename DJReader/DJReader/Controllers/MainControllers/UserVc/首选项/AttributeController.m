//
//  VersionController.m
//  DJReader
//
//  Created by Andersen on 2020/6/18.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define ReadLocation @"记录上次阅读位置"
#import "AttributeController.h"
#import "AttributeCell.h"

@interface AttributeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * mainView;
@property (nonatomic,strong) NSMutableDictionary *options;

@end

@implementation AttributeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self loadOptions];
    [self loadMainView];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UITableView *)mainView{
    if (_mainView == nil) {
        _mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _mainView.backgroundColor = CSBackgroundColor;
        _mainView.scrollEnabled = NO;
        _mainView.dataSource = self;
        _mainView.delegate = self;
    }
    return _mainView;
}
-(void)loadMainView{
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
- (void)loadOptions
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
    
    self.options = [[NSMutableDictionary alloc]init];
    NSString *key1 = [NSString stringWithFormat:@"%d",0];
    [self.options setObject:@[ReadLocation] forKey:key1];
}
#pragma mark - tableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.options.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)section];
    NSArray *optionValue =  [self.options objectForKey:key];
    return optionValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *optionValue = [self.options objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
    NSString *infoTitle = [optionValue objectAtIndex:indexPath.row];
    [self initCell:cell forInfoTitle:infoTitle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark - 登录退出
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    return back;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
- (void)initCell:(AttributeCell*)cell forInfoTitle:(NSString*)info
{
    cell.textLabel.textColor = CSTextColor;
    cell.textLabel.text = info;
}
@end
