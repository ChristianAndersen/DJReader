//
//  SmallProgramSearchController.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramSearchController.h"
#import "SmallProgramSearchCell.h"

@interface SmallProgramSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *resultView;
@property (nonatomic,strong)UITextField *searchView;
@property (nonatomic,strong)NSMutableArray *resultModels;
@end

@implementation SmallProgramSearchController
- (UITableView*)resultView
{
    if (!_resultView) {
        _resultView = [[UITableView alloc]initWithFrame:CGRectMake(0, k_NavBar_Height, self.view.width, self.view.height - k_NavBar_Height)];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        _resultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_resultView registerClass:[SmallProgramSearchCell class] forCellReuseIdentifier:@"SmallProgramSearchCell"];
    }
    return _resultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
}
- (void)loadSubView
{
    CGFloat btnWidth = 44;
    CGFloat btnheight = 44;
    CGFloat interval = 20;
    CGFloat HeadHeight = 30.0;
    
    UIView *nav =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, k_NavBar_Height)];
    nav.backgroundColor = [UIColor whiteColor];
    nav.layer.masksToBounds = YES;
    nav.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    nav.layer.borderWidth = 1.0;
    [self.view addSubview:nav];
    
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, k_NavBar_Height - btnheight, btnWidth, btnheight);
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10.0,7.0,10.0,7.0);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [nav addSubview:back];
    
    _searchView = [[UITextField alloc]initWithFrame:CGRectMake(44 ,k_NavBar_Height - HeadHeight - 7, self.view.width - 44*2, HeadHeight)];
    _searchView.placeholder = @"搜索文档";
    _searchView.delegate = self;
    _searchView.textAlignment = NSTextAlignmentCenter;
    _searchView.layer.masksToBounds = YES;
    _searchView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _searchView.layer.cornerRadius = HeadHeight/2;
    _searchView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView addTarget:self action:@selector(textvalueDidChange:) forControlEvents:UIControlEventEditingChanged];

    [nav addSubview:_searchView];

    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back.mas_right);
        make.right.equalTo(nav).offset(-back.width);
        make.centerY.equalTo(back);
        make.height.mas_equalTo(@(HeadHeight));
    }];
    [self.view addSubview:self.resultView];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (void)textvalueDidChange:(UITextField*)field
{
    self.resultModels = [NSMutableArray new];
    NSString *searchStr = field.text;
    for (SmallProgramModel *model in self.resourcePrograms) {
        if ([model.programName containsString:searchStr]) {
            [self.resultModels addObject:model];
        }
    }
    [self.resultView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultModels.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"SmallProgramSearchCell";
    SmallProgramSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SmallProgramSearchCell"];
    if (!cell) {
        cell = (SmallProgramSearchCell*)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.model = [self.resultModels objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        SmallProgramModel *model = [self.resultModels objectAtIndex:indexPath.row];
        launchProgram(model.programName,model.programSection);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
