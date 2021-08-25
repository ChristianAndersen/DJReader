//
//  UFIssueRowCell.m
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UFIssueRowCell.h"
#import "UFIssueReusableView.h"
#import "UFIssueFileItem.h"
#import "CSFunctions.h"
#define itemW 120
@interface UFIssueRowCell()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)NSMutableArray *files;
@property (nonatomic,assign)NSInteger maxCount;
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation UFIssueRowCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)setRow:(__kindof UFRow *)row
{
    UFIssueRow *cusRow = (UFIssueRow*)row;
    _files = cusRow.files;
    [super setRow:cusRow];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainview.frame = self.bounds;
}
- (void)setupConstraints {
    [super setupConstraints];
    [self loadmainView];
}
- (UIImagePickerController*)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    return _picker;
}
- (void)openPhotoAlbumAction
{
    BOOL isPicker = NO;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        isPicker = YES;
    }
    
    if (isPicker) {
        [RootController presentViewController:self.picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [RootController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)takePhotoAction
{
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [RootController presentViewController:self.picker animated:YES completion:nil];
}
#pragma PickerDeleagate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.files addObject:image];
    UFIssueRow *cusRow = (UFIssueRow*)self.row;
    [cusRow sendFiles];
    [self.mainview reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取图片
}
//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadmainView
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 2;//item 横向距离
    layout.itemSize = CGSizeMake(itemW,itemW);
    layout.sectionInset = UIEdgeInsetsMake(1.0, 10.0, 1.0, 10.0);
    //设置分区的头部视图和尾视图，是否始终固定在屏幕上边和下边
    layout.sectionHeadersPinToVisibleBounds = NO;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(self.width, 30);
    _mainview = ({
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.showsVerticalScrollIndicator = NO;
        collection.showsHorizontalScrollIndicator = NO;
        collection.scrollEnabled = YES;
        collection.backgroundColor = CSWhiteColor;
        collection;
    });
    [self addSubview:_mainview];
    [_mainview registerClass:[UFIssueFileItem class] forCellWithReuseIdentifier:@"UFIssueFileItem"];
    [_mainview registerClass:[UFIssueReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UFIssueReusableView"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_files.count == 3) {
        return 3;
    }else{
        return _files.count + 1;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UFIssueReusableView" forIndexPath:indexPath];

    if (indexPath.section == 0 && [kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        title.text = @"请选择文件";
        [headView addSubview:title];
    }
    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self);
    UFIssueFileItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UFIssueFileItem" forIndexPath:indexPath];
    if (self.files.count == 3) {
        [cell loadFileItem:[_files objectAtIndex:indexPath.row]];
        cell.imageDelete = ^{
            [self.files removeObjectAtIndex:indexPath.row];
            [weakself.mainview reloadData];
        };
    }else{
        if (indexPath.row == self.files.count) {
            ///添加照片
            [cell loadAddItem];
            cell.imageAdd = ^{
                [weakself addFileAction];
            };
        }else{
            [cell loadFileItem:[_files objectAtIndex:indexPath.row]];
            cell.imageDelete = ^{
                [self.files removeObjectAtIndex:indexPath.row];
                [weakself.mainview reloadData];
            };
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)addFileAction
{
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoAction];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoAlbumAction];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    addActionsToTarget(RootController, @[action1,action2,action3]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
