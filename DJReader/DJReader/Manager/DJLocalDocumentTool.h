//
//  DJLocalDocumentTool.h
//  DJReader
//
//  Created by liugang on 2020/4/01.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocalDocumentFinish)(NSArray<NSURL *> *urls);
typedef void(^LocalOpenURL)(void);

@interface DJLocalDocumentTool : NSObject
+ (DJLocalDocumentTool *)shareDJLocalDocumentTool;
- (void)seleDocumentWithDocumentTypes:(NSArray <NSString *>*)allowedUTIs Mode:(UIDocumentPickerMode)mode controller:(UIViewController *)vc finishBlock:(LocalDocumentFinish)seleFinish;

@end

NS_ASSUME_NONNULL_END
