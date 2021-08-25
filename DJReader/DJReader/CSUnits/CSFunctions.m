//
//  CSFunctions.m
//  DJReader
//
//  Created by Andersen on 2020/3/31.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFunctions.h"
#import <CommonCrypto/CommonDigest.h>
#import <Photos/Photos.h>

NSString* fileMD5WithPath(NSString *path)
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) return nil;
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);

    BOOL done = NO;
    while (!done) {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if ([fileData length]==0) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",digest[0],digest[1],digest[2], digest[3],digest[4],digest[5],digest[6],digest[7],digest[8], digest[9],digest[10], digest[11],digest[12], digest[13],digest[14], digest[15]];
    return s;
}
void addTarget(UIViewController *vc,UIAlertAction* sureAction,UIAlertAction* cancelAction, NSString *msg)
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController animated:YES  completion:nil];
    });
}
void addActionsToTarget(UIViewController *vc,NSArray<UIAlertAction*>* actions)
{
    CGFloat width = vc.view.width;
    CGFloat height = vc.view.height/3;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertController.popoverPresentationController.sourceView = vc.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, height*2, width, height);

    for (UIAlertAction *action in actions) {
        if ([action isMemberOfClass:[UIAlertAction class]]) {
            [alertController addAction:action];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController animated:YES  completion:nil];
    });
}
void SaveToCamera(NSArray *images,UIViewController *target)
{
    NSError *error = nil;
    NSString *title = @"点聚OFD";
    //查询所有【自定义相册】
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *createCollection = nil;
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        //当前对应的app相册没有被创建,创建一个【自定义相册】
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            //创建一个【自定义相册】
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } error:&error];
        
        for (PHAssetCollection *collection in collections) {
            if ([collection.localizedTitle isEqualToString:title]) {
                createCollection = collection;
                break;
            }
        }
    }
    //先将图片保存到相册
    __block NSMutableArray *placeholders = [[NSMutableArray alloc]init];
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        for (UIImage *image in images) {
            PHObjectPlaceholder *placeholder =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            [placeholders addObject:placeholder];
        }
    } error:&error];
    
    if (error) {
        showAlert(@"图片保存失败", target);
        return;
    }
    //将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];
        [requtes addAssets:placeholders];
    } error:&error];
    if (error) {
        NSString *ergMsg = [[NSString alloc]initWithFormat:@"图片保存失败：%@",error.description];
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"重新导出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [target dismissViewControllerAnimated:YES completion:nil];
        }];
        addTarget(target, action_01, action_02, ergMsg);
    } else {
        UIAlertAction *action_01 = [UIAlertAction actionWithTitle:@"再次选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *action_02 = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [target dismissViewControllerAnimated:YES completion:nil];
        }];
        addTarget(target, action_01, action_02, @"图片导出成功到相册");
    }
}
