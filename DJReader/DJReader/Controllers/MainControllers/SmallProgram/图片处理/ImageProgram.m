//
//  ImageProgram.m
//  DJReader
//
//  Created by Andersen on 2021/3/11.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "ImageProgram.h"
#import "ZBWPhotosManager.h"
#import "ImagePreviewController.h"
#import <DJContents/DJContents.h>
#import "CSShareManger.h"

@interface ImageProgram ()
@property (nonatomic,strong)NSMutableArray *images;
@end

@implementation ImageProgram

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContentView];
    self.images = [[NSMutableArray alloc]init];
    [self.view bringSubviewToFront:self.programBar];
}
- (void)loadContentView
{
    CGFloat interval = 20.0;
    NSString *mainTitle = @"";
    self.backgroundColor = [UIColor systemBlueColor];
    self.tips = @[@"● 支持将JPG、PNG等图片转换为PDF，OFD文件",@"● 非会员可免费转换5张图片生成PDF，OFD"];
    if ([self.programName isEqualToString:ProgramName_imagesConvertPDF]) {
        mainTitle = @"PDF";
        self.backgroundColor = [UIColor colorWithRed:239/255.0 green:126/255.0 blue:121/255.0 alpha:1.0];
    }else{
        mainTitle = @"OFD";
        self.backgroundColor = [UIColor colorWithRed:118/255.0 green:190/255.0 blue:249/255.0 alpha:1.0];
    }
    
    CGFloat unit = self.view.height/10;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, unit*3)];
    self.headView.backgroundColor = self.backgroundColor;
    [self.view addSubview:self.headView];
    
    self.desView = [[UIView alloc]initWithFrame:CGRectMake(0, unit*3, self.view.width, unit*7)];
    self.desView.backgroundColor = CSWhiteBackgroundColor;
    [self.view addSubview:self.desView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = [NSString stringWithFormat:@"图片转%@",mainTitle];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:20];
    [self.headView addSubview:titleLable];
    
    UILabel *descriptLable = [[UILabel alloc]init];
    descriptLable.text = @"方便保存、打印和分享";
    descriptLable.textColor = [UIColor whiteColor];
    descriptLable.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:descriptLable];
    
    NSString *imageName = [NSString stringWithFormat:@"%@_head",self.programName];
    UIImageView *descriptView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    descriptView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headView addSubview:descriptView];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(20);
        make.top.equalTo(self.headView.mas_top).offset(k_NavBar_Height*1.5);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(self.headView.width/2 - 20));
    }];
    [descriptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(interval);
        make.top.equalTo(titleLable.mas_bottom).offset(10);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(self.headView.width/2 - 20));
    }];
    [descriptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_centerY);
        make.right.equalTo(self.headView).offset(-interval*2);
        make.height.mas_equalTo(unit);
        make.width.mas_equalTo(unit);
    }];
    
    UIImageView *headView_02 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"开通VIP"]];
    headView_02.contentMode = UIViewContentModeScaleAspectFill;
    [self.desView addSubview:headView_02];
    
    UILabel *descriptLable_02 = [[UILabel alloc]init];
    descriptLable_02.text = @"开通会员，转换数量不受限制";
    descriptLable_02.font = [UIFont systemFontOfSize:12];
    [self.desView addSubview:descriptLable_02];
    
    UIButton *openVIP = [[UIButton alloc]init];
    [openVIP setTitle:@"开通" forState:UIControlStateNormal];
    openVIP.backgroundColor = [UIColor systemRedColor];
    [openVIP addTarget:self action:@selector(openVIP) forControlEvents:UIControlEventTouchUpInside];
    [openVIP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openVIP.titleLabel.font = [UIFont systemFontOfSize:14];
    openVIP.layer.masksToBounds = YES;
    openVIP.layer.cornerRadius = 8;
    [self.desView addSubview:openVIP];
    
    [headView_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desView).offset(interval);
        make.height.mas_equalTo(@(20));
        make.top.equalTo(self.desView).offset(interval);
        make.width.mas_equalTo(@(20));
    }];
    [openVIP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.desView.mas_right).offset(-interval);
        make.centerY.equalTo(headView_02);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    [descriptLable_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView_02.mas_right).offset(5);
        make.height.mas_equalTo(@(44));
        make.centerY.equalTo(headView_02);
        make.right.equalTo(openVIP);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.desView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desView).offset(interval/2);
        make.right.equalTo(self.desView).offset(-interval/2);
        make.height.mas_equalTo(@(1));
        make.top.equalTo(headView_02.mas_bottom).offset(interval);
    }];
    
    UILabel *tipHead = [[UILabel alloc]init];
    tipHead.text = @"功能介绍";
    tipHead.font = [UIFont systemFontOfSize:16];
    [self.desView addSubview:tipHead];
    [tipHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desView).offset(interval);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    UILabel *tip_01 = [[UILabel alloc]init];
    tip_01.text = [NSString stringWithFormat:@"● 支持将JPG、PNG等图片转换为PDF，OFD文件"];
    tip_01.font = [UIFont systemFontOfSize:12];
    tip_01.textColor = [UIColor grayColor];;
    [self.desView addSubview:tip_01];
    [tip_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desView).offset(interval);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.desView.width - 20);
        make.top.equalTo(tipHead.mas_bottom);
    }];
    UILabel *tip_02 = [[UILabel alloc]init];
    tip_02.text = [NSString stringWithFormat:@"● 非会员可免费转换5张图片生成PDF，OFD"];
    tip_02.font = [UIFont systemFontOfSize:12];
    tip_02.textColor = [UIColor grayColor];
    [self.desView addSubview:tip_02];
    [tip_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desView).offset(interval);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self.desView.width - 20);
        make.top.equalTo(tip_01.mas_bottom);
    }];
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sender setTitle:@"选择图片" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(photoSelected) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(20, self.view.height - k_TabBar_Height, self.view.width - 40, 40);
    sender.backgroundColor = [UIColor systemBlueColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3.0;
    [self.view addSubview:sender];
}
- (void)openVIP
{
    [super openVIP];
}
- (void)photoSelected
{
    @WeakObj(self)
    NSInteger max = 5;
    if ([[DJReadManager shareManager]isVIP]) {
        max = 500;
    }
    [ZBWPhotosManager showPhotosManager:self withMaxImageCount:max withAlbumArray:^(NSMutableArray<ZBWPhotoModel *> * _Nonnull albumArray) {
        NSMutableArray *files = [[NSMutableArray alloc]init];
        for (ZBWPhotoModel *model in albumArray) {
            [files addObject:model.highDefinitionImage];
        }
        weakself.images = files;
        [weakself gotoPreviewController];
    }];
}
- (void)gotoPreviewController
{
    ImagePreviewController *imagePreview = [[ImagePreviewController alloc]init];
    imagePreview.images = self.images;
    if ([self.programName isEqualToString:ProgramName_imagesConvertOFD]) {
        imagePreview.fileExit = @"ofd";
    }else{
        imagePreview.fileExit = @"pdf";
    }
    imagePreview.modalPresentationStyle = 0;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePreview];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)mergeFiles:(NSMutableArray*)files
{
    UIImage *first = [files objectAtIndex:0];
    NSData *firstData = UIImageJPEGRepresentation(first, 1.0);
    NSMutableArray *filePaths = [[NSMutableArray alloc]init];
    DJContentView *contentView = [[DJContentView alloc]initWithFrame:self.view.bounds aipFileData:firstData];
    
    for (int i = 1; i<files.count; i++) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"合并图片-%d.jpg",i]];
        NSData *data = UIImageJPEGRepresentation([files objectAtIndex:i], 1.0);
        [data writeToFile:filePath atomically:YES];
        [filePaths addObject:filePath];
    }
    [contentView mergeFiles:filePaths];
    [self.view addSubview:contentView];
}
- (void)programShare
{
    UIImage *image = [self drawShareWithTips:self.tips];
    [CSShareManger shareActivityController:self withImages:@[image]];
}
@end
