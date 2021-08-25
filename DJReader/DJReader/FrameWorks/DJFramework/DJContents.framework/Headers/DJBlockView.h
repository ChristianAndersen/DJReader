//
//  DJBlockView.h
//  DJContentsExample
//
//  Created by dianju on 16/5/30.
//  Copyright © 2016年 dianju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJBlockView : UIView
@property (nonatomic,assign)float drawWebTime;

- (void)submit;
- (void)cancel;
- (void)deleteBackward;
- (void)cleanBackward;

@end

