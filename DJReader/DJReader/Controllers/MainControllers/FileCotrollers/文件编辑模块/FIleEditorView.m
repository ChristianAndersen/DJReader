//
//  FIleEditorView.m
//  DJReader
//
//  Created by Andersen on 2020/3/10.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "FIleEditorView.h"
#import <DJContents/DJContentView.h>
#import "CSKeyBoardView.h"
#import "ColorUnit.h"
#import "SealUnit.h"
#import "DJReadManager.h"
#import "UserPreference.h"
#import "FileEditorController.h"
#import "CertManagerController.h"
#import "DJFileManager.h"
#import "DJReadNetManager.h"
#import "CSCoreDataManager.h"
#import "CSShareManger.h"
#import <MBProgressHUD.h>
#import "CSImagePicker.h"
#import "CSLaunchView.h"
#import "SmallProgramCollectionView.h"
#import "CSIMagePickerResultVC.h"
#import "CSSheetManager.h"

@interface FIleEditorView()<DJContentViewDelegate>
@property (strong, nonatomic) CSLaunchView *expressView;//广告

@property (nonatomic,strong)DJContentView *contentView;
@property (nonatomic,strong)UserPreference *preference;
@property (nonatomic,strong)CSKeyBoardView *keyBoardView;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,assign)DJReadEditAction currentAction;
@property (nonatomic,assign)CGRect mainFrame;
@property (nonatomic,assign)BOOL hasSeal,shouldShare;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,copy)NSString *tmpName;
@property (nonatomic,strong)UIView *footerView;
@end

