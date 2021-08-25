//
//  SignSelector.m
//  DJReader
//
//  Created by Andersen on 2020/3/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "SignSelector.h"
#import "CSSignCell.h"
#import <CoreData/CoreData.h>
#import "DJReader+CoreDataModel.h"
#import "CSCoreDataManager.h"
#import "CSSnowIDFactory.h"
#import "DJReadNetManager.h"
#import "DJSignSeal.h"
#import <MJExtension.h>
@interface SignSelector()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) UITableView *filesList;
@property (nonatomic,strong) NSMutableArray *units;
@property (nonatomic,strong) NSMutableArray *seals;
@end

@implementation SignSelector
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self loadSeal];
    }
    return self;
}
- (void)loadSeal
{
    self.seals = [[NSMutableArray alloc]init];
    self.units = [[NSMutableArray alloc]init];
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
            [self.filesList reloadData];
        }
    }];
}

- (void)initSubViews{
    _filesList = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _filesList.delegate = self;
    _filesList.dataSource = self;
    _filesList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _filesList.showsVerticalScrollIndicator = NO;
    _filesList.backgroundColor = [UIColor drakColor:RGBACOLOR(60, 60, 60, 1) lightColor:[UIColor whiteColor]];
    [_filesList registerClass:[CSSignCell class] forCellReuseIdentifier:@"CSSignCell"];
    [self addSubview:_filesList];
    [_filesList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)addSignImage:(UIImage*)signImage
{
    [self.filesList reloadData];
}
- (void)reloadSignSelector
{
    [self loadSeal];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.seals.count;
    _units = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i++) {
        DJSignSeal *unit = [self.seals objectAtIndex:i];
        if ([unit.sealType intValue] == 2) {
            [_units addObject:unit];
        }
    }
    return _units.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSSignCell *cell = [[CSSignCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSSignCell"];
    cell.unit = [_units objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(selector:didSelected:)]) {
        [self.selectorDelegate selector:self didSelected:[self.units objectAtIndex:indexPath.row]];
    }
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self)
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DJSignSeal *unit = [weakself.units objectAtIndex:indexPath.row];
            [weakself deleteSeal:unit.sealId];
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        addTarget(RootController, action_01, action_02, @"是否确定删除印章，删除后不可恢复");
    }];
    NSArray *arr = @[deleteAction];
    return arr;
}
- (void)deleteSeal:(NSString*)sealID
{
    [DJReadNetShare deleteSeal:sealID complete:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            showAlert(@"删除成功", RootController);
            [self loadSeal];
        }
    }];
}
@end
