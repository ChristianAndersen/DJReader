//
//  main.m
//  DJReader
//
//  Created by Andersen on 2020/3/4.
//  Copyright © 2020 Andersen. All rights reserved.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
