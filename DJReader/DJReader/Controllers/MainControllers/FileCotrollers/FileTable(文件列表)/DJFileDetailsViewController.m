//
//  DJFileDetailsViewController.m
//  DJReader
//
//  Created by liugang on 2020/3/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJFileDetailsViewController.h"
#import "HWPop.h"
#import "Masonry.h"

#define controlClearance 25
static NSString *cellId = @"cellId";

@interface DJFileDetailsViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView * fileImageView;//文件夹图标
@property (nonatomic,strong) UILabel * fileNameLabel;//文件名称
@property (nonatomic,strong) UILabel * fileCreationTimeLabel;//创建时间
@property (nonatomic,strong) UILabel * fileSizeLabel;//文件大小
@property (nonatomic,strong) UIImageView * dividerView;//分割线
@property (nonatomic,strong) UITableView * functionMenuTableView;//菜单列表

@property (nonatomic,strong) NSMutableArray * items;//功能表
@property (nonatomic,strong) NSMutableArray * itemsImages;//功能表图片
@end

@implementation DJFileDetailsViewController
- (instancetype)initWithItems:(NSMutableArray*)items andImages:(NSMutableArray*)itemsImage
{
    if (self = [super init]) {
        _items = items;
        _itemsImages = itemsImage;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    self.contentSizeInPop = CGSizeMake(CGRectGetWidth(screenFrame) - 20, CGRectGetHeight(screenFrame) * 0.45);
    [self reloadContent];
    [self setFunctionMenuTableView];
}
-(void)setFunctionMenuTableView{
    [self.functionMenuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dividerView.mas_bottom).mas_equalTo(controlClearance*0.3);
        make.left.bottom.equalTo(self.view).mas_offset(controlClearance);
        make.right.equalTo(self.view).mas_offset(-controlClearance);
    }];
}
- (void)itemClicked:(void(^)(NSString*title))clicked{
}
#pragma mark - setUI -
-(void)reloadContent{
    NSString * path = [_fileModel.filePath pathExtension];
    if(path && [path isEqualToString:@"aip"]) {
        self.fileImageView.image = [UIImage imageNamed:@"AIP格式"];
    }else if (path && [path isEqualToString:@"ofd"]) {
        self.fileImageView.image = [UIImage imageNamed:@"OFD格式"];
    }else if(path && [path isEqualToString:@"pdf"]){
        self.fileImageView.image = [UIImage imageNamed:@"PDF格式"];
    }else if(path && ([path isEqualToString:@"xlsx"]||[path isEqualToString:@"xls"])){
        self.fileImageView.image = [UIImage imageNamed:@"XLSX格式"];
    }else if(path && ([path isEqualToString:@"docx"]||[path isEqualToString:@"doc"])){
        self.fileImageView.image = [UIImage imageNamed:@"DOCX格式"];
    }else if(path && [path isEqualToString:@"ppt"]){
        self.fileImageView.image = [UIImage imageNamed:@"PPT格式"];
    }else{
        self.fileImageView.image = [UIImage imageNamed:@"文件格式未知"];
    }
    if (_fileModel.star) {
        [_items replaceObjectAtIndex:1 withObject:DeletedStar];
    }else{
        [_items replaceObjectAtIndex:1 withObject:AddStar];
    }
    
    self.fileNameLabel.text = _fileModel.name;
    self.fileCreationTimeLabel.text = [NSString stringWithFormat:@"%@",[NSString getDateStringWithTimeStr:_fileModel.create_time]];
    self.fileSizeLabel.text = [NSString getDataLengthWithLengStr:_fileModel.length];
    [self.functionMenuTableView reloadData];

    [self.fileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(controlClearance*1.5);
        make.leading.equalTo(self.view).offset(controlClearance*1.5);
        make.height.width.mas_equalTo(40);
    }];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImageView);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance);
    }];
    [self.fileCreationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fileImageView.mas_bottom);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance);
    }];
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileCreationTimeLabel.mas_top);
        make.leading.equalTo(self.fileCreationTimeLabel.mas_trailing).offset(controlClearance/2);
    }];
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImageView.mas_bottom).mas_offset(controlClearance);
        make.left.equalTo(self.view).mas_offset(controlClearance);
        make.right.equalTo(self.view).mas_offset(-controlClearance);
        make.height.mas_offset(1);
    }];
}

#pragma mark - tableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _items[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_itemsImages[indexPath.row]];
    cell.backgroundColor = [UIColor drakColor:DrakModeColor lightColor:LightModeColor];
    
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 50.0;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selected = _items[indexPath.row];
    if (self.seleted) {
        self.seleted(selected);
    }
}
#pragma mark - 懒加载 -
-(UITableView *)functionMenuTableView{
    if (!_functionMenuTableView) {
        _functionMenuTableView = [[UITableView alloc]init];
        _functionMenuTableView.estimatedRowHeight = 0.01;
        _functionMenuTableView.estimatedSectionFooterHeight = 0.01;
        _functionMenuTableView.estimatedSectionHeaderHeight = 0.01;
        //取消分割线
        _functionMenuTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _functionMenuTableView.dataSource = self;
        _functionMenuTableView.delegate = self;
        _functionMenuTableView.backgroundColor =[UIColor drakColor:DrakModeColor lightColor:LightModeColor];
        [self.view addSubview:_functionMenuTableView];
    }
    return _functionMenuTableView;
}

- (UIImageView *)fileImageView{
    if (!_fileImageView) {
        _fileImageView = [[UIImageView alloc]init];
        [self.view addSubview:_fileImageView];
    }
    return _fileImageView;
}
- (UILabel *)fileNameLabel{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc]init];
        [_fileNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:_fileNameLabel];
    }
    return _fileNameLabel;
}
- (UILabel *)fileCreationTimeLabel{
    if (!_fileCreationTimeLabel) {
        _fileCreationTimeLabel = [[UILabel alloc]init];
        [_fileCreationTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.view addSubview:_fileCreationTimeLabel];
    }
    return _fileCreationTimeLabel;
}
- (UILabel *)fileSizeLabel{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc]init];
        [_fileSizeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.view addSubview:_fileSizeLabel];
        
       
    }
    return _fileSizeLabel;
}
- (UIImageView *)dividerView{
    if (!_dividerView) {
        _dividerView = [[UIImageView alloc]init];
        _dividerView.backgroundColor = [UIColor grayColor];

        [self.view addSubview:_dividerView];
    }
    return _dividerView;
}

#pragma mark - data -
//数据
- (void)setFileModel:(DJFileDocument *)fileModel
{
    _fileModel = fileModel;
}
- (void)dealloc
{
    _seleted = nil;
}
@end
