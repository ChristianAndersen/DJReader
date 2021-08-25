//
//  CSWXAPIManager.h
//  DJReader
//
//  Created by Andersen on 2021/8/4.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CSWXAPIDelegate <NSObject>
@optional
- (void)wxAuthSucceed:(NSString*)code;
- (void)wxAuthDenied;
- (void)wxAuthCancel;
@end

@interface CSWXAPIManager : NSObject
@property (nonatomic, assign) id<CSWXAPIDelegate, NSObject> delegate;
+ (instancetype)sharedManager;
- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                AtScene:(enum WXScene)scene
             completion:(void (^ __nullable)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
