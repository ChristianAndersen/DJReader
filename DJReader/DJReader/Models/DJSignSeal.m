//
//  DJSignSeal.m
//  DJReader
//
//  Created by Andersen on 2020/9/24.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJSignSeal.h"
#import "DJFileManager.h"
@implementation DJSignSeal
- (UIImage*)sealImage
{
    if (!self.imgPreview)
        return nil;
    
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:self.imgPreview options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *sign = [[UIImage alloc]initWithData:imageData];
    return sign;
}
- (NSString*)path
{
    NSData *sealData = [[NSData alloc]initWithBase64EncodedString:self.sealData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *path = [DJFileManager pathInUserDirectoryWithFileName:self.sealName];
    [sealData writeToFile:path atomically:YES];
    return path;
}
@end
