//
//  CSWXAPIManager.m
//  DJReader
//
//  Created by Andersen on 2021/8/4.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "CSWXAPIManager.h"

@implementation CSWXAPIManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static CSWXAPIManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}
- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}
- (void)sendLinkContent:(NSString *)urlString Title:(NSString *)title Description:(NSString *)description AtScene:(enum WXScene)scene completion:(void (^ __nullable)(BOOL success))completion{
    if (![WXApi isWXAppInstalled])
        return;
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    message.mediaObject = ext;
    message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"AppIcon"]);

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
    [WXApi sendReq:req completion:completion];
}
@end
