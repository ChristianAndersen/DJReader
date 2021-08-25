//
//  FileBrowseController.h
//  DJReader
//
//  Created by Andersen on 2021/6/29.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJFileDocument.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileBrowseController : UIViewController
@property (nonatomic,strong)DJFileDocument *file;
@end

NS_ASSUME_NONNULL_END
