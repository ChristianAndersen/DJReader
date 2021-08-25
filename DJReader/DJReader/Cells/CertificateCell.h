//
//  CertificateCell.h
//  DJReader
//
//  Created by Andersen on 2020/8/10.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCertificate.h"
NS_ASSUME_NONNULL_BEGIN

@interface CertificateCell : UITableViewCell
@property (nonatomic,copy)void (^scrollDeleted)(NSIndexPath *indexPath);
@property (nonatomic,strong)DJCertificate *certificate;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
