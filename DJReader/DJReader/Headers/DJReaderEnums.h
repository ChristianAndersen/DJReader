//
//  DJReaderEnums.h
//  DJReader
//
//  Created by Andersen on 2020/3/12.
//  Copyright © 2020 Andersen. All rights reserved.
//

#ifndef DJReaderEnums_h
#define DJReaderEnums_h

//底部弹框返回类型
typedef enum:NSInteger{
    BottomActionTypeWait,
    BottomActionTypeText,
    BottomActionTypeSeal,
    BottomActionTypeHand,
}BottomActionType;

//文件详情页面导航栏类型
typedef enum:NSInteger{
    EditorNavBarTypeBrowse,
    EditorNavBarTypeText,
    EditorNavBarTypeSeal,
    EditorNavBarTypeHand,
}EditorNavBarType;

//CSNarBar按钮布局
typedef enum : NSUInteger {
    CSNavBarTypeDefault,
    CSNavBarTypeCenter,
} CSNavBarType;

typedef enum : NSUInteger {
    CSNavBarResponseNone,
    CSNavBarResponseSingle,
    CSNavBarResponseDouble,
} CSNavBarResponseType;
#endif /* DJReaderEnums_h */

typedef enum : NSUInteger {
    CSSealTypeSeal,
    CSSealTypeSign,
} CSSealType;
//文件目录枚举
typedef NS_OPTIONS(NSUInteger, FloderDirectoryOption) {
    FloderDirectoryOptionBrowse = 1 << 0,
    FloderDirectoryOptionLoca = 1 << 1,
    FloderDirectoryOptionMe = 1 << 2,
};
typedef NS_ENUM(int, DJReadEditAction)
{
    DJReadEditBrowse,
    DJReadEditWrite,
    DJReadEditText,
    DJReadEditSeal,
    DJReadEditMove,
    DJReadEditEraser,
};
typedef NS_ENUM(int, LoginType)
{
    LoginTypeAdmin,
    LoginTypeOFD,
    LoginTypeWechat,
};

