//
//  MenuView.h
//  YHMenu
//
//  Created by Boris on 2018/5/10.
//  Copyright © 2018年 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuEnums.h"

typedef void(^TouchBlock)();
typedef void(^IndexBlock)(NSInteger row);
typedef void(^IndexesBlock)(NSMutableDictionary *selectRows);
@interface MenuView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) TouchBlock touchBlock;
@property (nonatomic, copy) IndexBlock indexBlock;
@property (nonatomic, copy) IndexesBlock indexesBlock;
@property (nonatomic, strong)NSMutableDictionary *selectIndexes;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat layerHeight, layerWidth;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) MenuStyle style;
@property (nonatomic, strong) NSMutableArray *titleSource, *imgSource;

- (id)initWithFrame:(CGRect)frame menuSize:(CGSize)size point:(CGPoint)point itemSource:(NSDictionary *)items style:(MenuStyle)style action:(void(^)(NSMutableDictionary *indexes))action;

@end
