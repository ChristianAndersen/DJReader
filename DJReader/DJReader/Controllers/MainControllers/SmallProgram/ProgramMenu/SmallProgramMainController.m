//
//  SmallProgramMainController.m
//  DJReader
//
//  Created by Andersen on 2021/3/10.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramMainController.h"
#import "SmallProgramIconView.h"
#import "SmallProgramHeadView.h"
#import "SmallProgramFooter.h"
#import "ImageProgram.h"
#import "SmallProgramSectionController.h"
#import "SmallProgramSearchController.h"
#import "DJReadNetManager.h"
#import "CSSheetManager.h"

@interface SmallProgramMainController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *programMenu;
@property (nonatomic,strong)UICollectionViewFlowLayout *programMenuLayout;
@property (nonatomic,strong)NSMutableArray *programSectionNames;
@property (nonatomic,strong)NSMutableDictionary *programList;
@end

@implementation SmallProgramMainController
- (UICollectionView*)programMenu
{
    if (!_programMenu) {
        CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height - 49);
        _programMenu = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:self.programMenuLayout];
        _programMenu.delegate = self;
        _programMenu.dataSource = self;
        _programMenu.backgroundColor = CSBackgroundColor;
        _programMenu.scrollEnabled = YES;
        _programMenu.alwaysBounceVertical = YES;
        [_programMenu registerClass:[SmallProgramIconView class] forCellWithReuseIdentifier:@"SmallProgramIconView"];
        [_programMenu registerClass:[SmallProgramHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SmallProgramHeadView"];
        [_programMenu registerClass:[SmallProgramFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SmallProgramFooter"];
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
        _programMenuLayout.headerReferenceSize = CGSizeMake(self.view.width, 49);
        _programMenuLayout.footerReferenceSize = CGSizeMake(self.view.width, 10);
    }
    return _programMenuLayout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CSBackgroundColor;
    [self loadProgramData];
    [self loadSubView];
}
- (void)loadProgramData
{
    _programSectionNames = [[NSMutableArray alloc]init];
    [_programSectionNames addObject:@"图片处理"];
    [_programSectionNames addObject:@"PDF处理"];
    [_programSectionNames addObject:@"OFD处理"];
    
    NSArray *imageOperationNames = @[ProgramName_imagesConvertOFD,ProgramName_imagesConvertPDF,ProgramName_images,ProgramName_longImage];
    NSMutableArray *imageOperationModels = [[NSMutableArray alloc]init];
    _programList = [[NSMutableDictionary alloc]init];

    for (NSString *programName in imageOperationNames) {
        SmallProgramModel *model = [[SmallProgramModel alloc]init];
        model.programName = programName;
        model.programSection = ProgramSection_imageOperation;
        model.programHeader = [UIImage imageNamed:programName];
        [imageOperationModels addObject:model];
    }
    [_programList setValue:imageOperationModels forKey:[_programSectionNames objectAtIndex:0]];

    NSArray *PDFOperationNames = @[ProgramName_WordConvertPDF,ProgramName_PDFConvertOFD,ProgramName_PDFMerge,ProgramName_PDFPageManager,ProgramName_PDFConvertWord,ProgramName_HTMLConvertPDF];
    NSMutableArray *PDFOperationModels = [[NSMutableArray alloc]init];

    for (NSString *programName in PDFOperationNames) {
        SmallProgramModel *model = [[SmallProgramModel alloc]init];
        model.programName = programName;
        model.programSection = ProgramSection_PDFOperation;
        model.programHeader = [UIImage imageNamed:programName];
        [PDFOperationModels addObject:model];
    }
    [_programList setValue:PDFOperationModels forKey:[_programSectionNames objectAtIndex:1]];
    NSArray *OFDOperationNames = @[ProgramName_WordConvertOFD,ProgramName_OFDConvertPDF,ProgramName_OFDMerge,ProgramName_OFDPageManager,ProgramName_OFDConvertWord];
    NSMutableArray *OFDOperationModels = [[NSMutableArray alloc]init];

    for (NSString *programName in OFDOperationNames) {
        SmallProgramModel *model = [[SmallProgramModel alloc]init];
        model.programName = programName;
        model.programSection = ProgramSection_OFDOperation;
        model.programHeader = [UIImage imageNamed:programName];
        [OFDOperationModels addObject:model];
    }
    [_programList setValue:OFDOperationModels forKey:[_programSectionNames objectAtIndex:2]];
}
- (void)loadSubView
{
//    CGFloat interval = 20;
//    CGFloat HeadHeight = 30.0;
//    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(interval,(self.navigationController.navigationBar.height - HeadHeight)/2, self.view.width - interval*2, HeadHeight)];
//    [search addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    [search setTitle:@"搜索应用" forState:UIControlStateNormal];
//    search.titleLabel.font = [UIFont systemFontOfSize:14];
//    [search setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [search setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
//    search.titleEdgeInsets = UIEdgeInsetsMake(HeadHeight/4, HeadHeight/2, HeadHeight/4, (self.view.width - interval*2 -HeadHeight*3.5));
//    search.imageEdgeInsets = UIEdgeInsetsMake(HeadHeight/4, HeadHeight/2, HeadHeight/4, (self.view.width - HeadHeight - interval*2));
//    search.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    search.layer.masksToBounds = YES;
//    search.layer.cornerRadius = HeadHeight/2;
//    [self.navigationController.navigationBar addSubview:search];
    self.title = @"应用";
    [self.view addSubview:self.programMenu];
}
- (void)searchAction{
    NSMutableArray *resourcePrograms = [[NSMutableArray alloc]init];
    for (NSString *sectionName in self.programSectionNames) {
        [resourcePrograms addObjectsFromArray:[self getProgramsWithSectionName:sectionName]];
    }
    SmallProgramSearchController *search = [[SmallProgramSearchController alloc]init];
    search.modalPresentationStyle = 0;
    search.resourcePrograms = resourcePrograms;
    SetRootController(search);
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.programSectionNames.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getProgramsWithSection:section].count;
}
//点击签名会向文件载入笔迹
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallProgramIconView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallProgramIconView" forIndexPath:indexPath];
    cell.model = [self getProgramModelWithSection:indexPath.section andRow:indexPath.row];
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self)
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SmallProgramHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SmallProgramHeadView" forIndexPath:indexPath];
        header.sectionName = [_programSectionNames objectAtIndex:indexPath.section];
        header.moreHander = ^(NSString * _Nonnull title) {
            SmallProgramSectionController *section = [[SmallProgramSectionController alloc]init];
            section.programs = [weakself getProgramsWithSectionName:title];
            section.title = title;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:section];
            nav.modalPresentationStyle = 0;
            SetRootController(nav);
        };
        return header;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SmallProgramFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SmallProgramFooter" forIndexPath:indexPath];
        [footer loadSubViews];
        return footer;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallProgramModel *programModel = [self getProgramModelWithSection:indexPath.section andRow:indexPath.row];
