//
//  CSLandSpaceColorSeletor.m
//  DJReader
//
//  Created by Andersen on 2020/3/25.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSLandSpaceColorSeletor.h"
#import "ColorUnit.h"
#import "CSColorCell.h"
#import "CSColorSelectorReusableView.h"

@interface CSLandSpaceColorSeletor()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *colorSelector;
@property (nonatomic,strong)NSMutableArray *colorUnits;
@end

@implementation CSLandSpaceColorSeletor

- (instancetype)initWithPreference:(UserPreference *)preference
{
    if (self = [super init]) {
        self.preference = preference;
        self.colorUnits = preference.colorUnits;
        [self loadSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [self loadSubviews];
}
- (void)loadSubviews
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;//item 横向距离
    
    CGFloat itemW = self.height/4;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(self.height/4, 30, self.height/4, 30);//shezhi
    layout.headerReferenceSize = CGSizeMake(self.width, 30);
    //设置分区的头部视图和尾视图，是否始终固定在屏幕上边和下边
    layout.sectionHeadersPinToVisibleBounds = YES;
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *colorView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    colorView.backgroundColor = [UIColor clearColor];
    colorView.showsVerticalScrollIndicator = NO;//显示滚动条
    colorView.scrollEnabled = YES;
    colorView.delegate = self;
    colorView.dataSource = self;
    
    [self addSubview:colorView];
    _colorSelector = colorView;
    
    [_colorSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [_colorSelector registerClass:[CSColorCell class] forCellWithReuseIdentifier:@"CSColorCell"];
    [_colorSelector registerClass:[CSColorSelectorReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSColorSelectorReusableView"];
}

#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colorUnits.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSColorCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSColorCell" forIndexPath:indexPath];
    cell.unit = [_colorUnits objectAtIndex:indexPath.row];
    if (indexPath != _curIndexPath) {
        [cell setItemSelected:NO];
    }else{
        [cell setItemSelected:YES];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSColorSelectorReusableView" forIndexPath:indexPath];
    
    if (indexPath.section == 0 && [kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        title.font = [UIFont systemFontOfSize:10];
        title.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        title.text = @"颜色";
        [headView addSubview:title];
    }
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_curIndexPath == indexPath) return;
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    CSColorCell *curCell = (CSColorCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CSColorCell *prvCell = (CSColorCell*)[collectionView cellForItemAtIndexPath:_curIndexPath];
    _curIndexPath = indexPath;
    [curCell setItemSelected:YES];
    [prvCell setItemSelected:NO];
    
    self.preference.colorUnit = [self.colorUnits objectAtIndex:indexPath.row];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(colorSelector:colorUnit:)]) {
        [self.selectorDelegate colorSelector:self colorUnit:[self.colorUnits objectAtIndex:indexPath.row]];
    }
}
@end
