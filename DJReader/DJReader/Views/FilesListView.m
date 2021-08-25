//
//  FilesListView.m
//  DJReader
//
//  Created by Andersen on 2020/3/6.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "FilesListView.h"
#import "FileEditorController.h"
#import "CSTabBarMainController.h"

@interface FilesListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *filesList;

@end

@implementation FilesListView
- (instancetype)init{
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    
    return self;
}

- (void)initValues{
    
}

- (void)initSubViews{
    _filesList = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    _filesList.delegate = self;
    _filesList.dataSource = self;
    _filesList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_filesList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FileCell_identficer"];
    cell.textLabel.text = @"文件";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.fileDelegate && [self.fileDelegate respondsToSelector:@selector(filesListView:didSelectRowAtIndexPath:)]) {
        [self.fileDelegate filesListView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
