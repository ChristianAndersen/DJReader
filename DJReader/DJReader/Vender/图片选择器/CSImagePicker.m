//
//  CSImagePicker.m
//  DJReader
//
//  Created by Andersen on 2021/1/6.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "CSImagePicker.h"
#import "CSImagePickerModel.h"
#import "CSImagePickerCell.h"
#import "CSIMagePickerResultVC.h"
#import "CSSheetManager.h"
#import <DJContents/DJContentView.h>
#import <Photos/Photos.h>


@interface CSImagePicker ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *selectItems;
@end

@implementation CSImagePicker
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"预览";
    [self loadSubviews];
    [self loadImages];
}
- (void)loadSubviews
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
    
    UIButton *selectAll = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:selectAll];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)import
{
    NSMutableArray *saveImages = [[NSMutableArray alloc]init];
    for (NSNumber *modelNum in self.selectItems) {
        CSImagePickerModel *model = [self.items objectAtIndex:modelNum.intValue];
        [saveImages addObject:model.imagePath];
    }
    if (self.imageSelected) {
        self.imageSelected(saveImages);
        [self back];
    }
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)selectAll
{
    self.selectItems = [[NSMutableArray alloc]init];
    for (int i = 0;i<self.items.count;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.selectItems addObject:@(i)];
        CSImagePickerCell *cell = (CSImagePickerCell*)[self.albumCollectionView cellForItemAtIndexPath:indexPath];
        cell.isSelect = YES;
    }
    [self.selectItems removeAllObjects];
}
- (UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 2.f;
        layout.headerReferenceSize = CGSizeMake(self.view.width, 20);
        
        _albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        _albumCollectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _albumCollectionView.scrollEnabled = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        [_albumCollectionView registerClass:[CSImagePickerCell class] forCellWithReuseIdentifier:@"CSImagePickerCell"];
        [self.view addSubview:_albumCollectionView];

        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
        _albumCollectionView.userInteractionEnabled = YES;
        [_albumCollectionView addGestureRecognizer:longPressGesture];
        
        UIButton *import =({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor systemBlueColor];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            btn.frame = CGRectMake(self.view.width/6, self.view.height - 120, self.view.width*4/6, 40);
            if (self.importType == ImportTypeImages){
                [btn setTitle:@"导出" forState:UIControlStateNormal];
            }else if(self.importType == ImportTypeLongImage){
                [btn setTitle:@"生成" forState:UIControlStateNormal];
            }
            [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(import) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn;
        });
        [self.view addSubview:import];
    }
    return _albumCollectionView;
}
- (void)moveAction:(UILongPressGestureRecognizer *)longGes
{
    if (longGes.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *selectPath = [self.albumCollectionView indexPathForItemAtPoint:[longGes locationInView:longGes.view]];
        //CSImagePickerCell *cell = (CSImagePickerCell *)[self.albumCollectionView cellForItemAtIndexPath:selectPath];
        [self.albumCollectionView beginInteractiveMovementForItemAtIndexPath:selectPath];
    }else if (longGes.state == UIGestureRecognizerStateChanged) {
        [self.albumCollectionView updateInteractiveMovementTargetPosition:[longGes locationInView:longGes.view]];
    }else if (longGes.state == UIGestureRecognizerStateEnded) {
        [self.albumCollectionView endInteractiveMovement];
    }else {
        [self.albumCollectionView cancelInteractiveMovement];
    }
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSImagePickerCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSImagePickerCell" forIndexPath:indexPath];
    CSImagePickerModel *model = self.items[indexPath.row];
    cell.row = indexPath.row + 1;
    cell.model = model;
    cell.isSelect = [self.selectItems containsObject:@(indexPath.row)];
    
    @WeakObj(self);
    __weak typeof(cell) weakCell = cell;
    cell.action = ^{
        if ([weakself.selectItems containsObject:@(indexPath.row)]) {
            [weakself.selectItems removeObject:@(indexPath.row)];
            weakCell.isSelect = NO;
        }else{
            [weakself.selectItems addObject:@(indexPath.row)];
            weakCell.isSelect = YES;
        }
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    CSImagePickerCell*cell = (CSImagePickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([weakSelf.selectItems containsObject:@(indexPath.row)]) {
        [weakSelf.selectItems removeObject:@(indexPath.row)];
        cell.isSelect = NO;
    }else{
        [weakSelf.selectItems addObject:@(indexPath.row)];
        cell.isSelect = YES;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.width - 20.f) / 4.f, (self.view.width - 20.f)*1.5 / 4.f);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *reloadIndexPaths = [NSMutableArray new];
    if (sourceIndexPath.item < destinationIndexPath.item) {
        for (int i = (int)sourceIndexPath.item; i<=destinationIndexPath.item; i++) {
            NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];
            [reloadIndexPaths addObject:index];
        }
    }else{
        for (int i = (int)destinationIndexPath.item; i<=sourceIndexPath.item; i++) {
            NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];
            [reloadIndexPaths addObject:index];
        }
    }
    id obj = self.items[sourceIndexPath.item];
    [self.items removeObjectAtIndex:sourceIndexPath.item];
    [self.items insertObject:obj atIndex:destinationIndexPath.item];
    [self.albumCollectionView reloadItemsAtIndexPaths:reloadIndexPaths];
}
- (void)loadImages
{
    [CSSheetManager showHud:@"正在准备图片" atView:self.view];
    DJContentView *contentView;
    if ([_fileModel.fileExt isEqualToString:@"pdf"]) {
        contentView = [[DJContentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width) pdfFilePath:_fileModel.filePath];
    }else if([_fileModel.fileExt isEqualToString:@"aip"]){
        contentView = [[DJContentView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width) aipFilePath:_fileModel.filePath];
    }else if([_fileModel.fileExt isEqualToString:@"ofd"]){
        contentView = [[DJContentView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width) ofdFilePath:_fileModel.filePath complete:nil];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *imagePaths = [contentView getFilesImage:2.0];
        self.selectItems = [[NSMutableArray alloc]init];
        self.items = [[NSMutableArray alloc]init];
        for (int i = 0; i<imagePaths.count; i++) {
            CSImagePickerModel *model = [[CSImagePickerModel alloc]init];
            model.imagePath = [imagePaths objectAtIndex:i];
            [self.items addObject:model];
            [self.selectItems addObject:[NSNumber numberWithInt:i]];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self.albumCollectionView reloadData];
            [CSSheetManager hiddenHud];
        });
    });
}
@end
