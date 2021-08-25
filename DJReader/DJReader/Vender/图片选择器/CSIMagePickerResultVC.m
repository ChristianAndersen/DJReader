//
//  CSIMagePickerResultVC.m
//  DJReader
//
//  Created by Andersen on 2021/1/7.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "CSIMagePickerResultVC.h"
#import "BindPhoneController.h"
#import "SubscribeController.h"
@interface CSIMagePickerResultVC ()
@property (nonatomic,strong)UIScrollView *mainView;
@property (nonatomic,strong)UIImage *produceImage;
@end

@implementation CSIMagePickerResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    UIButton *back =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *cancel = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:@"导出" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(saveCamera) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setResource:(NSArray *)resource
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (NSString *path in resource) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [images addObject:image];
        width = image.size.width;
        height = height + image.size.height;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGFloat heightOffset = 0;
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake(0, heightOffset, width, image.size.height)];
        heightOffset = heightOffset +  image.size.height;
    }
    _produceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize size = _produceImage.size;
    CGFloat vheight = size.height * self.view.width / size.width;
    
    UIImageView *mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, vheight)];
    mainImageView.image = _produceImage;
    _mainView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _mainView.contentSize = CGSizeMake(self.view.width, vheight);
    _mainView.bounces = NO;
    [self.view addSubview:_mainView];
    [_mainView addSubview:mainImageView];
}
- (void)setCameraResource:(NSArray*)resources
{
    CGFloat W = 0.0;
    CGFloat H = 0.0;
    
    NSMutableArray *fileImages = [NSMutableArray new];
    for (int i = 0; i<resources.count; i++) {
        NSString *filePath = [fileImages objectAtIndex:i];
        UIImage *fileImage = [UIImage imageWithContentsOfFile:filePath];
        [fileImages addObject:fileImage];
        W = fileImage.size.width;
        H = fileImage.size.height;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(W, H), NO, [UIScreen mainScreen].scale);
    CGFloat heightOffset = 0;
    for (UIImage *fileImage in fileImages) {
        [fileImage drawInRect:CGRectMake(0, heightOffset, W, fileImage.size.height)];
        heightOffset = heightOffset + fileImage.size.height;
    }
    _produceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize size = _produceImage.size;
    CGFloat vheight = size.height*self.view.width/size.width;
    
    UIImageView *mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, vheight)];
    mainImageView.image = _produceImage;
    _mainView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _mainView.contentSize = CGSizeMake(self.view.width, vheight);
    _mainView.bounces = NO;
    [self.view addSubview:_mainView];
    [_mainView addSubview:mainImageView];
}
- (void)saveCamera
{
    [[DJReadManager shareManager]judgeUser:^(BOOL isLogin) {
        if (!isLogin) {GotoLoginControllerFrom(self);}
    } bindIPhone:^(BOOL bind) {
        if (!bind) {GotoBindPhoneControllerFrom(self);}
    } isVIP:^(BOOL isVIP) {
        if (isVIP) {
            if (self->_produceImage) SaveToCamera(@[self->_produceImage], self);
        }else{
            GotoSubcribeControllerFrom(self);
        }
    }];
}
@end
