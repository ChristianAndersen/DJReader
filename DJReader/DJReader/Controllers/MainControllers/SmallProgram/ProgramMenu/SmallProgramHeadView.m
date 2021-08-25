//
//  SmallProgramHeadView.m
//  DJReader
//
//  Created by Andersen on 2021/3/11.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramHeadView.h"

@implementation SmallProgramHeadView
- (void)setSectionName:(NSString *)sectionName
{
    _sectionName = sectionName;
    [self loadSubViews];
}
- (void)loadSubViews
{
    [_titleLabel removeFromSuperview];
    [_moreSender removeFromSuperview];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.height/2, self.width/3, self.height/2)];
    _titleLabel.text = _sectionName;
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_titleLabel];
}
- (void)moreClicked
{
    if (self.moreHander) {
        self.moreHander(self.sectionName);
    }
}
@end
