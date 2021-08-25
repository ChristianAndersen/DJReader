//
//  UFIssueFileItem.m
//  DJReader
//
//  Created by Andersen on 2020/8/19.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UFIssueFileItem.h"

@implementation UFIssueFileItem
- (void)setImage:(UIImage *)image
{
    self.backgroundColor = [UIColor systemPinkColor];
    UIImageView * mainView = [[UIImageView alloc]initWithFrame:self.bounds];
    mainView.image = image;
    mainView.userInteractionEnabled = YES;
    [self.contentView addSubview:mainView];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
    [delete addTarget:self action:@selector(addFile) forControlEvents:UIControlEventTouchUpInside];
    [delete setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    delete.frame = CGRectMake(self.width*0.8, 0, self.width * 0.2, self.width * 0.2);
    [mainView addSubview:delete];
}
- (void)loadAddItem
{
    UIButton *addItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"添加相片"];
    [addItem addTarget:self action:@selector(addFile) forControlEvents:UIControlEventTouchUpInside];
    [addItem setBackgroundImage:image forState:UIControlStateNormal];
    addItem.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:addItem];
}
- (void)loadFileItem:(UIImage*)file
{
    self.backgroundColor = [UIColor systemPinkColor];
    UIImageView * mainView = [[UIImageView alloc]initWithFrame:self.bounds];
    mainView.image = file;
    mainView.userInteractionEnabled = YES;
    [self.contentView addSubview:mainView];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
    [delete addTarget:self action:@selector(deleteFile) forControlEvents:UIControlEventTouchUpInside];
    [delete setBackgroundImage:[UIImage imageNamed:@"删除相片"] forState:UIControlStateNormal];
    delete.frame = CGRectMake(self.width - 30, 0, 30, 30);
    [mainView addSubview:delete];
}
- (void)addFile
{
    if (self.imageAdd) {
        self.imageAdd();
    }
}
- (void)deleteFile
{
    if (self.imageDelete) {
        self.imageDelete();
    }
}
- (void)dealloc
{
    _imageAdd = nil;
    _imageDelete = nil;
}
@end
