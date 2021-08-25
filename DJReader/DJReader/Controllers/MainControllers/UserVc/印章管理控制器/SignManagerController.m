//
//  SignManagerController.m
//  DJReader
//
//  Created by Andersen on 2020/8/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SignManagerController.h"
#import "CSSignCell.h"
#import <CoreData/CoreData.h>
#import "DJReader+CoreDataModel.h"
#import "CSCoreDataManager.h"
#import "CSSnowIDFactory.h"
#import "DrawController.h"
#import "SignSelector.h"
#import "DJReadNetManager.h"

@interface SignManagerController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,SignSelectorDelegate>
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic,strong) UIButton *createSeal;
@property (nonatomic,strong) NSMutableArray *units;
@property (nonatomic,strong) SignSelector *signSelector;
@end

@implementation SignManagerController
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _signSelector = [[SignSelector alloc]initWithFrame:self.view.bounds];
    _signSelector.curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _signSelector.selectorDelegate = self;
    
    [self.view addSubview:_signSelector];
    self.title = @"签名管理";
    self.view.backgroundColor = CSBackgroundColor;
    [self loadNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.signSelector reloadSignSelector];
}
- (void)selector:(id)selector didSelected:(DJSignSeal *)signSeal
{
    UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSeal:signSeal.sealId];
    }];
    UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    addActionsToTarget(self, @[action_01,action_02]);
}
- (void)deleteSeal:(NSString*)sealID
{
    [DJReadNetShare deleteSeal:sealID complete:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            showAlert(@"删除成功", self);
            [self.signSelector reloadSignSelector];
        }
    }];
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
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSealAction:(UIButton*)sender
{
    DrawController *dvc = [[DrawController alloc]init];
    dvc.modalPresentationStyle = 0;
    [self presentViewController:dvc animated:YES completion:nil];
}

@end
