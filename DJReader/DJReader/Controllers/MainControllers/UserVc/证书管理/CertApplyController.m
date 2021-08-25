//
//  CertApplyController.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CertApplyController.h"
#import "CSFormTableView.h"
#import "DJReadNetManager.h"



//接口选填
#define OptionKey_Unit @"单位名称"
#define OptionKey_userTitle @"职   位"
#define OptionKey_Region @"地   区"
#define OptionKey_Address @"详细地址"
#define requiredKey_deviceNo @"deviceNo"

//页面上必填项
#define requiredKey_userName @"userName"
#define requiredKey_cardID @"cardID"
#define requiredKey_mobile @"mobile"
#define requiredKey_userEmail @"userEmail" //接口参数此项选填
#define requiredKey_operator @"operator"
#define requiredKey_operatorCardId @"operatorCardId"
#define requiredKey_idcardFrontBase64 @"idcardFrontBase64"
#define requiredKey_idcardBackBase64 @"idcardBackBase64"

//页面上不存在但是接口必填项
#define requiredKey_openid @"openid"
#define requiredKey_certType @"certType"
#define requiredKey_circle @"circle"
#define requiredKey_algorithm @"algorithm"
#define requiredKey_keyLength @"keyLength"
#define requiredKey_caProvider @"caProvider"

@interface CertApplyController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImageView *curCardView,*frontCardView,*backCardView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSMutableDictionary *params,*optionsTitles,*requiredTitles;
@property (strong, nonatomic) UIButton *sure;
@end
@implementation CertApplyController
- (UIImagePickerController*)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    return _picker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人证书申请";
    [self loadData];
    [self loadSubviews];
}
- (void)loadData
{
    NSString *openid = [DJReadManager shareManager].loginUser.openid;

    _params = [[NSMutableDictionary alloc]init];
    _optionsTitles = [[NSMutableDictionary alloc]init];
    _requiredTitles = [[NSMutableDictionary alloc]init];

    //页面必填项标题
    [_requiredTitles setValue:@"客户名称" forKey:requiredKey_userName];
    [_requiredTitles setValue:@"证件号码" forKey:requiredKey_cardID];
    [_requiredTitles setValue:@"联系人手机号" forKey:requiredKey_mobile];
    [_requiredTitles setValue:@"电子邮箱" forKey:requiredKey_userEmail];
    [_requiredTitles setValue:@"经办人姓名" forKey:requiredKey_operator];
    [_requiredTitles setValue:@"经办人证件号码" forKey:requiredKey_operatorCardId];
    [_requiredTitles setValue:@"身份证正面照片" forKey:requiredKey_idcardFrontBase64];
    [_requiredTitles setValue:@"身份证反面照片" forKey:requiredKey_idcardBackBase64];
    //页面选填项标题
    [_optionsTitles setValue:@"单位名称" forKey:OptionKey_Unit];
    [_optionsTitles setValue:@"职   位" forKey:OptionKey_userTitle];
    [_optionsTitles setValue:@"地   区" forKey:OptionKey_Region];
    [_optionsTitles setValue:@"详细地址" forKey:OptionKey_Address];
    
    
    
    [_params setValue:openid forKey:requiredKey_openid];
    [_params setValue:@"1" forKey:requiredKey_certType];
    [_params setValue:@"1" forKey:requiredKey_circle];//有效期1年
    [_params setValue:@"2" forKey:requiredKey_algorithm];//1:RSA 2:SM2 目前只有SM2
    [_params setValue:@"256" forKey:requiredKey_keyLength];//SM2: 256 RSA：1024
    [_params setValue:@"4" forKey:requiredKey_caProvider];//4:CFCA
}
- (void)loadSubviews
{
    _mainView = [[CSFormTableView alloc]initWithFrame:self.view.bounds];
    CSFormSectionModel *sectionModel_01= [[CSFormSectionModel alloc]init];
    sectionModel_01.name = @"证书申请必填项";
    sectionModel_01.type = CSFormSectionTypeRequired;
    [_mainView addSection:sectionModel_01];
    CSFormSectionModel *sectionModel_02= [[CSFormSectionModel alloc]init];
    sectionModel_02.name = @"证书申请选填项";
    sectionModel_02.type = CSFormSectionTypeOption;
    [_mainView addSection:sectionModel_02];
    [self.view addSubview:_mainView];
    
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_userName] placeholder:@"请输入名称" inSection:0 formType:0];
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_cardID] placeholder:@"请输入身份证号" inSection:0 formType:2];
    //[_mainView addRadioRow:@"证书算法类型" items:@[@"SM2",@"RSA"] inSection:0];
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_mobile] placeholder:@"请输入常用手机号" inSection:0 formType:1];
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_userEmail] placeholder:@"请输入电子邮箱" inSection:0 formType:3];
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_operator] placeholder:@"请输入经办人姓名" inSection:0 formType:0];
    [_mainView addTextRow:[_requiredTitles objectForKey:requiredKey_operatorCardId] placeholder:@"请输入经办人证件号" inSection:0 formType:2];
    [_mainView addCustomRow:[_requiredTitles objectForKey:requiredKey_idcardFrontBase64] content:[self cardIDFrontView] inSection:0 formType:4];
    [_mainView addCustomRow:[_requiredTitles objectForKey:requiredKey_idcardBackBase64] content:[self cardIDBackView] inSection:0 formType:4];

    [_mainView addTextRow:[_optionsTitles objectForKey:OptionKey_Unit] placeholder:@"请输入单位名称" inSection:1 formType:0];
    [_mainView addTextRow:[_optionsTitles objectForKey:OptionKey_userTitle] placeholder:@"请输入任职岗位" inSection:1 formType:0];
    [_mainView addTextRow:[_optionsTitles objectForKey:OptionKey_Region] placeholder:@"请输入所属地区" inSection:1 formType:0];
    [_mainView addTextRow:[_optionsTitles objectForKey:OptionKey_Address] placeholder:@"请输入详细地址" inSection:1 formType:0];
    [_mainView addFotterView:[self fotterView]];
}

