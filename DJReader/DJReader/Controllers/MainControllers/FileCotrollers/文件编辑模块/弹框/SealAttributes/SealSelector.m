//
//  SealSelector.m
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SealSelector.h"
#import "CSSealCell.h"
#import <CoreData/CoreData.h>
#import "DJReader+CoreDataModel.h"
#import "CSCoreDataManager.h"
#import "CSSnowIDFactory.h"
#import "DrawController.h"
#import "CSSealSeletorReusableView.h"
#import "DJReadNetManager.h"
#import <MJExtension.h>

@interface SealSelector()<NSFetchedResultsControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *sealSelector;
@property (nonatomic,strong)NSMutableArray *seals;
@property (nonatomic,strong)NSMutableArray *units;

@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property(nonatomic,strong)UIButton *createSeal;
@end

@implementation SealSelector
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self createDefaultSeal];
    }
    return self;
}

- (void)loadSubviews
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;//item 横向距离
    
    CGFloat itemW = 120;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(15, 45, 35, 45);//shezhi
    
    layout.headerReferenceSize = CGSizeMake(self.width, 30);
    layout.footerReferenceSize = CGSizeMake(self.width, 30);
    //设置分区的头部视图和尾视图，是否始终固定在屏幕上边和下边
    layout.sectionHeadersPinToVisibleBounds = YES;
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *sealSelector = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    sealSelector.backgroundColor = CSWhiteColor;
    sealSelector.showsVerticalScrollIndicator = NO;//显示滚动条
    sealSelector.scrollEnabled = YES;
    sealSelector.delegate = self;
    sealSelector.dataSource = self;
    
    [self addSubview:sealSelector];
    _sealSelector = sealSelector;
    
    [_sealSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [_sealSelector registerClass:[CSSealCell class] forCellWithReuseIdentifier:@"CSSealCell"];
    [_sealSelector registerClass:[CSSealSeletorReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSSealSeletorReusableView"];
}

- (void)createDefaultSeal
{
    _seals = [NSMutableArray new];
    NSString *sealPath = [[NSBundle mainBundle]pathForResource:@"演示章文件" ofType:@"sel"];
    UIImage *sealImage = [UIImage imageNamed:@"演示章图片.gif"];
    NSData *imageData = UIImagePNGRepresentation(sealImage);
    NSData *sealData = [[NSData alloc]initWithContentsOfFile:sealPath];
    [sealData writeToFile:[DJFileManager pathInUserDirectoryWithFileName:@"演示章文件.sel"] atomically:YES];
    NSString *imgPreview = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *sealBase64 = [sealData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    DJSignSeal *defaultSeal = [[DJSignSeal alloc]init];
    defaultSeal.sealName = @"点聚演示章";
    defaultSeal.sealType = @"1";
    defaultSeal.path = [DJFileManager pathInUserDirectoryWithFileName:@"演示章文件.sel"];
    defaultSeal.imgPreview = imgPreview;
    defaultSeal.sealData = sealBase64;
    [_seals addObject:defaultSeal];
    [self.sealSelector reloadData];
}
- (void)loadSeal
{
    self.seals = [NSMutableArray new];
    DJReadUser *user = [DJReadManager shareManager].loginUser;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSString *openid = user.openid;
    NSString *phonenum = user.uphone;
    
    [params setValue:openid forKey:@"openid"];
    [params setValue:phonenum forKey:@"mobile"];
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_QuerySeal parameters:params reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            self.seals = [DJSignSeal mj_objectArrayWithKeyValuesArray:service.dataResult];
            [self.sealSelector reloadData];
        }
    }];
}
#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self createDefaultSeal];
    NSInteger count = self.seals.count;
    _units = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i++) {
        DJSignSeal *unit = [self.seals objectAtIndex:i];
        if ([unit.sealType intValue] == 1) {
            [_units addObject:unit];
        }
    }
    return _units.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSSealCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSSealCell" forIndexPath:indexPath];
    cell.unit = [_seals objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CSSealSeletorReusableView" forIndexPath:indexPath];
    
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(selector:didSelected:)]) {
        [self.selectorDelegate selector:self didSelected:[self.units objectAtIndex:indexPath.row]];
    }
}

@end
