//
//  DJFileTableView.h
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"

NS_ASSUME_NONNULL_BEGIN

@class DJFileTableView;

@protocol DJFileTableViewDelegate <NSObject>
@optional
//点击cell
- (void)fileTableView:(DJFileTableView *)tabelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(DJFileDocument *)fileModel;
//点击文件操作
- (void)clickedOperationWithModel:(DJFileDocument *)fileModel;

- (CGFloat)DJFileTableView:(DJFileTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)DJFileTableView:(DJFileTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView*)DJFileTableView:(DJFileTableView *)tableView viewForFooterInSection:(NSInteger)section;
- (UIView*)DJFileTableView:(DJFileTableView *)tableView viewForHeaderInSection:(NSInteger)section;
@end
@interface DJFileTableView : UIView
@property (nonatomic,strong) NSMutableArray <DJFileDocument *>* fileTableDataArr;
@property (nonatomic,weak) id <DJFileTableViewDelegate>fileTableViewDelegate;
@end

NS_ASSUME_NONNULL_END
