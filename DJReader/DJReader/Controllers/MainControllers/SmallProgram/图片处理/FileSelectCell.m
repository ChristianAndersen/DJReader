//
//  FileSelectCell.m
//  DJReader
//
//  Created by Andersen on 2021/3/15.
//  Copyright © 2021 Andersen. All rights reserved.
//

#import "FileSelectCell.h"
#import "DJFileDocument.h"
#define controlClearance 20
@implementation FileSelectCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isOperational:(BOOL)operational{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (UIImageView *)fileImageView{
    if (!_fileImageView) {
        _fileImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_fileImageView];
    }
    return _fileImageView;
}
- (UILabel *)fileNameLabel{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc]init];
        [_fileNameLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_fileNameLabel];
    }
    return _fileNameLabel;
}
- (UILabel *)fileCreationTimeLabel{
    if (!_fileCreationTimeLabel) {
        _fileCreationTimeLabel = [[UILabel alloc]init];
        [_fileCreationTimeLabel setFont:[UIFont systemFontOfSize:10]];
        _fileCreationTimeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self.contentView addSubview:_fileCreationTimeLabel];
    }
    return _fileCreationTimeLabel;
}
- (UILabel *)fileSizeLabel{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc]init];
        [_fileSizeLabel setFont:[UIFont systemFontOfSize:10]];
        _fileSizeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self.contentView addSubview:_fileSizeLabel];
    }
    return _fileSizeLabel;
}
- (UILabel*)selectLabel
{
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]init];
    }
    return _selectLabel;
}
- (void)setSelectedNum:(NSString*)num
{
    if (num.length > 0) {
        _selectLabel.text = num;
        _selectLabel.backgroundColor = [UIColor systemBlueColor];
        _selectLabel.layer.masksToBounds = YES;
        _selectLabel.layer.cornerRadius = controlClearance/2;
        _selectLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _selectLabel.layer.borderWidth = 1.0;
        _selectLabel.textAlignment = NSTextAlignmentCenter;
        _selectLabel.textColor = [UIColor whiteColor];
    }else{
        _selectLabel.backgroundColor = [UIColor clearColor];
        _selectLabel.layer.masksToBounds = YES;
        _selectLabel.layer.cornerRadius = controlClearance/2;
        _selectLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _selectLabel.layer.borderWidth = 1.0;
        _selectLabel.text = @"";
    }
}
-(void)loadSubViews{
    CGFloat offSet;
    if (self.isMultiSelect) {
        offSet = controlClearance * 2;
        [self.contentView addSubview:self.selectLabel];
        [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(controlClearance/2);
            make.height.width.mas_equalTo(controlClearance);
        }];
        _selectLabel.layer.masksToBounds = YES;
        _selectLabel.layer.cornerRadius = controlClearance/2;
        _selectLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _selectLabel.layer.borderWidth = 1.0;
    }else{
        offSet = controlClearance;
    }
    [self.fileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(offSet);
        make.height.width.mas_equalTo(40);
    }];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImageView).offset(2);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance/2);
    }];
    [self.fileCreationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fileImageView.mas_bottom).offset(-2);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance/2);
    }];
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileCreationTimeLabel.mas_top);
        make.leading.equalTo(self.fileCreationTimeLabel.mas_trailing).offset(controlClearance/3);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileImageView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(1));
        make.bottom.equalTo(self.contentView).offset(-1);
    }];
}
//文件名数据
-(void)setModel:(DJFileDocument *)floderModel{
    [self loadSubViews];

    NSString * path = [floderModel.filePath pathExtension];
    if(path && [path isEqualToString:@"aip"]) {
        _fileImageView.image = [UIImage imageNamed:@"AIP格式"];
    }else if (path && [path isEqualToString:@"ofd"]) {
        _fileImageView.image = [UIImage imageNamed:@"OFD格式"];
    }else if(path && [path isEqualToString:@"pdf"]){
        _fileImageView.image = [UIImage imageNamed:@"PDF格式"];
    }else if(path && ([path isEqualToString:@"xlsx"]||[path isEqualToString:@"xls"])){
        _fileImageView.image = [UIImage imageNamed:@"XLSX格式"];
    }else if(path && ([path isEqualToString:@"docx"]||[path isEqualToString:@"doc"])){
        _fileImageView.image = [UIImage imageNamed:@"DOCX格式"];
    }else if(path && [path isEqualToString:@"ppt"]){
        _fileImageView.image = [UIImage imageNamed:@"PPT格式"];
    }else if(path && [path isEqualToString:@"pptx"]){
        _fileImageView.image = [UIImage imageNamed:@"PPT格式"];
    }else{
        _fileImageView.image = [UIImage imageNamed:@"文件格式未知"];
    }
    _fileNameLabel.text = floderModel.name;//文件名
    _fileCreationTimeLabel.text = [NSString getDateStringWithTimeStr:floderModel.create_time];//文件打开时间
    _fileSizeLabel.text = [NSString getDataLengthWithLengStr:floderModel.length];//文件大小
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
