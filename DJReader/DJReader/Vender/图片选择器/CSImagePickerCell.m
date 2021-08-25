//
//  CSImagePickerCell.m
//  DJReader
//
//  Created by Andersen on 2021/1/6.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "CSImagePickerCell.h"
#define rowCount 4.f
@implementation CSImagePickerCell
- (void)setModel:(CSImagePickerModel *)model
{
    [self.num removeFromSuperview];
    [self.imageView removeFromSuperview];
    
    CGFloat width = (self.contentView.width - 20);
    CGFloat height = (self.contentView.height - 20);
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, width, height)];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = 1;
    [self.contentView addSubview:_imageView];
    _imageView.image = [[UIImage alloc]initWithContentsOfFile:model.imagePath];
    
    _num = [[UILabel alloc]initWithFrame:CGRectMake((self.contentView.width/2)- 20 , height + 8, 40, 10)];
    _num.font = [UIFont systemFontOfSize:10];
    _num.textAlignment = NSTextAlignmentCenter;
    _num.text = [[NSString alloc]initWithFormat:@"%ld",(long)self.row];
    [self.contentView addSubview:_num];
}
-(CSImagePickerBtn *)selectButton {
    if (!_selectButton) {
        _selectButton = [CSImagePickerBtn buttonWithType:UIButtonTypeCustom];
        _selectButton.layer.cornerRadius = 12.5f;
        _selectButton.layer.masksToBounds = YES;
        [_selectButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectedImage) forControlEvents:UIControlEventTouchUpInside];
        //上下左右的各个方向的Insets量
        [_selectButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        CGFloat width = (self.contentView.width - 20);
        [self.contentView addSubview:_selectButton];
        _selectButton.frame = CGRectMake(width - 10, 15, 20, 20);
    }
    [self.contentView bringSubviewToFront:_selectButton];
    return _selectButton;
}
-(void)selectedImage
{
    if (self.action) {
        self.action();
    }
}
#pragma mark - Set方法
-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (_isSelect == NO) {
        [self.selectButton setImage:[UIImage imageNamed:@"imageNormal.png"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setImage:[UIImage imageNamed:@"imageSelected.png"] forState:UIControlStateNormal];
    }
}
@end
