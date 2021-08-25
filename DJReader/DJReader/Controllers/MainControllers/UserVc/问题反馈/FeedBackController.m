//
//  FeedBackController.m
//  DJReader
//
//  Created by Andersen on 2020/7/9.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "FeedBackController.h"
#import "UFIssueRow.h"
#import "UFIssueRowCell.h"
#import "DJReadNetManager.h"
#import <UFKit/UFKit.h>
#import <MBProgressHUD.h>

#define describeKey @"describe"

@interface FeedBackController ()
@property (nonatomic, strong)UFFormView *formView;
@property (nonatomic, strong)NSMutableArray *files;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation FeedBackController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    self.view.backgroundColor = CSBackgroundColor;
    [self loadFormView];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadFormView
{
    CGFloat btnWidth = 80;
    CGFloat btnheight = 44;
    
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, btnheight);
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setTitleColor:CSTextColor forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake((44 - (btnWidth - 60))/2, 1.0, (44 - (btnWidth - 60))/2, 60);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
    @WeakObj(self);
    _formView = [UFFormView makeFormView:^(UFFormViewMaker * _Nonnull make) {
        make.separatorColor(CSSeparatorColor)
        .registerRow([UFIssueRow class], [UFIssueRowCell class])
        .rowHeight(50)
        .rowEdgeInsets(UIEdgeInsetsMake(15,15, 15, 15))
        .addSection([UFSection makeSection:^(UFSectionMaker * _Nonnull make) {
            make
//            .addRow([UFPickerViewRow makePickerViewRow:^(UFPickerViewRowMaker * _Nonnull make) {
//                make
//                .itemArray(@[@"头疼",@"脑热",@"嗓子干",@"腰酸",@"背疼",@"腿抽筋",@"其他"])
//                .value(@"其他")
//                .title(@"问题类型")
//                .isRequired(YES)
//                .name(@"问题类型")
//                .accessoryType(UFRowAccessoryDisclosureIndicator);
//            }])
            .addRow([UFTextViewRow makeTextViewRow:^(UFTextViewRowMaker * _Nonnull make) {
                make
                .editable(YES)
                .keyboardDidDone(^(__kindof UFRow<UFRowInput> * _Nonnull row, NSString * _Nonnull text) {
                    
                })
                .barTintColor([UIColor redColor])   // 键盘上方取消/确定的颜色
                .accessoryType(UFRowAccessorySpace)
                .name(@"describe")
                .isRequired(YES)
                .title(@"问题描述");
            }])
            .addRowWithBlock(^__kindof UFRow * _Nonnull{
                UFIssueRow *myRow = [UFIssueRow makeRow:^(UFRowMaker * _Nonnull make) {
                    make
                    .name(@"issuesFile");
                }];
                myRow.accessoryType = UFRowAccessorySpace;
                myRow.fileSelected = ^(NSMutableArray * _Nonnull array) {
                    weakself.files = array;
                };
                myRow.height = 160;
                return myRow;
            });
        }])
        // 添加提交按钮
        .addSubmitButton([UFActionButton makeActionButton:^(UFActionButtonMaker * _Nonnull make) {
            make
            .titleForState(@"提交", UIControlStateNormal)
            .titleColorForState([UIColor whiteColor], UIControlStateNormal)
            .cornerRadius(4)
            .backgroundColor([UIColor systemRedColor])
            .actionButtonClick(^(UFActionButton * _Nonnull button) {
                [weakself sendIessue];
            });
        }])
        .addToSuperView(self.view);
    }];
    _formView.frame = self.view.frame;
}
- (void)sendIessue
{
    @WeakObj(self);
    [self showHUD];
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_Feedback parameters:[self getIssueInfo] reponseResult:^(DJService *service) {
        [self hiddenHUD];
        NSInteger code = service.code;
        if (code == 0) {
            [weakself back];
            ShowMessage(nil, @"问题提交成功", RootController);
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (NSMutableDictionary*)getIssueInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSDictionary *formInfo = [self.formView toDictionary];
    NSMutableArray *fileList = [[NSMutableArray alloc]init];
    
    NSString *openid = [DJReadManager shareManager].loginUser.openid;
    NSString *phonenum = [DJReadManager shareManager].loginUser.uphone;
    openid = @"o-UtJ1RMTcN-Mt6dgQfELKDVXuDw";
    phonenum = @"15001389169";
    NSString *describe = [formInfo objectForKey:describeKey];
    
    for (int i = 0;i<self.files.count;i++) {
        NSMutableDictionary *file = [[NSMutableDictionary alloc]init];
        UIImage *image = [self.files objectAtIndex:i];
        NSString *fileData = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *fileName = [NSString stringWithFormat:@"描述图片_%d",i];
        NSString *filesuffix = @"png";
        [file setValue:fileName forKey:@"fileName"];
        [file setValue:filesuffix forKey:@"ilesuffix"];
        [file setValue:fileData forKey:@"filedata"];
        [fileList addObject:file];
    }
    [params setValue:openid forKey:@"openid"];
    [params setValue:phonenum forKey:@"phonenum"];
    [params setValue:describe forKey:@"describe"];
    [params setValue:fileList forKey:@"fileList"];
    return params;
}

- (void)showHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.margin = 10.f;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:15.0];
    _hud.detailsLabel.text = @"正在提交";
    [_hud showAnimated:YES];
}
- (void)hiddenHUD
{
    [_hud hideAnimated:YES];
}
@end

