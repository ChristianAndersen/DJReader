//
//  DJFileDetailsViewController.h
//  DJReader
//
//  Created by liugang on 2020/3/19.
//  Copyright © 2020 Andersen. All rights reserved.
//
#define ChangeName @"重命名"
#define DeletedFile @"删除"
#define AddStar @"添加标星"
#define ShareFile @"分享"
#define DeletedStar @"删除标星"
#define ChangeFilePDF @"转PDF"
#define ChangeFileOFD @"转OFD"
#define ImportImages @"逐页输出图片"
#define ImportLongImage @"输出为长图片"

#define ShareFile_Image @"分享"
#define ChangeName_Image @"操作_重命名"
#define DeletedFile_Image @"操作_删除"
#define StarFile_Image @"操作_标星"
#define ChangeFilePDF_Image @"操作_转PDF"
#define ChangeFileOFD_Image @"操作_转OFD"

#define ImportImages_Image @"操作_逐页输出图片"
#define ImportLongImage_Image @"操作_输出为长图片"

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"

NS_ASSUME_NONNULL_BEGIN

@class DJFileDetailsViewController;
@protocol DJFileDetailsViewControllerDelegate <NSObject>
@optional
//重命名
- (void)fileDetailsViewController:(DJFileDetailsViewController *)tabelView newName:(NSString *)name;
@end

@interface DJFileDetailsViewController : UIViewController
@property (nonatomic,strong)DJFileDocument *fileModel;
@property (nonatomic,copy) void(^seleted)(NSString *title);
@property (nonatomic,weak) id <DJFileDetailsViewControllerDelegate> fileDetailsVcDelegate;
- (instancetype)initWithItems:(NSMutableArray*)items andImages:(NSMutableArray*)itemsImage;
- (void)addOption:(NSArray*)option;
- (void)itemClicked:(void(^)(NSString*title))clicked;
@end

NS_ASSUME_NONNULL_END
