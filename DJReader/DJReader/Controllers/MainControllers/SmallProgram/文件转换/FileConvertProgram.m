//
//  FileConvertProgram.m
//  DJReader
//
//  Created by Andersen on 2021/6/3.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileConvertProgram.h"
#import "FileSelectController.h"
#import <DJContents/DJContentView.h>
#import "DJFileManager.h"
#import "BindPhoneController.h"
#import "CSSheetManager.h"
#import "DJReadNetManager.h"
#import "SubscribeController.h"
#import "CSCoreDataManager.h"
#import "FileEditorController.h"
#import "ConvertHtmlAlertController.h"

@interface FileConvertProgram ()
@end

@implementation FileConvertProgram

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)fileSelected{
    if ([self.programName isEqualToString:ProgramName_HTMLConvertPDF]) {
        ConvertHtmlAlertController *alert = [[ConvertHtmlAlertController alloc]init];
        alert.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        FileSelectController *selectController = [[FileSelectController alloc]init];
        selectController.fileFilterCondition = self.fileFilterCondition;

        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectController];
        nav.modalPresentationStyle = 0;
        selectController.programName = self.programName;
        selectController.fileSelectHander = ^(DJFileDocument * _Nonnull fileModel) {
            [self convertFile:fileModel];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)convertFile:(DJFileDocument*)fileModel{
    NSString *name = [[[[[fileModel.filePath lastPathComponent]componentsSeparatedByString:@"#"]lastObject]componentsSeparatedByString:@"."]firstObject];
    
    if ([self.programName isEqualToString:ProgramName_PDFConvertOFD]) {
        name = [name stringByAppendingFormat:@".ofd"];
        DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds pdfFilePath:fileModel.filePath];
        NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:name];
        [contentView saveToFile:convertPath];
    }else if([self.programName isEqualToString:ProgramName_AIPConvertOFD]){
        name = [name stringByAppendingFormat:@".ofd"];
        DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds aipFilePath:fileModel.filePath];
        NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:name];
        [contentView saveToFile:convertPath];
    }else if([self.programName isEqualToString:ProgramName_AIPConvertPDF]){
        name = [name stringByAppendingFormat:@".pdf"];
        DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds aipFilePath:fileModel.filePath];
        NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:name];
        [contentView saveToFile:convertPath];
    }else if([self.programName isEqualToString:ProgramName_OFDConvertPDF]){
        name = [name stringByAppendingFormat:@".pdf"];
        DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds ofdFilePath:fileModel.filePath complete:nil];
        NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:name];
        [contentView saveToFile:convertPath];
    }else if([self.programName isEqualToString:ProgramName_WordConvertPDF]){
        [self WordConvert:fileModel withFormat:@"PDF"];
        return;
    }else if([self.programName isEqualToString:ProgramName_WordConvertOFD]){
        [self WordConvert:fileModel withFormat:@"OFD"];
        return;
    }else if([self.programName isEqualToString:ProgramName_PDFConvertWord]){
        [self WordConvert:fileModel withFormat:@"docx"];
        return;
    }else if([self.programName isEqualToString:ProgramName_OFDConvertWord]){
        [self WordConvert:fileModel withFormat:@"docx"];
        return;
    }
    showAlert(@"转换完成，请到主页查看", self);
}

- (void)WordConvert:(DJFileDocument *)fileModel withFormat:(NSString*)format{
    NSString *type = @"";
    if ([format isEqualToString:@"PDF"]) {
        type = @"pdf";
    }else if([format isEqualToString:@"PDF"]){
        type = @"ofd";
    }else if([format isEqualToString:@"docx"]){
        type = @"docx";
    }
    NSString *fileName = [[[fileModel.filePath lastPathComponent] componentsSeparatedByString:@"#"]lastObject];
    fileName = [[[fileName componentsSeparatedByString:@"."] firstObject] stringByAppendingFormat:@".%@",type];
    //需要转换后才能打开的文件
    [CSSheetManager showHud:@"正在转换文件格式,请稍等" atView:self.view];
    [DJReadNetShare convertFile:fileModel.filePath returnType:format shouldJudge:NO complete:^(NSString *errMsg, NSString *fileBase64) {
            [CSSheetManager hiddenHud];
            if (errMsg) {
                showAlert(errMsg, self);
            }else{
                NSData *fileData = [[NSData alloc] initWithBase64EncodedString:fileBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *convertPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:fileName];
                [fileData writeToFile:convertPath atomically:YES];
                showAlert(@"转换完成，请到主页查看", self);
            }
    }];
}
//-(void)convertHtmlToPDF
//{
//    NSString * str = [NSString stringWithFormat:@"请输入html地址"];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确认修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UITextField *address = alertController.textFields[0];
//        if (address.text.length > 10) {//cd改名
//            //NSString *source = @"http://ofd365.dianju.cn/sso/%E7%82%B9%E8%81%9AOFD%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96.html";
//            NSDictionary *params = @{
//                @"fileUrl":address.text,
//                @"fileType":@"html",
//                @"returnType":@"pdf"
//            };
//            [CSSheetManager showHud:@"正在转换文件" atView:self.view];
//            [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_htmlConvertPdf parameters:params showError:NO reponseResult:^(DJService *service) {
//                if (service.code == 0) {
//                    NSString *msg = [[NSString alloc]initWithFormat:@"文档转换成功，请到主页去查看"];
//                    NSDictionary *dic = (NSDictionary*)service.dataResult;
//                    NSString *base64 = [dic objectForKey:@"base64"];
//                    NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64 options:0];
//                    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"htmlToConvert.pdf"];
//                    [base64Data writeToFile:filePath atomically:YES];
//                    [CSSheetManager hiddenHud];
//                    showAlert(msg, self);
//                }else{
//                    NSString *msg = [[NSString alloc]initWithFormat:@"文档转换失败：%@",service.serviceMessage];
//                    [CSSheetManager hiddenHud];
//                    showAlert(msg, self);
//                }
//            }];
//        }
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
//        textField.placeholder=@"请输入html地址";
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self presentViewController:alertController animated:YES  completion:nil];
//    });
//}

@end
