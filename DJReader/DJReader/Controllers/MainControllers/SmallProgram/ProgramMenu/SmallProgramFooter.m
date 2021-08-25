//
//  SmallProgramFooter.m
//  DJReader
//
//  Created by Andersen on 2021/3/16.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "SmallProgramFooter.h"

@implementation SmallProgramFooter

- (void)loadSubViews
{
    [self.line removeFromSuperview];
    _line = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.width - 20, 1.0)];
    _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self addSubview:_line];
}
@end
