//
//  UFIssueFileItem.h
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFIssueFileItem : UICollectionViewCell
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)void (^imageAdd)(void);
@property (nonatomic,copy)void (^imageDelete)(void);
- (void)loadAddItem;
- (void)loadFileItem:(UIImage*)file;
@end

NS_ASSUME_NONNULL_END
