//
//  UFIssueRow.m
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UFIssueRow.h"

@implementation UFIssueRow
- (NSMutableArray*)files
{
    if (!_files) {
        _files = [[NSMutableArray alloc]init];
    }
    return _files;
}
- (void)sendFiles
{
    @WeakObj(self);
    if (self.fileSelected) {
        self.fileSelected(weakself.files);
    }
}
@end
