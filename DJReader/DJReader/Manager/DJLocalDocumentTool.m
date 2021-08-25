//
//  DJLocalDocumentTool.m
//  DJReader
//
//  Created by liugang on 2020/4/01.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJLocalDocumentTool.h"
@interface DJLocalDocumentTool()<UIDocumentPickerDelegate>
@property (nonatomic, copy) LocalDocumentFinish seleFinish;
@property (nonatomic, copy) LocalOpenURL openURL;
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation DJLocalDocumentTool
+ (DJLocalDocumentTool *)shareDJLocalDocumentTool
{
    static DJLocalDocumentTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DJLocalDocumentTool alloc] init];
    });
    return instance;
}
- (void)seleDocumentWithDocumentTypes:(NSArray<NSString *> *)allowedUTIs Mode:(UIDocumentPickerMode)mode controller:(UIViewController *)vc finishBlock:(LocalDocumentFinish)seleFinish
{
    /*
     UIDocumentPickerModeImport: Import从提供者那里获得文件并拷贝到我们的host app。最经典的应用场景是在内容创建类应用中的使用。例如，像keynote、PowerPoint这样的演示制作应用，希望导入图片，视频，以及音频。它们希望拷贝一份这些数据以此保证它们随时可用。
     UIDocumentPickerModeOpen: 和import一样，open同样从文件提供者那里获得数据并导入我们的host app，只是不同的是，这些数据没有被拷贝一份至我们的host app,数据还在原处。例如，你或许在音乐播放器、视频播放器，再或者图像编辑器中使用该方式。
     UIDocumentPickerModeExportToService: Export使我们的host app可以保存文件至其它提供者。例如，这些提供者可能是常用的像Dropbox、iCloud Drive这样的云存储系统。host app可以通过export保存文件到提供者的存储空间。在接下来的编辑器例子中，当用户完成编辑，他们可以导出文件，然后稍后可以在其它app中打开这些文件。
     UIDocumentPickerModeMoveToService: 除了host app不会持有一份儿文件的拷贝，其它Moving和export差不多。这或许是最不常用的操作，因为大多数iOS apps不是为了抛弃它们的数据才创建的。
     */
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:mode];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.delegate = self;
    _vc = vc;
    _seleFinish = seleFinish;
    [vc presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIDocumentPickerDelegate -
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{ 
    if (self.seleFinish) {
         self.seleFinish(urls);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc 
{
    _seleFinish = nil;
}
@end