@implementation FIleEditorView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _mainFrame = frame;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)didDisAppear
{
    [_keyBoardView hideView];
}
- (UserPreference*)preference
{
    if (!_preference) {
        _preference = [DJReadManager shareManager].loginUser.preference;
    }
    return _preference;
}
- (void)setFileDocument:(DJFileDocument *)fileDocument
{
    _fileDocument = fileDocument;
    self.fileData = [NSData dataWithContentsOfFile:fileDocument.filePath];
}
- (void)setFileData:(NSData *)fileData
{
    if (fileData)
    {
        [DJContentView loginUser:@"Andersen" loadOtherNodes:YES];
        if ([[[self.fileDocument.filePath.lastPathComponent componentsSeparatedByString:@"."]lastObject] isEqualToString:@"pdf"]) {
            _contentView = [[DJContentView alloc]initWithFrame:self.bounds pdfFileData:fileData];
        }else if([[[self.fileDocument.filePath.lastPathComponent componentsSeparatedByString:@"."]lastObject] isEqualToString:@"aip"]){
            _contentView = [[DJContentView alloc]initWithFrame:self.bounds aipFileData:fileData];
        }else if ([[[self.fileDocument.filePath.lastPathComponent componentsSeparatedByString:@"."]lastObject] isEqualToString:@"ofd"]){
            _contentView = [[DJContentView alloc]initWithFrame:self.bounds ofdFileData:fileData complete:nil];
        }
        [self addFooterView];
        _contentView.contentViewDelegate = self;
        //[_contentView setUserInfoWithUserId:@"Andersen" userName:@"Andersen"];
        [self.contentView setBlocksBorderColor:[UIColor colorWithRed:0.60 green:1.0 blue:0.60 alpha:0.3]];
        [self.contentView setBlocksBackColor:[UIColor colorWithRed:0.60 green:1.0 blue:0.60 alpha:0.3]];
        [self addSubview:_contentView];
    }
}
- (void)showEditKeyboard:(DJTextBlockHandle*)handle
{
    _keyBoardView = [[CSKeyBoardView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - k_TabBar_Height * 2, self.width, k_TabBar_Height*2) preference:self.preference];
    _keyBoardView.handle = handle;
    _keyBoardView.parentView = self;
    [self addSubview:_keyBoardView];
    [_keyBoardView showView];
}
- (void)parseParams:(NSDictionary*)params withControllType:(BottomActionType)type
{
    switch (type) {
        case BottomActionTypeWait:{
            [self beganBrowse];
        }break;
        case BottomActionTypeText:{
            [self beganText];
        }break;
        case BottomActionTypeSeal:{
            [self beganSeal];
        }break;
        case BottomActionTypeHand:{
            CGFloat penWidth = [[params objectForKey:@"penWidth"]intValue];
            ColorUnit *unit = [params objectForKey:@"colorUnit"];
            self.contentView.penColor = [UIColor colorWithRed:unit.r/255.0 green:unit.g/255.0 blue:unit.b/255.0 alpha:1.0];
            self.contentView.penWidth = penWidth;
            [self beganHand];
        }break;
        default:
            break;
    }
}
- (void)undo
{
    [self.contentView undo];
}
- (void)addFooterView
{
    CGFloat VH = 0;
    CGFloat flagW = 80;
    CGFloat actionH = 120;
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, VH, self.frame.size.width, 700)];
    self.footerView.backgroundColor = [UIColor clearColor];
    
    VH = 30.0;
    UILabel *flagLab = [[UILabel alloc]initWithFrame:CGRectMake((self.footerView.width - flagW)/2, VH, flagW, 30)];
    flagLab.text = @"文档结束了";
    flagLab.font = [UIFont systemFontOfSize:14.0];
    flagLab.textAlignment = NSTextAlignmentCenter;
    flagLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    flagLab.backgroundColor = [UIColor clearColor];
    [self.footerView addSubview:flagLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, VH + 15, (self.footerView.width - flagW)/2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self.footerView addSubview:line];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(((self.footerView.width - flagW)/2)+flagW, VH + 15, (self.footerView.width - flagW)/2, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [self.footerView addSubview:line2];
    
    VH = VH + 30 + 50;
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake(5, VH, self.frame.size.width-10, actionH)];
    actionView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:actionView];
    
    UILabel *actionHead = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    actionHead.backgroundColor = [UIColor whiteColor];
    actionHead.font = [UIFont systemFontOfSize:13];
    actionHead.textColor = [UIColor grayColor];
    actionHead.text = @"常用功能";
    [actionView addSubview:actionHead];
    
    NSString *fileExt = self.fileDocument.filePath.pathExtension;
    NSMutableDictionary *items = [[NSMutableDictionary alloc]init];
    [items setObject:ProgramName_images forKey:ProgramName_images];
    [items setObject:ProgramName_longImage forKey:ProgramName_longImage];
    
    if ([fileExt isEqualToString:AIPFileExt]) {
        [items setObject:ProgramName_OFDConvertPDF forKey:ProgramName_OFDConvertPDF];
        [items setObject:ProgramName_PDFConvertOFD forKey:ProgramName_PDFConvertOFD];
    }else if([fileExt isEqualToString:PDFFileExt]){
        [items setObject:ProgramName_PDFPageManager forKey:ProgramName_PDFPageManager];
        [items setObject:ProgramName_PDFConvertOFD forKey:ProgramName_PDFConvertOFD];
    }else if([fileExt isEqualToString:OFDFileExt]){
        [items setObject:ProgramName_OFDPageManager forKey:ProgramName_OFDPageManager];
        [items setObject:ProgramName_OFDConvertPDF forKey:ProgramName_OFDConvertPDF];
    }
    
    SmallProgramCollectionView *actionMenu = [[SmallProgramCollectionView alloc]initWithFrame:CGRectMake(5, 35, self.frame.size.width-20, 70)];
    actionMenu.backgroundColor = [UIColor whiteColor];
    [actionMenu loadProgramData:items withFileExt:fileExt];
    [actionView addSubview:actionMenu];
    [self.footerView addSubview:actionView];
    actionMenu.itemClicked = ^(NSString* programeName){
        [self convertFile:programeName];
    };
    
    VH = VH + actionH + 20;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(5, VH, self.frame.size.width - 10, 300)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:contentView];
    [self.contentView addFooterView:self.footerView];
    
    self.expressView = [[CSLaunchView alloc]initWithFrame:contentView.bounds];
    [self.expressView showIn:contentView atRootController:_parentController];
}
- (void)beganMove
{
    [self.keyBoardView hideView];
    self.currentAction = DJReadEditMove;
    self.contentView.currentAction = DJContentActionOperation;
}
- (void)beganEraser
{
    [self.keyBoardView hideView];
    self.currentAction = DJReadEditEraser;
    self.contentView.currentAction = DJContentActionErase;
}
- (void)beganBrowse
{
    [self.keyBoardView hideView];
    self.currentAction = DJReadEditBrowse;
    [self.parentController changeBarType:EditorNavBarTypeBrowse];
    self.contentView.currentAction = DJContentActionBrowse;
}
- (void)beganText
{
    self.currentAction = DJReadEditText;
    [self.parentController changeBarType:EditorNavBarTypeText];
    self.contentView.currentAction = DJContentActionOperation;
}
- (void)beganHand
{
    [self.keyBoardView hideView];
    self.currentAction = DJReadEditWrite;
    [self.parentController changeBarType:EditorNavBarTypeHand];
    self.contentView.currentAction = DJContentActionWrite;
}
- (void)beganSeal
{
    [self.keyBoardView hideView];
    self.currentAction = DJReadEditSeal;
    [self.parentController changeBarType:EditorNavBarTypeSeal];
    if ([DJReadManager shareManager].curCertificate) {
        self.contentView.currentAction = DJContentActionSeal;
        [self.contentView setSealWithSealDataFilePath:[DJReadManager shareManager].curSeal.path];
    }else{
        self.contentView.currentAction = DJContentActionOperationDraw;
    }
}
- (void)gotoPage:(int)page
{
    [self.contentView gotoPage:[NSIndexPath indexPathForRow:page inSection:0] offset:CGPointZero];
}
- (void)shareFile
{
    _shouldShare = YES;
    [self showHUD];
    [self save:self.fileDocument.name];
}
- (void)convertFile:(NSString*)programeName
{
    NSString *fileExt = @"pdf";
    if ([programeName isEqualToString:ProgramName_PDFConvertOFD]) {
        fileExt = OFDFileExt;
    }else if([programeName isEqualToString:ProgramName_OFDConvertPDF]){
        fileExt = PDFFileExt;
    }else if([programeName isEqualToString:ProgramName_AIPConvertPDF]){
        fileExt = PDFFileExt;
    }else if([programeName isEqualToString:ProgramName_AIPConvertOFD]){
        fileExt = OFDFileExt;
    }else if([programeName isEqualToString:ProgramName_longImage]){
        [self importLongImage];
        return;
    }else if([programeName isEqualToString:ProgramName_images]){
        [self importImages];
        return;
    }else if([programeName isEqualToString:ProgramName_PDFPageManager]){
        [self pageManger];
        return;
    }
    NSString *fileName = [[[[[self.fileDocument.filePath.lastPathComponent componentsSeparatedByString:@"#"] lastObject] componentsSeparatedByString:@"."]firstObject] stringByAppendingFormat:@"%@", fileExt];
    NSString *filePath = [DJFileManager pathInOFDFloderDirectoryWithFileName:fileName];
    [self.contentView saveToFile:filePath];
    ShowMessage(@"", @"文件转换成功，在主页中可以查看", self.parentController);
}
- (void)importImages
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = 0;
    imagePicker.fileModel = self.fileDocument;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        NSMutableArray *images = [NSMutableArray new];
        for (NSString *path in imagePaths) {
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
            [images addObject:image];
        }
        SaveToCamera(images, self.parentController);
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self.parentController presentViewController:nav animated:YES completion:nil];
}
- (void)importLongImage
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = 1;
    imagePicker.fileModel = self.fileDocument;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CSIMagePickerResultVC *vc = [[CSIMagePickerResultVC alloc]init];
            vc.resource = imagePaths;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self.parentController presentViewController:nav animated:YES completion:nil];
        });
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self.parentController presentViewController:nav animated:YES completion:nil];
}
- (void)pageManger
{
    @WeakObj(self);
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeImages;
    imagePicker.fileModel = self.fileDocument;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        NSMutableArray *paths = [[NSMutableArray alloc]initWithArray:imagePaths];
        [weakself mergeFile:paths];
        NSString * str = [NSString stringWithFormat:@"文件调整成功，返回主页查看"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.parentController dismissViewControllerAnimated:YES completion:nil];
        }]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.parentController presentViewController:alertController animated:YES  completion:nil];
        });
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self.parentController presentViewController:nav animated:YES completion:nil];
}
- (void)share:(NSString*)filePath
{
    _shouldShare = NO;
    NSURL*fileURL = [[NSURL alloc]initFileURLWithPath:filePath];
    [CSShareManger shareActivityController:self.parentController withFile:fileURL];
}
- (void)saveFile
{
    NSString * str = [NSString stringWithFormat:@"请输入文件名称,若有同名文件则会覆盖之前文件"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alertController.textFields[0];
        if (name) {
            self.tmpName = name.text;
            [self showHUD];
            [self save:self.tmpName];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.text = self.fileDocument.name;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fileDocument.modificationDate = [CSSnowIDFactory getCurrentDateInterval];
        [[CSCoreDataManager shareManager] updataFileToCoreData:self.fileDocument];
        [self.parentController presentViewController:alertController animated:YES  completion:nil];
    });
}
- (void)save:(NSString*)fileName
{
    self.tmpName = fileName;
    if (![self.tmpName isEqualToString:self.fileDocument.name]) {
        if ([fileName componentsSeparatedByString:@"."].count > 1)
            self.tmpName = [[self.tmpName componentsSeparatedByString:@"."] firstObject];
        
        self.fileDocument.name = [NSString stringWithFormat:@"%@.%@",self.tmpName,[self.fileDocument.name pathExtension]];
        NSString *oldName = [[[self.fileDocument.filePath lastPathComponent] componentsSeparatedByString:@"#"]lastObject];
        self.fileDocument.filePath = [self.fileDocument.filePath stringByReplacingCharactersInRange:NSMakeRange(self.fileDocument.filePath.length - oldName.length, oldName.length) withString:self.fileDocument.name];
        [[CSCoreDataManager shareManager] updataFileToCoreData:self.fileDocument];
        [[DJFileManager shareManager] deleteFile:self.fileDocument.filePath];//如果原文件和将要保存的文件同名，删除原有文件
    }
    if (!self.hasSeal) {
        [self.contentView mergeAllPostStringWithCertFile:nil password:@""];
        [self.contentView saveToFile:self.fileDocument.filePath];
        [DJReadManager shareManager].curCertificate = nil;
        [self hiddenHUD];
        if (self.shouldShare)
            [self share:self.fileDocument.filePath];
    }else if(self.hasSeal){//有证书的情况下
        DJCertificate *cert = [DJReadManager shareManager].curCertificate;
        [self.contentView startMergeBySM2PubCert:cert.signCert];
    }
}
- (void)mergeFile:(NSMutableArray*)imagePaths{
    [DJContentView verify:@"INXT" verifylicFile:@"XSLSjA36jgtp5xM9qypF4SXqM0KOksF5z9FE+IsRZzo="];
    [DJContentView loginUser:@"Andersen" loadOtherNodes:YES];
    
    DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.bounds aipFilePath:[imagePaths firstObject]];
    for (int i = 1;i<imagePaths.count;i++) {
        NSString *path = [imagePaths objectAtIndex:i];
        [contentView mergeFile:path afterPage:contentView.pageCount];
    }
    [contentView saveToFile:self.fileDocument.filePath];
}
-(void)contentView:(DJContentView *)contentView mergeDigest:(NSString *)digest complete:(NSString* (^)(NSString *,NSString*))complete{
    self.tmpName = [[self.fileDocument.name componentsSeparatedByString:@"."]firstObject];
    DJCertificate *cert = [DJReadManager shareManager].curCertificate;
    if (!digest) {
        [self hiddenHUD];
        NSString *filePath = complete(nil,self.tmpName);
        NSData *fileData = [[NSData alloc]initWithContentsOfFile:filePath];
        [fileData writeToFile:self.fileDocument.filePath atomically:YES];
        [[DJFileManager shareManager] deleteFile:filePath];//如果原文件和将要保存的文件同名，删除原有文件
        self.hasSeal = NO;
        if (_shouldShare) [self share:self.fileDocument.filePath];
        [DJReadManager shareManager].curCertificate = nil;
        return;
    }
//    NSString *openid = @"o-UtJ1RMTcN-Mt6dgQfELKDVXuDw";
//    NSString *phonenum = @"15001389169";
//    NSString *certid =  @"1af41e88adcd4df88ec019b717cc89c8";
//    NSString *srcData = digest;
//    NSDictionary *params = @{
//        @"openid":openid,
//        @"phonenum":phonenum,
//        @"certid":certid,
//        @"srcData":srcData,
//    };
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    [param setValue:openid forKey:@"openid"];
//    [param setValue:phonenum forKey:@"phonenum"];
//    [param setValue:certid forKey:@"certid"];
//    [param setValue:srcData forKey:@"srcData"];
    
    NSString *openid = @"";
    NSString *phonenum = [DJReadManager shareManager].loginUser.uphone;
    NSString *certid =  cert.certid;
    NSString *srcData = digest;
    NSString *bussinessCode = cert.bussinessCode;

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:openid forKey:@"openid"];
    [params setValue:phonenum forKey:@"phonenum"];
    [params setValue:certid forKey:@"certid"];
    [params setValue:srcData forKey:@"srcData"];
    [params setValue:bussinessCode forKey:@"bussinessCode"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://47.105.164.141:8081/sso/cert/sign"]];
    request.HTTPBody = [[NSString dictionaryToJson:params] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            int code = [[response objectForKey:@"code"]intValue];
            if (code != 0) {
                NSString *errorMsg = [[NSString alloc]initWithFormat:@"数字签名出错:%d",code];
                ShowMessage(@"错误", errorMsg, self.parentController);
                complete(nil,self.tmpName);
            }else{
                NSDictionary *data = [response objectForKey:@"data"];
                NSString*signature = [data objectForKey:@"signdata"];
                if (complete) {
                    NSString *filePath = complete(signature,self.tmpName);
                }
            }
        }else{
            ShowMessage(@"网络错误", error.description, self.parentController);
        }
    }];
    [task resume];
}

