//
//  SealAttributeView.h
//  DJReader
//
//  Created by Andersen on 2020/3/17.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SealUnit.h"
#import "DJReaderEnums.h"
#import "SealSelector.h"
#import "SignSelector.h"

NS_ASSUME_NONNULL_BEGIN

@class SuspensionView;
@class FileEditorController;
@interface SealAttributeView : UIView

@property (nonatomic,weak)SuspensionView *parentView;
@property (nonatomic,weak)FileEditorController *_Nullable controller;
@property (nonatomic,strong)SealUnit *curUnit;
@property (nonatomic,copy)void(^certDidSelected)(void);
@property (nonatomic,copy)void(^createSealhander)(void);

@property(nonatomic,strong)SealSelector *sealSelector;
@property(nonatomic,strong)SignSelector *signSelector;
@end

NS_ASSUME_NONNULL_END