- (UIView*)cardIDFrontView
{
    UIView *backView = [[UIView alloc]init];
    _frontCardView = [[UIImageView alloc]init];
    _frontCardView.userInteractionEnabled = YES;
    _frontCardView.image = [UIImage imageNamed:@"身份证正面"];
    _frontCardView.contentMode = 1;
    [backView addSubview:_frontCardView];
    [_frontCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(cardFrontSelected) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    return backView;
}

- (UIView*)cardIDBackView
{
    UIView *backView = [[UIView alloc]init];
    _backCardView = [[UIImageView alloc]init];
    _backCardView.userInteractionEnabled = YES;
    _backCardView.image = [UIImage imageNamed:@"身份证反面"];
    _backCardView.contentMode = 1;
    [backView addSubview:_backCardView];
    [_backCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(cardBackSelected) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    return backView;
}
- (UIView*)fotterView
{
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 0, self.view.width, 100);
    self.sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sure addTarget:self action:@selector(sureMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.sure setTitle:@"提交" forState:UIControlStateNormal];
    self.sure.backgroundColor = ControllerDefalutColor;
    [backView addSubview:self.sure];
    [self.sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.mas_equalTo(@(backView.width - 60));
        make.height.mas_equalTo(@(40));
    }];
    return backView;
}

- (void)cardFrontSelected
{
    _curCardView = _frontCardView;
    [self fetchPhoto];
}
- (void)cardBackSelected
{
    _curCardView = _backCardView;
    [self fetchPhoto];
}
- (void)fetchPhoto
{
    @WeakObj(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself takePhotoAction];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself openPhotoAlbumAction];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    addActionsToTarget(self, @[action1,action2,action3]);
}
- (void)openPhotoAlbumAction
{
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
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}
#pragma PickerDeleagate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageCompress:image targetWidth:self.view.width -200];
    self.curCardView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureMsg
{
    NSDictionary *option = self.mainView.optionValue;
    NSDictionary *required = self.mainView.requiredValue;
    for (NSString *key in _requiredTitles.allKeys) {
        [_params setValue:[required objectForKey:[_requiredTitles objectForKey:key]] forKey:key];
    }
    NSString *openid = [_params objectForKey:requiredKey_openid];
    NSString *phone = [_params objectForKey:requiredKey_mobile];
    
    if (openid.length <= 6){
        ShowMessage(@"", @"请先登入微信", self);
        return;
    }
    if (![phone isPhone]){
        ShowMessage(@"", @"请先绑定手机号", self);
        return;
    }
    self.sure.enabled = NO;
    self.sure.alpha=0.4;//透明度
    [DJReadNetShare requestAFN:DJNetPOST urlString:DJReader_CERTApply parameters:_params reponseResult:^(DJService *service) {
        NSInteger code = service.code;
        self.sure.enabled = NO;
        self.sure.alpha = 1.0;
        if (code == 0) {
            showAlert(@"证书申请成功", RootController);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

    NSLog(@"option:%@\r\nrequired:%@",option,required);
}
@end
