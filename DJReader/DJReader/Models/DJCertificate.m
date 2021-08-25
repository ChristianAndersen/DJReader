//
//  DJCertificate.m
//  DJReader
//
//  Created by Andersen on 2020/8/13.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJCertificate.h"

@implementation DJCertificate
+ (NSString*)getCaProvider:(NSString*)caProvider
{
    NSDictionary*caProviders = @{
        @"1":@"广州CA",
        @"2":@"天威诚信",
        @"3":@"世纪速码",
        @"4":@"cfca",
        @"5":@"netca",
        @"6":@"深圳ca",
    };
    return [caProviders objectForKey:caProvider];
}
@end
