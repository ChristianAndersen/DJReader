//
//  CSImagePicker.h
//  DJReader
//
//  Created by Andersen on 2021/1/6.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(int, ImportType)
{
    ImportTypeImages,
    ImportTypeLongImage,
};
@interface CSImagePicker : UIViewController
@property (nonatomic,assign)ImportType importType;
@property (nonatomic,strong)DJFileDocument *fileModel;
@property (nonatomic,copy)void (^imageSelected)(NSArray *images);
- (void)loadImages;
@end

NS_ASSUME_NONNULL_END
