//
//  FilesListView.h
//  DJReader
//
//  Created by Andersen on 2020/3/6.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FilesListView;

@protocol FilesListViewDelegate <NSObject>
@optional
- (void)filesListView:(FilesListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface FilesListView : UIView
@property (nonatomic,weak)id <FilesListViewDelegate>fileDelegate;
@end

NS_ASSUME_NONNULL_END
