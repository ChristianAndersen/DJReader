//
//  DrawController.m
//  MyDemos
//
//  Created by dianju on 16/5/3.
//  Copyright © 2016年 Andersen. All rights reserved.
//

#import "DrawController.h"
#import "ADSDrawView.h"
#import <DJContents/ADSFunc.h>
#import "NSObject+prv_Method.h"
#import "AppDelegate.h"
#import "LandSpaceHandAttributeView.h"
#import "UIImage+prv_method.h"
#import "BindPhoneController.h"
#import "DJReadNetManager.h"
#import "CertManagerController.h"
#define FirstOpenKey @"FirstOpenKey"

@interface DrawController () <UIGestureRecognizerDelegate,LandSpaceAttributeDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong)UILabel *tipLab;
@property (nonatomic,strong)LandSpaceHandAttributeView *handAttributeView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic,assign)int curIndex;
@property (nonatomic,strong)UIButton *sign,*takePhoto,*photoAlbum;
@property (nonatomic,strong)UIImageView *sealView;
@property (nonatomic,assign)BOOL isHand;
@end

@implementation DrawController

- (UIImagePickerController*)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    return _picker;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.curIndex = 1;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self orientationToPortrait:UIInterfaceOrientationPortrait];
    [super viewDidDisappear:animated];
}

//支持旋转
-(BOOL)shouldAutorotate{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {//竖屏
        return NO;//不允许竖屏
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {//横屏
        return YES;
    }else{
        return YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
    self.view.backgroundColor = [UIColor drakColor:DrakModeColor lightColor:LightModeColor];
    self.view.userInteractionEnabled = YES;
    [self loadSubviews];
}
- (CGFloat)penWidth
{
    return [DJReadManager shareManager].loginUser.preference.penwidth;
}

- (ColorUnit*)unit
{
    return [DJReadManager shareManager].loginUser.preference.colorUnit;
}

- (void)createDrawView{
    if (!self.drawView) {
        self.drawView=[[ADSDrawView alloc] init];
        self.drawView.color = [UIColor colorWithRed:self.unit.r/255.0 green:self.unit.g/255.0 blue:self.unit.b/255.0 alpha:1.0];
        self.drawView.backgroundColor = [UIColor drakColor:[UIColor colorWithWhite:0.9 alpha:1.0] lightColor:[UIColor whiteColor]];
        self.drawView.penWidth = self.penWidth;
        [self.view addSubview:_drawView];
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        UIButton *clearBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"清除" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"清除"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 10);
            button.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 50);
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self.drawView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-60);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@80);
            make.bottom.equalTo(self.view).with.offset(-80);
        }];
    }else{
        self.drawView.hidden = NO;
    }
}

- (void)loadSubviews
{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 38)];
    _navBar.backgroundColor = [UIColor drakColor:DrakModeColor lightColor:LightModeColor];
    _navBar.layer.masksToBounds = YES;
    _navBar.layer.borderWidth = 1.0;
    _navBar.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    [self.view addSubview:_navBar];
    
    CGFloat landSpaceOffset = 0;
    CGFloat btnWidth = 80;
    CGFloat btnheight = 30;
    
    if (IS_PhoneXAll)
        landSpaceOffset = 43;
    
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@38);
        make.top.equalTo(self.view.mas_top);
    }];
    
    _sign = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sign setTitle:@"手签" forState:UIControlStateNormal];
    _sign.frame = CGRectMake(landSpaceOffset, 0, 80, 30);
    [_sign setTitleColor:RGBACOLOR(28, 95, 168, 1) forState:UIControlStateNormal];
    [_sign setImage:[UIImage imageNamed:@"手签_normal"] forState:UIControlStateNormal];
    [_sign setImage:[UIImage imageNamed:@"手签_selected"] forState:UIControlStateSelected];

    _sign.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/5, btnheight/4, btnWidth/8);
    _sign.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/8, 8, btnWidth/1.5);
    _sign.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sign addTarget:self action:@selector(handSing) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:_sign];
    
    [_sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar);
        make.left.equalTo(self.navBar).offset(landSpaceOffset);
        make.width.mas_equalTo(@(80));
        make.bottom.equalTo(self.navBar);
    }];
