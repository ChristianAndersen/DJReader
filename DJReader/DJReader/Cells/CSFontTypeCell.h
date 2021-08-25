//
//  CSFontTypeCell.h
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSFontTypeCell : UICollectionViewCell
- (void)setFontName:(NSString*)name;
- (void)setItemSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
