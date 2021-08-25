//
//  UFIssueRow.h
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UFKit/UFKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFIssueRow : UFRow
@property (nonatomic,strong)NSMutableArray *files;
@property (nonatomic,copy)void(^fileSelected)(NSMutableArray*array);
- (void)sendFiles;
@end

NS_ASSUME_NONNULL_END