//
//    _takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_takePhoto setTitle:@"拍照" forState:UIControlStateNormal];
//    _takePhoto.frame = CGRectMake(landSpaceOffset, 0, 80, 30);
//    [_takePhoto setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
//    [_takePhoto setImage:[UIImage imageNamed:@"拍照_normal"] forState:UIControlStateNormal];
//
//    _takePhoto.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/5, btnheight/4, btnWidth/8);
//    _takePhoto.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/8, 8, btnWidth/1.5);
//    _takePhoto.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_takePhoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [_navBar addSubview:_takePhoto];
//
//    [_takePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navBar);
//        make.left.equalTo(self.sign.mas_right).offset(20);
//        make.width.mas_equalTo(@(80));
//        make.bottom.equalTo(self.navBar);
//    }];
//
//    _photoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_photoAlbum setTitle:@"相册" forState:UIControlStateNormal];
//    _photoAlbum.frame = CGRectMake(landSpaceOffset, 0, 80, 30);
//    [_photoAlbum setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
//    [_photoAlbum setImage:[UIImage imageNamed:@"相册_normal"] forState:UIControlStateNormal];
//    _photoAlbum.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/5, btnheight/4, btnWidth/8);
//    _photoAlbum.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/8, 8, btnWidth/1.5);
//    _photoAlbum.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_photoAlbum addTarget:self action:@selector(openPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    [_navBar addSubview:_photoAlbum];
//
//    [_photoAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navBar);
//        make.left.equalTo(self.takePhoto.mas_right).offset(20);
//        make.width.mas_equalTo(@(80));
//        make.bottom.equalTo(self.navBar);
//    }];

    UIButton *complete = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete setTitle:@"完成" forState:UIControlStateNormal];
    complete.frame = CGRectMake(self.view.width - landSpaceOffset - 80, 0, 80, 30);

    complete.layer.masksToBounds = YES;
    complete.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    complete.layer.borderWidth = 1.0;
    [complete setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    [complete setImage:[UIImage imageNamed:@"完成_normal"] forState:UIControlStateNormal];
    complete.titleEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/8, btnheight/4, btnWidth/8);
    complete.imageEdgeInsets = UIEdgeInsetsMake(btnheight/4, btnWidth/8, btnheight/4, btnWidth*5/8);
    complete.titleLabel.font = [UIFont systemFontOfSize:10];
    [complete setBackgroundImage:ImageWithColor([UIColor colorWithWhite:0.8 alpha:1]) forState:UIControlStateSelected];
    [complete addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:complete];
    [complete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar);
        make.right.equalTo(self.navBar).offset(-landSpaceOffset);
        make.width.mas_equalTo(@(80));
        make.bottom.equalTo(self.navBar);
    }];
}
- (UIImageView*)sealView
{
    if (!_sealView) {
        _sealView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, self.view.width -200, 300)];
        _sealView.contentMode = 1;
        [self.view addSubview:_sealView];
        
        [_sealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom).offset(40);
            make.right.equalTo(self.view).offset(100);
            make.left.equalTo(self.view).offset(-100);
            make.bottom.equalTo(self.view).offset(-64);
        }];
    }
    return _sealView;
}
- (void)waiting
{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x -100, self.view.center.y-30, 200, 60)];
        _tipLab.font = [UIFont systemFontOfSize:30];
        _tipLab.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_tipLab];
        
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(@400);
            make.height.mas_equalTo(@100);
        }];
        _tipLab.text = @"请在此处签名";
    }
    _tipLab.hidden = NO;
}
- (void)handSing
{
    self.curIndex = 1;
}
- (void)openPhotoAlbum:(UIButton*)sender
{
    sender.selected = !sender.selected;
    self.curIndex = 3;
}
- (void)takePhoto:(UIButton*)sender
{
    sender.selected = !sender.selected;
    self.curIndex = 2;
}

