//
//  CSImagePickerModel.h
//  DJReader
//
//  Created by Andersen on 2021/1/6.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSImagePickerModel : NSObject
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, assign) NSInteger row;
@end

NS_ASSUME_NONNULL_END
