//
//  DJFolderCell.m
//  文件操作
//
//  Created by liugang on 2020/3/12.
//  Copyright © 2020 刘刚. All rights reserved.
//

#import "DJFolderCell.h"
#import "Masonry.h"

#define iconClearance 20

@interface DJFolderCell()

@property (nonatomic,strong) UIImageView * folderImageView;//文件夹图标
@property (nonatomic,strong) UILabel * folderNameLabel;//文件名称
@property (nonatomic,strong) UIImageView * folderGoImageView;//跳转箭头
@property (nonatomic,strong) UIButton * btnAction;//功能键

@end

@implementation DJFolderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //取消选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

//点击文件夹操作
-(void)folderOperationAction{
    if (self.folderOperation) {
        self.folderOperation();
    }
}

#pragma mark - 搭建界面 -
-(void)setupUI{
    [self.folderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(iconClearance);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.folderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.folderImageView.mas_trailing).mas_equalTo(iconClearance);
    }];
}

#pragma mark - 懒加载 -
-(UIImageView *)folderImageView{
    if (!_folderImageView) {
        _folderImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_folderImageView];
    }
    return _folderImageView;
}

//文件夹名
-(UILabel *)folderNameLabel{
    if (!_folderNameLabel) {
        _folderNameLabel = [[UILabel alloc]init];
        [_folderNameLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_folderNameLabel setText:@"文件夹"];
        [self.contentView addSubview:_folderNameLabel];
    }
    return _folderNameLabel;
}

//跳转箭头
-(UIImageView *)folderGoImageView{
    if (!_folderGoImageView) {
        _folderGoImageView = [[UIImageView alloc]init];
        _folderGoImageView.image = [UIImage imageNamed:@"dj_tzjt"];
        [self.contentView addSubview:_folderGoImageView];
    }
    return _folderGoImageView;
}

//功能键
-(UIButton *)btnAction{
    if (!_btnAction) {
        _btnAction = [[UIButton alloc]init];
        [_btnAction setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [_btnAction addTarget:self action:@selector(folderOperationAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnAction];
    }
    return _btnAction;
}

#pragma mark - 设置数据源 -
-(void)setDJFolderCellData:(DJFloder *)folderModel{
    _folderNameLabel.text = folderModel.name;
    if ([folderModel.name isEqualToString:@"本地文件"]) {
        _folderImageView.image = [UIImage imageNamed:@"dj_bdfolder"];
    }else if([folderModel.name isEqualToString:@"最近浏览"]){
        _folderImageView.image = [UIImage imageNamed:@"dj_zjllfolder"];
    }else if([folderModel.name isEqualToString:@"收藏"]){
        _folderImageView.image = [UIImage imageNamed:@"dj_scfolder"];
    }
}
@end