//    if ([programModel.programName isEqualToString:ProgramName_HTMLConvertPDF]) {
//        [self convertHtmlToPDF];
//    }else{
        launchProgram(programModel.programName,programModel.programSection);
//    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.width/5.0, self.view.width/5.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 10, 1, 10);
}
-(NSArray*)getProgramsWithSection:(NSInteger)section
{
    NSString *sectionName = [self.programSectionNames objectAtIndex:section];
    return [self getProgramsWithSectionName:sectionName];
}
-(NSArray*)getProgramsWithSectionName:(NSString*)sectionName
{
    return [self.programList objectForKey:sectionName];
}
-(SmallProgramModel*)getProgramModelWithSection:(NSInteger)section andRow:(NSInteger)row
{
    NSArray *programs = [self getProgramsWithSection:section];
    return [programs objectAtIndex:row];
}
-(void)convertHtmlToPDF
{
    NSString * str = [NSString stringWithFormat:@"请输入html地址"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *address = alertController.textFields[0];
        if (address.text.length > 10) {//cd改名
            //NSString *source = @"http://ofd365.dianju.cn/sso/%E7%82%B9%E8%81%9AOFD%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96.html";
            NSDictionary *params = @{
                @"fileUrl":address.text,
                @"fileType":@"html",
                @"returnType":@"pdf"
            };
            [CSSheetManager showHud:@"正在转换文件" atView:self.view];
            [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_htmlConvertPdf parameters:params showError:NO reponseResult:^(DJService *service) {
                if (service.code == 0) {
                    NSString *msg = [[NSString alloc]initWithFormat:@"文档转换成功，请到主页去查看"];
                    NSDictionary *dic = (NSDictionary*)service.dataResult;
                    NSString *base64 = [dic objectForKey:@"base64"];
                    NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64 options:0];
                    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"htmlToConvert.pdf"];
                    [base64Data writeToFile:filePath atomically:YES];
                    [CSSheetManager hiddenHud];
                    showAlert(msg, self);
                }else{
                    NSString *msg = [[NSString alloc]initWithFormat:@"文档转换失败：%@",service.serviceMessage];
                    [CSSheetManager hiddenHud];
                    showAlert(msg, self);
                }
            }];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入html地址";
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES  completion:nil];
    });
}

@end
