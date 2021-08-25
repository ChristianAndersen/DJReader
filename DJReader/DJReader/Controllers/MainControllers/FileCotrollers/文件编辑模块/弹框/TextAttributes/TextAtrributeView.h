//
//  TextAtrributeView.h
//  DJReader
//
//  Created by Andersen on 2020/3/11.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJContents/DJContents.h>
NS_ASSUME_NONNULL_BEGIN

@interface TextAtrributeView : UIView

@property (nonatomic,weak)DJContentView *contentView;

@property (nonatomic,copy)NSString *fontNum;
@property (nonatomic,copy)NSString *fontName;
@property (nonatomic,copy)NSString *isBlod;
@property (nonatomic,strong)UIColor *fontColor;

@end

NS_ASSUME_NONNULL_END
