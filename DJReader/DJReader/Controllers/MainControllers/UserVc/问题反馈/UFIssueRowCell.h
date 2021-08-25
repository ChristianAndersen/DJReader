//
//  UFIssueRowCell.h
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UFKit/UFKit.h>
#import "UFIssueRow.h"
NS_ASSUME_NONNULL_BEGIN

@interface UFIssueRowCell : UFRowCell
@property (nonatomic, strong) UICollectionView *mainview;
@property (nonatomic, strong) UFIssueRow *cusRow;
@end

NS_ASSUME_NONNULL_END
