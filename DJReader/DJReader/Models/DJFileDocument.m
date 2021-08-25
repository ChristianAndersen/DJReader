//
//  DJFileDocument.m
//  DJReader
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJFileDocument.h"
#import "DJFloder.h"
@implementation DJFileDocument
- (instancetype)init
{
    if (self = [super init]) {
        _superFloders = [[NSMutableArray alloc]init];
    }
    return self;
}
- (NSString*)fileExt
{
    NSString *fileExt = [[_filePath componentsSeparatedByString:@"."]lastObject];
    return fileExt;
}
@end
