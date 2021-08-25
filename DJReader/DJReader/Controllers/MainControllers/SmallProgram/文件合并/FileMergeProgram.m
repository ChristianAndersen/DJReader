//
//  FileMergeProgram.m
//  DJReader
//
//  Created by Andersen on 2021/6/3.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileMergeProgram.h"
#import "FileSelectController.h"

@interface FileMergeProgram ()

@end

@implementation FileMergeProgram

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)fileSelected
{
    FileSelectController *selectController = [[FileSelectController alloc]init];
    selectController.isMultiSelect = YES;
    selectController.fileFilterCondition = self.fileFilterCondition;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectController];
    nav.modalPresentationStyle = 0;
    selectController.programName = self.programName;
    selectController.fileMultiSelectHander = ^(NSArray<DJFileDocument *> * _Nonnull fileModels) {
        
    };
    [self presentViewController:nav animated:YES completion:nil];
}
@end
