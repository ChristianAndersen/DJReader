//
//  DJFileTableView.m
//  文件操作
//
//  Created by liugang on 2020/3/16.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "DJFileTableView.h"
#import "DJFileTableViewCell.h"
#import "CSCoreDataManager.h"

static NSString *cellId = @"cellId";
@interface DJFileTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * filesTableView;
@end

@implementation DJFileTableView
- (instancetype)init{
    if (self = [super init]) {
        [self loadData];
        [self initTableView:CGRectNull];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self initTableView:frame];
    }
    return self;
}

-(void)loadData
{
    [_fileTableDataArr enumerateObjectsUsingBlock:^(DJFileDocument * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:obj.filePath];
        if (!data) {
            [[CSCoreDataManager shareManager] deleteFileToCoreData:obj];
        }
    }];
}

-(void)initTableView:(CGRect)frame{
        self.filesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height-frame.origin.y*2) style:UITableViewStyleGrouped];
        [self addSubview:_filesTableView];
        _filesTableView.estimatedRowHeight = 0.01;
        _filesTableView.estimatedSectionFooterHeight = 0.01;
        _filesTableView.estimatedSectionHeaderHeight = 0.01;
        _filesTableView.dataSource = self;
        _filesTableView.delegate = self;
        _filesTableView.rowHeight = 80;
    
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
        [_filesTableView addGestureRecognizer:longpress];
}



#pragma mark - 单元格移动 -

- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)longPressGesture;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPressGesture locationInView:_filesTableView];
    NSIndexPath *indexPath = [_filesTableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;

    switch (state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint point = [longPressGesture locationInView:_filesTableView];
            NSIndexPath *currentIndexPath = [_filesTableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
            NSLog(@"%ld",currentIndexPath.row);
            sourceIndexPath = currentIndexPath;
            UITableViewCell *cell = [_filesTableView cellForRowAtIndexPath:indexPath];
            snapshot = [self customSnapshoFromView:cell];
            __block CGPoint center = cell.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [_filesTableView addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                // Offset for gesture location.
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
                [_fileTableDataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [_filesTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
            break;
        }
             
        case UIGestureRecognizerStateEnded: {
            [_filesTableView reloadData];
        }
            
        default: {
            UITableViewCell *cell = [_filesTableView cellForRowAtIndexPath:sourceIndexPath];
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
    //系统的快照方法
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
  //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
}

#pragma mark - tableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(DJFileTableView:heightForFooterInSection:)]) {
        return [self.fileTableViewDelegate DJFileTableView:self heightForFooterInSection:section];
    }else{
        return 300;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(DJFileTableView:heightForHeaderInSection:)]) {
        return [self.fileTableViewDelegate DJFileTableView:self heightForHeaderInSection:section];
    }else{
        return 0.01;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(DJFileTableView:viewForFooterInSection:)]) {
        return [self.fileTableViewDelegate DJFileTableView:self viewForFooterInSection:section];
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(DJFileTableView:viewForHeaderInSection:)]) {
        return [self.fileTableViewDelegate DJFileTableView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //遍历数组 查看文件是否存在 不存在从数据库中删除
    return _fileTableDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[DJFileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId isOperational:YES];
    }
    __block DJFileTableView *strongSelf = self;
    
    [cell setFileExpandBtn:^(UIButton * _Nonnull expandBtn) {
        if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(clickedOperationWithModel:)])
        [self.fileTableViewDelegate clickedOperationWithModel:strongSelf.fileTableDataArr[indexPath.row]];
    }];

    //cell赋值
    [cell setDJFolderCellData:_fileTableDataArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80.0;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"name == %@",_fileTableDataArr[indexPath.row].name);
    
    if (self.fileTableViewDelegate && [self.fileTableViewDelegate respondsToSelector:@selector(fileTableView:didSelectRowAtIndexPath:withModel:)])
         [self.fileTableViewDelegate fileTableView:self didSelectRowAtIndexPath:indexPath withModel:_fileTableDataArr[indexPath.row]];
}

#pragma mark - Data操作 -
- (void)setFileTableDataArr:(NSMutableArray <DJFileDocument *>*)fileTableDataArr{
    _fileTableDataArr = fileTableDataArr;
    [_filesTableView reloadData];
}



@end
