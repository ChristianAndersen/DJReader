//
//  CSFormTableView.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFormTableView.h"
#import "CSFormtextCell.h"
#import "CSFormRadioCell.h"
#import "CSFormCustomCell.h"
#define CSFormTextCellIdentifier @"CSFormTextCell"
#define CSFormRadioCellIdentifier @"CSFormRadioCell"
#define CSFormCustomCellIdentifier @"CSFormCustomCell"

@implementation CSFormSectionModel
- (instancetype)init
{
    if (self = [super init]) {
        _rows = [[NSMutableArray alloc]init];
    }
    return self;
}
@end

@interface CSFormTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainView;
@property (nonatomic,strong)NSMutableArray *sections;
@end

@implementation CSFormTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _sections = [[NSMutableArray alloc]init];
        [self loadSubviews];
    }
    return self;
}

- (NSDictionary*)optionValue
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    for (CSFormSectionModel *sectionModel in self.sections) {
        if (sectionModel.type == CSFormSectionTypeOption) {
            for (CSFormModel *rowModel in sectionModel.rows) {
                if (rowModel.type != CSFormCellTypeCustom) {
                    [info setValue:rowModel.value forKey:rowModel.name];
                }
            }
        }
    }
    return info;
}

- (NSDictionary*)requiredValue
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    for (CSFormSectionModel *sectionModel in self.sections) {
        if (sectionModel.type == CSFormSectionTypeRequired) {
            for (CSFormModel *rowModel in sectionModel.rows) {
                if (rowModel.type != CSFormCellTypeCustom) {
                    [info setValue:rowModel.value forKey:rowModel.name];
                }
            }
        }
    }
    return info;
}

- (void)loadSubviews
{
    _mainView = ({
        UITableView *tab = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        tab.delegate = self;
        tab.dataSource = self;
        tab;
    });
    [_mainView registerClass:[CSFormtextCell class] forCellReuseIdentifier:CSFormTextCellIdentifier];
    [_mainView registerClass:[CSFormRadioCell class] forCellReuseIdentifier:CSFormRadioCellIdentifier];
    [_mainView registerClass:[CSFormCustomCell class] forCellReuseIdentifier:CSFormCustomCellIdentifier];

    [self addSubview:_mainView];
}
- (void)reloadMainView
{
    [self.mainView reloadData];
}
- (void)addSection:(CSFormSectionModel*)model
{
    [_sections addObject:model];
}
- (void)addModel:(CSFormModel*)model toSection:(NSInteger)section
{
    CSFormSectionModel *sectionModel = [_sections objectAtIndex:section];
    [sectionModel.rows addObject:model];
}

- (void)addTextRow:(NSString*)name placeholder:(NSString*)placeholder inSection:(NSInteger)section formType:(CSFormItemType)type
{
    CSFormtextModel *model = [[CSFormtextModel alloc]init];
    model.type = CSFormCellTypeText;
    model.formType = (int)type;
    model.name = name;
    model.height = 44;
    model.font = [UIFont systemFontOfSize:12];
    model.identifier = CSFormTextCellIdentifier;
    model.placeholder = placeholder;
    [self addModel:model toSection:section];
}
- (void)addRadioRow:(NSString*)name items:(NSArray*)items inSection:(NSInteger)section formType:(CSFormItemType)type
{
    CSFormRadioModel *model = [[CSFormRadioModel alloc]init];
    model.type = CSFormCellTypeRadio;
    model.formType = (int)type;
    model.name = name;
    model.height = 44;
    model.font = [UIFont systemFontOfSize:12];
    model.identifier = CSFormRadioCellIdentifier;
    model.items = items;
    [self addModel:model toSection:section];
}
- (void)addCustomRow:(NSString*)name content:(UIView*)contentView inSection:(NSInteger)section formType:(CSFormItemType)type
{
    CSFormCustomModel *model = [[CSFormCustomModel alloc]init];
    model.type = CSFormCellTypeCustom;
    model.formType = (int)type;
    model.name = name;
    model.height = 250;
    model.font = [UIFont systemFontOfSize:12];
    model.identifier = CSFormCustomCellIdentifier;
    model.content = contentView;
    [self addModel:model toSection:section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_sections.count > 0) {
        return _sections.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFormSectionModel *sectionModel = [_sections objectAtIndex:indexPath.section];
    CSFormModel *model = [sectionModel.rows objectAtIndex:indexPath.row];
    return model.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CSFormSectionModel *sectionModel = [_sections objectAtIndex:section];
    return sectionModel.rows.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFormSectionModel *sectionModel = [_sections objectAtIndex:indexPath.section];
    CSFormModel *model = [sectionModel.rows objectAtIndex:indexPath.row];
    CSFormCell *cell = [[CSFormCell alloc]initWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    headView.backgroundColor = CSWhiteColor;
    UIView *cricle = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 10, 10)];
    cricle.layer.masksToBounds = YES;
    cricle.layer.cornerRadius = 5;
    cricle.backgroundColor = [UIColor grayColor];
    [headView addSubview:cricle];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, headView.width - 50, 50)];
    CSFormSectionModel *sectionModel = [_sections objectAtIndex:section];
    title.font = [UIFont systemFontOfSize:14];
    title.text = sectionModel.name;
    [headView addSubview:title];
    return headView;
}

- (void)addFotterView:(UIView*)view;
{
    self.mainView.tableFooterView = view;
}

@end
