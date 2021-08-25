//
//  DJFileTableViewCell.m
//  文件操作
//
//  Created by liugang on 2020/3/17.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "DJFileTableViewCell.h"
#import "Masonry.h"
#import "UIButton+EnlargeTouchArea.h"
#import "DJFileManager.h"
#define controlClearance 25

@interface DJFileTableViewCell()

@property (nonatomic,strong) UIImageView * fileImageView;//文件夹图标
@property (nonatomic,strong) UILabel * fileNameLabel;//文件名称
@property (nonatomic,strong) UILabel * fileCreationTimeLabel;//创建时间
@property (nonatomic,strong) UILabel * fileSizeLabel;//文件大小
@property (nonatomic,strong) UIImageView * starImageView;//标星
@property (nonatomic,assign) BOOL operational;

@end


@implementation DJFileTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isOperational:(BOOL)operational{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _operational = operational;
        //取消选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - 搭建界面 -
-(void)setupUI{
    [self.fileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(controlClearance);
        make.height.width.mas_equalTo(40);
    }];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImageView);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance/2);
    }];
    [self.fileCreationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fileImageView.mas_bottom);
        make.leading.equalTo(self.fileImageView.mas_trailing).offset(controlClearance/2);
    }];
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileCreationTimeLabel.mas_top);
        make.leading.equalTo(self.fileCreationTimeLabel.mas_trailing).offset(controlClearance/2);
    }];
    if (_operational) {
        [self.fileExpandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView.mas_trailing).mas_equalTo(-controlClearance/2);
            make.width.height.mas_equalTo(controlClearance);
        }];
    }
    if (_operational) {
        [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.fileExpandButton.mas_left).mas_equalTo(-controlClearance/2);
            make.width.height.mas_equalTo(controlClearance);
        }];
    }else{
        [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView.mas_trailing).mas_equalTo(-controlClearance/2);
            make.width.height.mas_equalTo(controlClearance);
        }];
    }
}
#pragma mark - 懒加载 -
- (UIImageView *)fileImageView{
    if (!_fileImageView) {
        _fileImageView = [[UIImageView alloc]init];
        _fileImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_fileImageView];
    }
    return _fileImageView;
}

//功能键
- (UIButton *)fileExpandButton{
    if (!_fileExpandButton) {
        _fileExpandButton = [[UIButton alloc]init];
        [_fileExpandButton setEnlargeEdgeWithTop:controlClearance/1.5 right:controlClearance/1.5 bottom:controlClearance/1.5 left:controlClearance/1.5];
        [_fileExpandButton setBackgroundImage:[UIImage imageNamed:@"dj_gnfolder"] forState:UIControlStateNormal];
        [_fileExpandButton addTarget:self action:@selector(expandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_fileExpandButton];
    }
    return _fileExpandButton;
}
//标星
-(UIImageView *)starImageView{
 if (!_starImageView) {
        _starImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_starImageView];
    }
    return _starImageView;
}
- (UILabel *)fileNameLabel{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc]init];
        [_fileNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_fileNameLabel];
    }
    return _fileNameLabel;
}
- (UILabel *)fileCreationTimeLabel{
    if (!_fileCreationTimeLabel) {
        _fileCreationTimeLabel = [[UILabel alloc]init];
        [_fileCreationTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_fileCreationTimeLabel];
    }
    return _fileCreationTimeLabel;
}
- (UILabel *)fileSizeLabel{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc]init];
        [_fileSizeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_fileSizeLabel];
    }
    return _fileSizeLabel;
}
#pragma mark - 点击事件 -
//点击功能键事件
-(void)expandBtnAction:(UIButton *)fileExpandBtn
{
    if (self.fileExpandBtn) {
        self.fileExpandBtn(fileExpandBtn);
    }
}
#pragma mark - Data数据 -
//文件名数据
-(void)setDJFolderCellData:(DJFileDocument *)floderModel{
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
    _fileCreationTimeLabel.text = [DJFileManager getFileModificationDate:floderModel.filePath];//文件打开时间
    _fileSizeLabel.text = [NSString getDataLengthWithLengStr:floderModel.length];//文件大小
    
    if (floderModel.star) {
        _starImageView.hidden = NO;
        _starImageView.image = [UIImage imageNamed:@"标星_selected"];
    }else{
        _starImageView.hidden = YES;
        _starImageView.image = [UIImage imageNamed:@"nil"];
    }
}
@end
