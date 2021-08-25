//
//  FileProgram.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileProgram.h"
#import "FileSelectController.h"
#import "CSImagePicker.h"
#import "CSShareManger.h"
#import "CSIMagePickerResultVC.h"
@interface FileProgram ()

@end

@implementation FileProgram

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContentView];
    [self.view bringSubviewToFront:self.programBar];
}
- (void)loadContentView
{
    CGFloat interval = 20.0;
    CGFloat unit = self.view.height/10;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, unit*3)];
    self.headView.backgroundColor = self.programColor;
    [self.view addSubview:self.headView];
    
    self.desView = [[UIView alloc]initWithFrame:CGRectMake(0, unit*3, self.view.width, unit*7)];
    self.desView.backgroundColor = CSWhiteBackgroundColor;
    [self.view addSubview:self.desView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = self.programName;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.numberOfLines = 0;
    titleLable.font = [UIFont systemFontOfSize:20];
    [self.headView addSubview:titleLable];
    
    UILabel *detailLable = [[UILabel alloc]init];
    detailLable.text = @"方便打印、分享和保存";
    detailLable.textColor = [UIColor whiteColor];
    detailLable.numberOfLines = 0;
    detailLable.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:detailLable];
    
    NSString *imageName = [NSString stringWithFormat:@"%@_head",self.programName];
    UIImageView *descriptView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    descriptView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headView addSubview:descriptView];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(interval);
        make.centerY.equalTo(self.headView);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(self.headView.width/2));
    }];
    [detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(interval);
        make.top.equalTo(titleLable.mas_bottom).offset(5.0);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(self.headView.width/2));
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
    openVIP.titleLabel.font = [UIFont systemFontOfSize:14];
    [openVIP addTarget:self action:@selector(openVIP) forControlEvents:UIControlEventTouchUpInside];
    [openVIP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    UILabel *curTip = nil;
    for (NSString *descript in self.descripts) {
        UILabel *tip = [[UILabel alloc]init];
        tip.text = descript;
        tip.font = [UIFont systemFontOfSize:12];
        tip.textColor = [UIColor grayColor];;
        [self.desView addSubview:tip];
        if (!curTip) {
            [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.desView).offset(interval);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(self.desView.width - 20);
                make.top.equalTo(tipHead.mas_bottom);
            }];
        }else{
            [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.desView).offset(interval);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(self.desView.width - 20);
                make.top.equalTo(curTip.mas_bottom);
            }];
        }
        curTip = tip;
    }
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sender setTitle:@"选择文件" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(fileSelected) forControlEvents:UIControlEventTouchUpInside];
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
- (void)fileSelected
{
    FileSelectController *selectController = [[FileSelectController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectController];
    nav.modalPresentationStyle = 0;
    selectController.programName = self.programName;
    @WeakObj(self);
    selectController.fileSelectHander = ^(DJFileDocument * _Nonnull fileModel) {
        if ([weakself.programName isEqualToString:ProgramName_images]) {
            [weakself importImages:fileModel];
        }else if([weakself.programName isEqualToString:ProgramName_longImage]){
            [weakself importLongImage:fileModel];
        }
    };
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)importImages:(DJFileDocument*)fileModel
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeImages;
    imagePicker.fileModel = fileModel;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        NSMutableArray *images = [NSMutableArray new];
        for (NSString *path in imagePaths) {
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
            [images addObject:image];
        }
        SaveToCamera(images, self);
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)importLongImage:(DJFileDocument*)fileModel
{
    CSImagePicker *imagePicker = [[CSImagePicker alloc]init];
    imagePicker.importType = ImportTypeLongImage;
    imagePicker.fileModel = fileModel;
    imagePicker.imageSelected = ^(NSArray *imagePaths) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CSIMagePickerResultVC *vc = [[CSIMagePickerResultVC alloc]init];
            vc.resource = imagePaths;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self presentViewController:nav animated:YES completion:nil];
        });
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)programShare
{
    UIImage *image = [self drawShareWithTips:self.tips];
    [CSShareManger shareActivityController:self withImages:@[image]];
    NSLog(@"file program share");
}
@end
