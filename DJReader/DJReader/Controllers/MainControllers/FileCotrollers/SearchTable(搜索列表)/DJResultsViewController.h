//
//  DJResultsViewController.h
//  DJReader
//
//  Created by liugang on 2020/3/26.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJResultsViewController : UIViewController<UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^didSelectText)(NSString *selectedText);
@end

NS_ASSUME_NONNULL_END
