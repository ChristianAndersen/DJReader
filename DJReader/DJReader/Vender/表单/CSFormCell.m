//
//  CSFormCell.m
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSFormCell.h"
#import "CSFormtextCell.h"
#import "CSFormRadioCell.h"
#import "CSFormCustomCell.h"
@implementation CSFormModel
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
@end


@implementation CSFormCell
- (instancetype)initWithModel:(CSFormModel*)model
{
    CSFormCell *cell;
    switch (model.type) {
        case CSFormCellTypeText:
            cell = [[CSFormtextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier];
            break;
        case CSFormCellTypeRadio:
            cell = [[CSFormRadioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier];
            break;
        case CSFormCellTypeCustom:
            cell = [[CSFormCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier];
            break;
        default:
            break;
    }
    cell.model = model;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
