//
//  CSFormTableView.h
//  DJReader
//
//  Created by Andersen on 2020/9/7.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger{
    CSFormSectionTypeOption,
    CSFormSectionTypeRequired,
}CSFormSectionType;

typedef enum:NSInteger{
    CSFormItemString,
    CSFormItemPhone,
    CSFormItemCarID,
    CSFormItemEmail,
    CSFormItemImage,
}CSFormItemType;

NS_ASSUME_NONNULL_BEGIN

@interface CSFormSectionModel : NSObject
@property (nonatomic,copy)NSString*name;
@property (nonatomic,assign)CSFormSectionType type;
@property (nonatomic,strong)NSMutableArray *rows;
@end

@interface CSFormTableView : UIView
@property (nonatomic,strong)NSDictionary *optionValue,*requiredValue;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addSection:(CSFormSectionModel*)model;
- (void)addTextRow:(NSString*)name placeholder:(NSString*)placeholder inSection:(NSInteger)section formType:(CSFormItemType)type;
- (void)addRadioRow:(NSString*)name items:(NSArray*)items inSection:(NSInteger)section formType:(CSFormItemType)type;
- (void)addCustomRow:(NSString*)name content:(UIView*)contentView inSection:(NSInteger)section formType:(CSFormItemType)type;
- (void)addFotterView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
