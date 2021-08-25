//
//  SmallProgramCollectionView.h
//  DJReader
//
//  Created by Andersen on 2021/6/2.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallProgramCollectionView : UIView
@property (nonatomic,copy)NSString* fileExt;
@property (nonatomic,copy)void (^itemClicked)(NSString*programName);
- (void)loadProgramData:(NSMutableDictionary*)data withFileExt:(NSString*)fileExt;
@end

NS_ASSUME_NONNULL_END
