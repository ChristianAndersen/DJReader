//
//  ImagePreviewController.m
//  DJReader
//
//  Created by Andersen on 2021/3/12.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "ImagePreviewController.h"
#import "CSCoreDataManager.h"
#import <DJContents/DJContents.h>
@interface ImagePreviewController ()
@property (nonatomic,strong)UITextField *nameField;
@property (nonatomic,strong)DJContentView *preview;
@end

@implementation ImagePreviewController
- (UITextField*)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, self.view.height - k_TabBar_Height, self.view.width - 120, 40)];
        _nameField.placeholder = [NSString stringWithFormat:@"请输入文件名"];
        _nameField.borderStyle = UITextBorderStyleBezel;
        _nameField.backgroundColor = [UIColor whiteColor];
    }
    return _nameField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    [self loadSubView];
    [self loadContentView];
}
- (void)loadContentView
{
    [self mergeFiles:self.images];
}
- (void)loadSubView
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
    
    [self.view addSubview:self.nameField];
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sender setTitle:@"保存" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor systemBlueColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(saveFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField);
        make.right.equalTo(self.view).offset(-10);
        make.left.equalTo(self.nameField.mas_right).offset(-10);
        make.bottom.equalTo(self.nameField);
    }];
}
- (void)mergeFiles:(NSMutableArray*)files
{
    UIImage *first = [files objectAtIndex:0];
    NSData *firstData = UIImageJPEGRepresentation(first, 1.0);
    NSMutableArray *filePaths = [[NSMutableArray alloc]init];
    _preview = [[DJContentView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.height - k_TabBar_Height - 20) aipFileData:firstData];
    
    for (int i = 1; i<files.count; i++) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"合并图片-%d.jpg",i]];
        NSData *data = UIImageJPEGRepresentation([files objectAtIndex:i], 1.0);
        [data writeToFile:filePath atomically:YES];
        [filePaths addObject:filePath];
    }
    [_preview mergeFiles:filePaths];
    [self.view addSubview:_preview];
}
- (void)saveFile
{
    if (self.nameField.text.length <= 0) {
        ShowMessage(@"提示", @"请输入文件名", self);
    }else{
        NSString *name = [[_nameField.text componentsSeparatedByString:@"."]firstObject];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",name,self.fileExit]];
        [self.preview saveToFile:filePath];
        [[CSCoreDataManager shareManager] writeSourceFile:filePath];
        GotoMainRootController;
    }
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
