//
//  FileSelectController.h
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"
NS_ASSUME_NONNULL_BEGIN

@interface FileSelectController : UIViewController
@property (nonatomic,copy)void(^fileMultiSelectHander)(NSArray <DJFileDocument*>*fileModels);
@property (nonatomic,copy)void(^fileSelectHander)(DJFileDocument *fileModel);
@property (nonatomic,copy)NSString *programName;
@property (nonatomic,assign)BOOL isMultiSelect;
@property (nonatomic,copy)NSString *fileFilterCondition;

@end

NS_ASSUME_NONNULL_END
