//
//  DJFileTableView.m
//  文件操作
//
//  Created by liugang on 2020/3/12.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "DJFolderTableView.h"
#import "DJFolderCell.h"


static NSString *cellId = @"cellId";
@interface DJFolderTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * foderTableView;
@end

@implementation DJFolderTableView
- (instancetype)init{
    if (self = [super init]) {
        [self initTableView:CGRectNull];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initTableView:frame];
    }
    
    return self;
}

-(void)initTableView:(CGRect)frame{
    self.foderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height) style:UITableViewStyleGrouped];
    [self addSubview:_foderTableView];
    _foderTableView.backgroundColor = CSBackgroundColor;
    _foderTableView.estimatedRowHeight = 0.01;
    _foderTableView.estimatedSectionFooterHeight = 0.01;
    _foderTableView.estimatedSectionHeaderHeight = 0.01;
    _foderTableView.dataSource = self;
    _foderTableView.delegate = self;
    _foderTableView.rowHeight = 80;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
    [_foderTableView addGestureRecognizer:longpress];
}

#pragma mark - 单元格移动 -
- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)longPressGesture;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPressGesture locationInView:_foderTableView];
    NSIndexPath *indexPath = [_foderTableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint point = [longPressGesture locationInView:_foderTableView];
            NSIndexPath *currentIndexPath = [_foderTableView indexPathForRowAtPoint:point]; // 获取cell上长按
            sourceIndexPath = currentIndexPath;
                 UITableViewCell *cell = [_foderTableView cellForRowAtIndexPath:indexPath];
                 snapshot = [self customSnapshoFromView:cell];
                 __block CGPoint center = cell.center;
                 snapshot.center = center;
                 snapshot.alpha = 0.0;
                 [_foderTableView addSubview:snapshot];
                 [UIView animateWithDuration:0.25 animations:^{
                     center.y = location.y;
                     snapshot.center = center;
                     snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     snapshot.alpha = 0.98;
                     cell.alpha = 0.0f;
                 } completion:^(BOOL finished) {
                     cell.hidden = YES;
                 }];
            }
        case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    //数据交换
                    [_dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    //UI交换
                    [_foderTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    sourceIndexPath = indexPath;
                }
                break;
            }
        case UIGestureRecognizerStateEnded: {
                 [_foderTableView reloadData];
            }
        default: {
                // Clean up.
                UITableViewCell *cell = [_foderTableView cellForRowAtIndexPath:sourceIndexPath];
                [UIView animateWithDuration:0.25 animations:^{
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    cell.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
                sourceIndexPath = nil;
                break;
            }
        }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIView *snapshot = nil;
    snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
- (UIView *)customSnapShortFromViewEx:(UIView *)inputView
{
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

#pragma mark - Folder操作 -
//新建文件夹
- (void)newFolder:(NSString *)name{
    //[_dataArr addObject:name];
    [_foderTableView reloadData];
}
//修改文件夹名称
-(void)folderRename:(int)row newName:(NSString *)name{
   //  [_dataArr replaceObjectAtIndex:row withObject:name];
     [_foderTableView reloadData];
}

//删除某个文件夹
-(void)removeOneFolder:(int)row{
  //   [_dataArr removeObjectAtIndex:row];
     [_foderTableView reloadData];
}

#pragma mark - tableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.folderDelegate && [self.folderDelegate respondsToSelector:@selector(DJFolderTableView:heightForFooterInSection:)]) {
        return [self.folderDelegate DJFolderTableView:self heightForFooterInSection:section];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.folderDelegate && [self.folderDelegate respondsToSelector:@selector(DJFolderTableView:heightForHeaderInSection:)]) {
        return [self.folderDelegate DJFolderTableView:self heightForHeaderInSection:section];
    }else{
        return 0;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.folderDelegate && [self.folderDelegate respondsToSelector:@selector(DJFolderTableView:viewForFooterInSection:)])
        return [self.folderDelegate DJFolderTableView:self viewForFooterInSection:section];
    else
        return nil;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.folderDelegate && [self.folderDelegate respondsToSelector:@selector(DJFolderTableView:viewForHeaderInSection:)])
        return [self.folderDelegate DJFolderTableView:self viewForHeaderInSection:section];
    else
        return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DJFolderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setDJFolderCellData:_dataArr[indexPath.row]];
    __block DJFolderTableView *strongSelf = self;
    //点击功能
    [cell setFolderOperation:^{
        NSLog(@"dianji == %ld name == %@",indexPath.row,strongSelf.dataArr[indexPath.row]);
        if (strongSelf.folderDelegate && [strongSelf.folderDelegate respondsToSelector:@selector(clickFolderOperation:indexPath:name:)])
            [strongSelf.folderDelegate clickFolderOperation:strongSelf indexPath:indexPath name:strongSelf.dataArr[indexPath.row].name];
        }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80.0;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.folderDelegate && [self.folderDelegate respondsToSelector:@selector(fileTableListView:didSelectRowAtIndexPath:)])
         [self.folderDelegate fileTableListView:self didSelectRowAtIndexPath:indexPath];
}


#pragma mark - Data操作 -

- (NSArray <DJFloder *>*)dataArr{

    if (!_dataArr) {
        
        NSMutableArray *nameArr = [[NSMutableArray alloc]init];

        for (DJFloder *floder in _dataArr) {
            [nameArr addObject:floder.name];
        }
        _dataArr = nameArr;
    }
    NSLog(@"okok == %@",_dataArr);
    return _dataArr;
}




@end
