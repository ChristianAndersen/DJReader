//
//  MenuView.m
//  YHMenu
//
//  Created by Boris on 2018/5/10.
//  Copyright © 2018年 Boris. All rights reserved.
//

#import "MenuView.h"
#import "HEMenuTableCell.h"
#define kHEMenuTableCell @"HEMenuTableCell"
#define YHSafeAreaTopHeight (YHkHeight == 812.f ? 88.f : 64.f)
#define YHkWidth [UIScreen mainScreen].bounds.size.width
#define YHkHeight [UIScreen mainScreen].bounds.size.height
#define kTriangleHeight 10.f //底的1/2倍
#define kTriangleToHeight 10.f  // 三角形的高,
#define kItemHeight 40.f       // item 高
@implementation MenuView
#pragma mark -------控件初始化------------
- (NSMutableArray *)titleSource
{
    if (!_titleSource) {
        self.titleSource = [NSMutableArray array];
    }
    return _titleSource;
}
- (NSMutableDictionary *)selectIndexes
{
    if (!_selectIndexes) {
        self.selectIndexes = [NSMutableDictionary dictionary];
    }
    return _selectIndexes;
}

- (NSMutableArray *)imgSource
{
    if (!_imgSource) {
        self.imgSource = [NSMutableArray array];
    }
    return _imgSource;
}



- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = ({
            UITableView *tableView = [UITableView new];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[HEMenuTableCell class] forCellReuseIdentifier:kHEMenuTableCell];
            tableView.tableFooterView = [UIView new];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView;
        });
    }
    return _tableView;
}

#pragma mark ----------生命周期---------

- (id)initWithFrame:(CGRect)frame menuSize:(CGSize)size point:(CGPoint)point itemSource:(NSDictionary *)itemSource style:(MenuStyle)style action:(void(^)(NSMutableDictionary *indexes))action{
    self = [super initWithFrame:(frame)];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.point = CGPointMake(point.x, point.y);
        self.layerWidth = size.width;
        [self.titleSource removeAllObjects];
        [self.titleSource addObjectsFromArray:itemSource.allKeys];
        [self.imgSource removeAllObjects];
        [self.imgSource addObjectsFromArray:itemSource.allValues];
        
        if (_imgSource.count == 0) {
            self.layerWidth = 100;
        }
        __weak typeof(self)weakSelf = self;
        if (action) {
            weakSelf.indexesBlock = action;
        }
        
        self.layerHeight = _titleSource.count > 4 ? size.height : itemSource.allValues.count*kItemHeight;
        [self addSubview:self.tableView];
        
        CGFloat y1 = self.point.y + kTriangleHeight;
        CGFloat x2 = self.point.x;
        //边界判断
        if (x2 + size.width > frame.size.width) {
            x2 = frame.size.width - size.width - 10;
        }
        
        if (x2 < 0) {
            x2 = 10;
        }
        _tableView.frame = CGRectMake(x2, y1, self.layerWidth, self.layerHeight);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark -----------UI事件------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HEMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HEMenuTableCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kHEMenuTableCell width:self.layerWidth height:kItemHeight];
    }
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    }
    [cell setContentByTitArray:self.titleSource ImgArray:self.imgSource row:indexPath.row];
    cell.conLabel.text = self.titleSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [indexPath indexPathByRemovingLastIndex];
    if (self.indexesBlock) {
        HEMenuTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_style == MenuStyleSingle) {
            
            _selectIndexes = [NSMutableDictionary dictionary];
            [self.selectIndexes setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@(YES)];
        }else{
            if (cell.isSelected == YES) {
                [self.selectIndexes removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }else{
                [self.selectIndexes setObject:@(YES) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
        }
        
        cell.isSelected = !cell.isSelected;
        self.indexesBlock(self.selectIndexes);
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
