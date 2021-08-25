//
//  ConvertHtmlAlert.m
//  DJReader
//
//  Created by Andersen on 2021/8/20.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "ConvertHtmlAlertController.h"
#import "CSSheetManager.h"
#import "DJReadNetManager.h"

@interface ConvertHtmlAlert()
@end
@implementation ConvertHtmlAlert
@end

@interface ConvertHtmlAlertController ()
@property (nonatomic,strong)ConvertHtmlAlert *alert;
@property (nonatomic,strong)UITextField *urlfield;
@property (nonatomic,strong)UITextField *namefield;
@end

@implementation ConvertHtmlAlertController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self loadSubview];
}
- (void)loadSubview{
    UIColor *color = [UIColor colorWithRed:96/255.0 green:232/255.0 blue:234/255.0 alpha:1.0];
    CGFloat intervalW = 20.0;
    CGFloat intervalH = 30.0;
    CGFloat height = 40;
    CGFloat width = self.view.width - intervalW*4;
    
    self.alert = [[ConvertHtmlAlert alloc]init];
    self.alert.backgroundColor = [UIColor whiteColor];
    self.alert.layer.masksToBounds = YES;
    self.alert.layer.cornerRadius = 4.0;
    [self.view addSubview:self.alert];
    [self.alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-height*2);
        make.width.equalTo(@(self.view.width - intervalW*2));
        make.height.equalTo(@(intervalH*4 + height*3));
    }];
    
    self.urlfield = ({
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(intervalW, intervalH, width, height)];
        field.placeholder = @"请输入文件地址";
        field.textAlignment = NSTextAlignmentCenter;
        field.layer.masksToBounds = YES;
        field.layer.cornerRadius = 4;
        field.layer.borderColor = color.CGColor;
        field.layer.borderWidth = 1.0;
        field.returnKeyType = UIReturnKeyDefault;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field;
    });
    [self.alert addSubview:self.urlfield];
    
    self.namefield = ({
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(intervalW, intervalH*1.5 + height, width, height)];
        field.placeholder = @"请输入生成文件名";
        field.textAlignment = NSTextAlignmentCenter;
        field.layer.masksToBounds = YES;
        field.layer.cornerRadius = 4;
        field.layer.borderColor = color.CGColor;
        field.layer.borderWidth = 1.0;
        field.returnKeyType = UIReturnKeyDefault;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field;
    });
    [self.alert addSubview:self.namefield];
    
    UIButton *convert= [[UIButton alloc] initWithFrame:CGRectMake(intervalW, intervalH*3 + height*2, width, height)];
    [convert setTitle:@"转换文件" forState:UIControlStateNormal];
    [convert addTarget:self action:@selector(convertHtmlToPDF) forControlEvents:UIControlEventTouchUpInside];
    convert.backgroundColor = color;
    convert.layer.masksToBounds = YES;
    convert.layer.cornerRadius = 4;

    [self.alert addSubview:convert];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if(CGRectContainsPoint(self.alert.frame,location))
        return;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)convertHtmlToPDF{
    NSString *name = self.namefield.text;
    NSString *url = self.urlfield.text;
    if (name.length <=0) {
        showAlert(@"未输入文件名", self);
        return;
    }
    if (![[name componentsSeparatedByString:@"."].lastObject isEqualToString:@"pdf"]) {
        name = [name stringByAppendingFormat:@".pdf"];
    }
    if (url.length < 10 || ![[[url componentsSeparatedByString:@"."] lastObject]isEqualToString:@"html"]) {
        showAlert(@"文件地址不正确", self);
        return;
    }
    [self convertFile:name url:url];
}
-(void)convertFile:(NSString*)fileName url:(NSString*)fileURL
{
    //NSString *source = @"http://ofd365.dianju.cn/sso/%E7%82%B9%E8%81%9AOFD%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96.html";
    NSDictionary *params = @{
        @"fileUrl":fileURL,
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
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
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

@end
