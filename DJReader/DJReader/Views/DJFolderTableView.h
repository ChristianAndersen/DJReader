//
//  DJFileTableView.h
//  文件操作
//
//  Created by liugang on 2020/3/12.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFloder.h"

NS_ASSUME_NONNULL_BEGIN
@class DJFolderTableView;
@protocol DJFolderTableViewDelegate <NSObject>
@optional
//点击cell
- (void)fileTableListView:(DJFolderTableView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//点击文件操作
- (void)clickFolderOperation:(DJFolderTableView *)listView indexPath:(NSIndexPath *)indexPath name:(NSString *)name;

- (CGFloat)DJFolderTableView:(DJFolderTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)DJFolderTableView:(DJFolderTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView*)DJFolderTableView:(DJFolderTableView *)tableView viewForFooterInSection:(NSInteger)section;
- (UIView*)DJFolderTableView:(DJFolderTableView *)tableView viewForHeaderInSection:(NSInteger)section;
@end


@interface DJFolderTableView : UIView
@property (nonatomic,weak)id <DJFolderTableViewDelegate>folderDelegate;
@property (nonatomic,retain)NSMutableArray<DJFloder *> * dataArr;

//新建文件夹
- (void)newFolder:(NSString *)name;
//修改文件夹名称
-(void)folderRename:(int)row newName:(NSString *)name;
//删除某个文件夹
-(void)removeOneFolder:(int)row;

@end

NS_ASSUME_NONNULL_END