- (void)openPhotoAlbumAction
{
    self.sealView.hidden = NO;
    
    BOOL isPicker = NO;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        isPicker = YES;
    }
    
    if (isPicker) {
        [self presentViewController:self.picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)takePhotoAction
{
    self.sealView.hidden = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}
- (void)handSignAction
{
    [self createDrawView];
    [self.handAttributeView show];
}
- (void)handSignEnd
{
    [_handAttributeView dismiss];
    self.drawView.hidden = YES;
}
- (void)photoActionEnd
{
    self.sealView.hidden = YES;
    [self.drawView setNeedsDisplay];
}
- (void)setCurIndex:(int)curIndex
{
    _curIndex = curIndex;
    switch (_curIndex) {
        case 0:
            [self waiting];
            break;
        case 1:
            [self photoActionEnd];
            [self handSignAction];
            break;
        case 2:{
            [self handSignEnd];
            [self takePhotoAction];
        }break;
        case 3:{
            [self handSignEnd];
            [self openPhotoAlbumAction];
        }break;
        default:
            break;
    }
}
- (LandSpaceHandAttributeView*)handAttributeView
{
    if (!_handAttributeView)
    {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        _handAttributeView = [[LandSpaceHandAttributeView alloc]init];
        _handAttributeView.selectorDelegate = self;
        _handAttributeView.contenSize = CGSizeMake(CGRectGetWidth(screenFrame) - 120, CGRectGetHeight(screenFrame) * 0.21);
        _handAttributeView.backgroundColor = [UIColor drakColor:DrakModeColor lightColor:LightModeColor];
    }
    return _handAttributeView;
}

- (UIImage*)getSignImage
{
    if (_sealView.hidden == YES || !_sealView) {
        return [self.drawView saveToGetSignatrueImage];
    }else{
        return self.sealView.image;
    }
}

- (void)clear:(UIButton*)btn{
    [self.drawView clearAllPath];
}

- (void)back{
    UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"创建印章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createSealForRequest];
    }];
    UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"取   消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.handAttributeView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    addTarget(self, action_01, action_02, @"是否使用当前图片创建印章");
}
- (void)createSealForRequest
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *openid = [DJReadManager shareManager].loginUser.openid;
    NSString *phoneNum = [DJReadManager shareManager].loginUser.uphone;
    NSData *data = UIImagePNGRepresentation([self getSignImage]);
    NSString *imgData = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *type = @"2";
    NSString *multiple = @"2";
    [params setValue:openid forKey:@"openid"];
    [params setValue:phoneNum forKey:@"mobile"];
    [params setValue:imgData forKey:@"imgData"];
    [params setValue:type forKey:@"type"];
    [params setValue:multiple forKey:@"multiple"];
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_CeateSeal parameters:params showError:NO reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        if (code == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.handAttributeView removeFromSuperview];
                if (self.imageSelectedBlcok)
                    self.imageSelectedBlcok([self getSignImage]);
            }];
        }else{
            NSString *msg = [NSString stringWithFormat:@"出错原因:%@",service.serviceMessage];
            ShowMessage(@"创建印章出错", msg, self);
        }
    }];
}
- (void)penColorUnitSelected:(ColorUnit *)unit
{
    self.drawView.color = [UIColor colorWithRed:unit.r/255.0 green:unit.g/255.0 blue:unit.b/255.0 alpha:1.0];
}
- (void)penHardChange:(int)penHard
{
    self.drawView.penHard = penHard;
}

- (void)penWidthChange:(int)penWidth
{
    self.drawView.penWidth = penWidth;
}

#pragma PickerDeleagate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _tipLab.hidden = YES;
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageCompress:image targetWidth:self.view.width -200];
    self.sealView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [_photoAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_takePhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.drawView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        }else{
            [_photoAlbum setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [_sign setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [_takePhoto setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            self.drawView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        [_takePhoto setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_sign setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_takePhoto setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.drawView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)dealloc
{
    self.imageSelectedBlcok = nil;
}
@end

