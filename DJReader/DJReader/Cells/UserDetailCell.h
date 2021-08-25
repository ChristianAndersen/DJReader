//
//  UserDetailCell.h
//  DJReader
//
//  Created by Andersen on 2020/9/4.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailCell : UITableViewCell
- (void)setLab:(NSString*)title andImage:(UIImage *)image andValue:(NSString*)value;
- (void)addAction:(SEL)action toTargt:(id)target title:(NSString*)title;
- (void)reloadSubView;

@end

NS_ASSUME_NONNULL_END
