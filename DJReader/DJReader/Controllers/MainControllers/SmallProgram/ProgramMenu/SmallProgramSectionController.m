//
//  SmallProgramSectionController.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramSectionController.h"
#import "SmallProgramIconView.h"


@interface SmallProgramSectionController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *programMenu;
@property (nonatomic,strong)UICollectionViewFlowLayout *programMenuLayout;
@end

@implementation SmallProgramSectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
}
- (UICollectionView*)programMenu
{
    if (!_programMenu) {
        CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _programMenu = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:self.programMenuLayout];
        _programMenu.delegate = self;
        _programMenu.dataSource = self;
        _programMenu.backgroundColor = [UIColor whiteColor];
        _programMenu.scrollEnabled = YES;
        _programMenu.alwaysBounceVertical = YES;
        [_programMenu registerClass:[SmallProgramIconView class] forCellWithReuseIdentifier:@"SmallProgramIconView"];
    }
    return _programMenu;
}
- (UICollectionViewFlowLayout*)programMenuLayout
{
    if (!_programMenuLayout) {
        _programMenuLayout = [[UICollectionViewFlowLayout alloc]init];
        _programMenuLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _programMenuLayout.minimumLineSpacing = 5.f;
        _programMenuLayout.minimumInteritemSpacing = 5.f;
    }
    return _programMenuLayout;
}
- (void)loadSubView
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
    [self.view addSubview:self.programMenu];
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.programs.count;
}
//点击签名会向文件载入笔迹
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallProgramIconView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallProgramIconView" forIndexPath:indexPath];
    cell.model = [self.programs objectAtIndex:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallProgramModel *programModel = [self.programs objectAtIndex:indexPath.row];
    NSString *programName = programModel.programName;
    NSString *programSection = programModel.programSection;
    launchProgram(programName,programSection);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.width/5.0, self.view.width/5.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