- (int)closeFile
{
    [self.expressView removeADView];
    [self.contentView closeFile];
    return _currentPage;
}
- (void)changeFileName
{
    NSString * str = [NSString stringWithFormat:@"请输入文件名称,若有同名文件则会覆盖之前文件"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alertController.textFields[0];
        if (name) {
            self.tmpName = name.text;
            if (![self.tmpName isEqualToString:self.fileDocument.name]) {
                if ([name.text componentsSeparatedByString:@"."].count > 1)
                    self.tmpName = [[self.tmpName componentsSeparatedByString:@"."] firstObject];
                self.fileDocument.name = [NSString stringWithFormat:@"%@.%@",self.tmpName,[self.fileDocument.name pathExtension]];
                NSString *oldName = [[[self.fileDocument.filePath lastPathComponent] componentsSeparatedByString:@"#"]lastObject];
                self.fileDocument.filePath = [self.fileDocument.filePath stringByReplacingCharactersInRange:NSMakeRange(self.fileDocument.filePath.length - oldName.length, oldName.length) withString:self.fileDocument.name];
                [[CSCoreDataManager shareManager] updataFileToCoreData:self.fileDocument];
                [[DJFileManager shareManager] deleteFile:self.fileDocument.filePath];//如果原文件和将要保存的文件同名，删除原有文件
            }else{
                [[DJFileManager shareManager] deleteFile:self.fileDocument.filePath];//如果原文件和将要保存的文件同名，删除原有文件
            }
            if (!self.hasSeal) {
                [self hiddenHUD];
                [self.contentView mergeAllPostStringWithCertFile:nil password:@""];
                [self.contentView saveToFile:self.fileDocument.filePath];
            }else if(self.hasSeal){//有证书的情况下
                DJCertificate *cert = [DJReadManager shareManager].curCertificate;
                [self.contentView startMergeBySM2PubCert:cert.signCert];
            }
            [DJReadManager shareManager].curCertificate = nil;
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.text = self.fileDocument.name;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.parentController presentViewController:alertController animated:YES  completion:nil];
    });
}

