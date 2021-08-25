//
//  CSTextFontTypeSeletor.m
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSTextFontTypeSeletor.h"
#import "CSFontTypeCell.h"
#import "CSColorSelectorReusableView.h"
@interface CSTextFontTypeSeletor()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *fontTypeSelector;
@property (nonatomic,strong)NSArray *fontsName;
@end

@implementation CSTextFontTypeSeletor

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame fonts:(NSArray*)fontsName
{
    if (self = [super initWithFrame:frame]) {
        _fontsName = fontsName;
    }
    return self;
}
- (void)layoutSubviews{
    [self loadSubviews];
}
- (void)loadSubviews
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;//item 横向距离
    
    CGFloat itemW = self.height/2;
    layout.itemSize = CGSizeMake(itemW*2, itemW);
    layout.sectionInset = UIEdgeInsetsMake(self.height/4, 0, self.height/4, 0);//shezhi
    layout.headerReferenceSize = CGSizeMake(self.width, 30);
    //设置分区的头部视图和尾视图，是否始终固定在屏幕上边和下边
    layout.sectionHeadersPinToVisibleBounds = YES;
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *fontTypeSelector = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    fontTypeSelector.backgroundColor = [UIColor clearColor];
    fontTypeSelector.showsVerticalScrollIndicator = NO;//显示滚动条
    fontTypeSelector.showsHorizontalScrollIndicator = NO;
    fontTypeSelector.scrollEnabled = YES;
    fontTypeSelector.delegate = self;
    fontTypeSelector.dataSource = self;
    _fontTypeSelector = fontTypeSelector;
    [self addSubview:_fontTypeSelector];
    
    [_fontTypeSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [_fontTypeSelector registerClass:[CSFontTypeCell class] forCellWithReuseIdentifier:@"CSFontTypeCell"];
    [_fontTypeSelector registerClass:[CSColorSelectorReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSColorSelectorReusableView"];
}

#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fontsName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSFontTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSFontTypeCell" forIndexPath:indexPath];
    [cell setFontName:[self.fontsName objectAtIndex:indexPath.row]];
    
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
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CSFontTypeCell *curCell = (CSFontTypeCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CSFontTypeCell *prvCell = (CSFontTypeCell*)[collectionView cellForItemAtIndexPath:_curIndexPath];
    _curIndexPath = indexPath;
    [curCell setItemSelected:YES];
    [prvCell setItemSelected:NO];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(fontTypeSelector:indexPath:)] )
    {
        [self.selectorDelegate fontTypeSelector:self indexPath:indexPath];
    }
}

@end
