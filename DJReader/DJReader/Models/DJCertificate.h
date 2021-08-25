//
//  DJCertificate.h
//  DJReader
//
//  Created by Andersen on 2020/8/13.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJCertificate : NSObject
@property (nonatomic,copy)NSString*certid,*bussinessCode,*signCertSerial, *dn,*caProvider,*certname,*creattime,*version,*starttime,*endtime,*algorithm,*certtype;
@property (nonatomic,copy)NSString *signCert;
@property (nonatomic,assign)int certstatus;
+ (NSString*)getCaProvider:(NSString*)caProvider;
@end

NS_ASSUME_NONNULL_END
