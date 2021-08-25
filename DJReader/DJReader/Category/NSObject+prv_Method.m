//
//  NSObject+prv_Method.m
//  DJReader
//
//  Created by Andersen on 2020/3/24.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "NSObject+prv_Method.h"
#import "AppDelegate.h"

@implementation NSObject (prv_Method)
//强制横竖屏切换屏
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (orientation == UIInterfaceOrientationLandscapeRight ||orientation == UIInterfaceOrientationLandscapeLeft) {
        app.shouldLandscape = 1;
    }else{
        app.shouldLandscape = 0;
    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (int)orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
