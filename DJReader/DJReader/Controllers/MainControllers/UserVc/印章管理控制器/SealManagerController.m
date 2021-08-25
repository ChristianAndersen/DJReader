//
//  SealManagerController.m
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//
#import "SealManagerController.h"
#import "CSSealCell.h"
#import <CoreData/CoreData.h>
#import "DJReader+CoreDataModel.h"
#import "CSCoreDataManager.h"
#import "CSSnowIDFactory.h"
#import "DrawController.h"
#import "CSSealSeletorReusableView.h"
#import "SealSelector.h"

@interface SealManagerController ()
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic,strong)UICollectionView *sealSelector;
@property (nonatomic,strong)NSMutableArray *seals;
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,strong)UIButton *createSeal;
@property (nonatomic,strong)SealSelector *sealSelector2;
@end

@implementation SealManagerController
- (void)viewDidLoad {
    [super viewDidLoad];
    _sealSelector2 = [[SealSelector alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_sealSelector2];
    [self loadNav];
    self.title = @"印章管理";
    self.view.backgroundColor = CSBackgroundColor;
}
- (void)loadNav
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    CGFloat titleHeight = 24;
    
    _createSeal = [UIButton buttonWithType:UIButtonTypeCustom];
    _createSeal.frame = CGRectMake(0, 0, btnWidth, btnheight);
    [_createSeal setTitleColor:CSTextColor forState:UIControlStateNormal];
    _createSeal.titleLabel.font = [UIFont systemFontOfSize:14];
    [_createSeal addTarget:self action:@selector(createSealAction:) forControlEvents:UIControlEventTouchUpInside];
    _createSeal.titleLabel.textAlignment = NSTextAlignmentRight;
    [_createSeal setImage:[UIImage imageNamed:@"创建"] forState:UIControlStateNormal];
    _createSeal.imageEdgeInsets = UIEdgeInsetsMake((btnheight - titleHeight)/2, btnWidth - titleHeight, (btnheight - titleHeight)/2, 1.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_createSeal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, btnWidth, btnheight);
    [back setTitleColor:CSTextColor forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:14];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.titleLabel.textAlignment = NSTextAlignmentRight;
    [back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    back.imageEdgeInsets = UIEdgeInsetsMake((btnheight - titleHeight)/2, -10.0, (btnheight - titleHeight)/2, 64);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createSealAction:(UIButton*)sender
{
    DrawController *dvc = [[DrawController alloc]init];
    dvc.modalPresentationStyle = 0;
    [self presentViewController:dvc animated:YES completion:nil];
}
- (void)createDefaultSeal
{
    SealUnit *unit = [[CSCoreDataManager shareManager] fetchSealBySource:@"点聚OFD测试印章"];
    if (!unit) {
        unit = [[SealUnit alloc]init];
        unit.id = [CSSnowIDFactory shareFactory].nextID;
        unit.type = 1;
        unit.data = UIImagePNGRepresentation([UIImage imageNamed:@"defaultSeal.png"]);
        unit.create_time = [CSSnowIDFactory  getCurrentTimeDateIntValue];
        unit.update_time = unit.create_time;
        unit.uid = [CSCoreDataManager shareManager].user.id;
        unit.source = @"点聚OFD测试印章";
        [[CSCoreDataManager shareManager] writeSeal:unit];
        [self.sealSelector reloadData];
    }
}

@end
