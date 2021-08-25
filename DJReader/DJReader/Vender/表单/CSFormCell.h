//
//  CSFormCell.h
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger{
    CSFormCellTypeText,
    CSFormCellTypeRadio,
    CSFormCellTypeCustom,
}CSFormCellType;
NS_ASSUME_NONNULL_BEGIN

@interface CSFormModel : NSObject
@property (nonatomic,assign)CSFormCellType type;
@property (nonatomic,assign)int formType;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,copy)NSString *name,*identifier,*value;
@end

@interface CSFormCell : UITableViewCell
@property (nonatomic,strong)CSFormModel* model;
- (instancetype)initWithModel:(CSFormModel*)model;
@end

NS_ASSUME_NONNULL_END