- (void)changeBarSeleted:(NSString*)title
{
    [self.parentController changeBarSelected:title];
}

- (void)drawIamge:(CGPoint)point page:(int)page
{
    DJSignSeal *seal = [DJReadManager shareManager].curSeal;
    if (!seal) {
        ShowMessage(@"提示", @"尚未选择印章，请先选择印章", self.parentController);
        return;
    }
    if (CGPointEqualToPoint(point, CGPointZero))
    {
        point = CGPointMake(200, 200);
        page = 0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *sign = seal.sealImage;
        [self.contentView createSealForImage:sign rect:CGRectMake(point.x, point.y, 200, 80) atPage:page shouldReturn:NO];
        self->_hasSeal = YES;
    });
}

- (CGRect)getPoint:(NSString *)pointString
{
    CGPoint point = CGPointFromString(pointString);
    return CGRectMake(point.x,point.y,200, 40);
}
#pragma DJContentViewDelegate
- (void)contentView:(DJContentView *)contentView clicked:(NSString *)point indexPath:(NSIndexPath *)indexPath
{
    CGRect rectWithPoint = [self getPoint:point];
    switch (self.currentAction) {
        case DJReadEditBrowse:{
            
        }break;
        case DJReadEditWrite:{
                
        }break;
        case DJReadEditText:{
            DJTextBlockHandle *handle = [self.contentView addTextBlockToPage:(int)indexPath.row inRect:rectWithPoint];
            [handle submitWithText:TextTipStr];
            [self showEditKeyboard:handle];
        }break;
        case DJReadEditSeal:{
            if (![DJReadManager shareManager].curCertificate) {
                [self drawIamge:CGPointFromString(point) page:(int)indexPath.row];
            }
        }break;
        case DJReadEditMove:{
                return;
        }break;
        case DJReadEditEraser:{
                    
        }break;
        default:
            break;
    }
}
- (void)contentViewDidSeal:(DJContentView *)view
{
    self.hasSeal = YES;
    [self beganBrowse];
}
- (void)editSeal:(CGPoint)point page:(int)page
{
    if (![DJReadManager shareManager].curSeal) {
        ShowMessage(@"提示", @"盖章功能需要先选中印章", self.parentController);
        return;
    }else{
        [self.contentView setSealWithSealDataFilePath:@""];
    }
    [self drawIamge:point page:page];
    [self beganBrowse];
}
- (void)contentView:(DJContentView *)contentView currentPage:(int)page pageCount:(int)pageCount
{
    _currentPage = page;
}

- (void)contentView:(DJContentView *)contentView handle:(DJTextBlockHandle *)handle{
    switch (self.currentAction) {
        case DJReadEditBrowse:{
        }break;
        case DJReadEditWrite:{
        }break;
        case DJReadEditText:{
            [self showEditKeyboard:handle];
        }break;
        case DJReadEditSeal:{
        }break;
        case DJReadEditMove:{
                
        }break;
        case DJReadEditEraser:{
                    
        }break;
        default:
            break;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [self.contentView setDrakMode:YES];
        }else{
            [self.contentView setDrakMode:NO];
        }
    } else {
        [self.contentView setDrakMode:NO];
    }
}
- (void)showHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = @"正在合并文件";
    [_hud showAnimated:YES];
}
- (void)hiddenHUD
{
    [_hud hideAnimated:YES];
}
@end
