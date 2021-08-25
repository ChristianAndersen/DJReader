//
//  SmallProgramCollectionView.m
//  DJReader
//
//  Created by Andersen on 2021/6/2.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramCollectionView.h"
#import "SmallProgramIconView.h"
#import "SmallProgramModel.h"
#import "SmallProgramHeadView.h"
#import "SmallProgramFooter.h"

@interface SmallProgramCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *programMenu;
@property (nonatomic,strong)UICollectionViewFlowLayout *programMenuLayout;
@property (nonatomic,strong)NSMutableArray *programSectionNames;
@property (nonatomic,strong)NSMutableDictionary *programList;
@end

@implementation SmallProgramCollectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (UICollectionView*)programMenu
{
    if (!_programMenu) {
        _programMenu = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.programMenuLayout];
        _programMenu.delegate = self;
        _programMenu.dataSource = self;
        _programMenu.backgroundColor = CSWhiteColor;
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
        _programMenuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _programMenuLayout.minimumLineSpacing = 20.f;
        _programMenuLayout.minimumInteritemSpacing = 1.f;
    }
    return _programMenuLayout;
}
- (void)loadProgramData:(NSMutableDictionary*)data withFileExt:(NSString*)fileExt
{
    _fileExt = fileExt;
    _programList = [[NSMutableDictionary alloc]init];
    _programSectionNames = [[NSMutableArray alloc]initWithArray:data.allKeys];
    for (NSString *sectionName in _programSectionNames) {
        SmallProgramModel *model = [[SmallProgramModel alloc]init];
        model.programName = sectionName;
        model.programHeader = [UIImage imageNamed:sectionName];
        [_programList setObject:model forKey:sectionName];
    }
    [self addSubview:self.programMenu];
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.programSectionNames.count;
}
//点击签名会向文件载入笔迹
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallProgramIconView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallProgramIconView" forIndexPath:indexPath];
    cell.model = [self getProgramModelWithSection:indexPath.section andRow:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallProgramModel *programModel = [self getProgramModelWithSection:indexPath.section andRow:indexPath.row];
    if (self.itemClicked) {
        self.itemClicked(programModel.programName);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 1, 10);
}
-(NSArray*)getProgramsWithSectionName:(NSString*)sectionName
{
    return [self.programList objectForKey:sectionName];
}
-(SmallProgramModel*)getProgramModelWithSection:(NSInteger)section andRow:(NSInteger)row
{
    NSString *key = [self.programSectionNames objectAtIndex:row];
    SmallProgramModel *model = [_programList objectForKey:key];
    return model;
}
@end
