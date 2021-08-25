//
//  DJContentViewDelegate.h
//  test1
//
//  Created by yons on 14-4-22.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJContentView;
@class DJTextAreaBlockHandle;
@class DJSeparateAreaBlockView;
@class DJZoomView;
@class DJSeparateAreaBlockViewParams;
@class DJTextBlockHandle;
@class TextBlock;
@class DJSeparateBlockView;
@class DJResult;
@class DJComboBoxHandle;

@protocol DJContentViewDelegate <NSObject>
@optional
- (UIView *)contentHeaderView;
///对DJcontentView对象执行的操作
- (void)contentViewDidScroll:(DJContentView *)view;
- (void)contentViewDidDraw:(DJContentView *)view;
- (void)contentViewDidErase:(DJContentView *)view;
- (void)contentViewDidSeal:(DJContentView *)view;
- (void)contentViewDidCover:(DJContentView *)view;
///  新加节点通知，目前只包含可移动文字节点和可移动手写节点
/// @param contentView 添加的文件视图
/// @param hasTextBlock 是否添加了文字
/// @param hasPath 是否添加了手写
- (void)contentView:(DJContentView*)contentView hasTextBlock:(BOOL)hasTextBlock hasPath:(BOOL)hasPath;

/// 滚动时当前页数的变化
/// @param contentView 滚动的view
/// @param page 当前页码
/// @param pageCount 总共的页码
- (void)contentView:(DJContentView*)contentView currentPage:(int)page pageCount:(int)pageCount;

/// 滚动到边界时
/// @param contentView 滚动的View
/// @param offset 超出边界的值
/// @param contentSize 总共的范围值
- (void)contentView:(DJContentView*)contentView scrollOffset:(CGPoint)offset toBoundary:(CGSize)contentSize;

/// 点击文件空白区域的回调，可以配合多种添加数据的接口实现点击添加不同内容的需求，在contentView.currentAction == DJContentActionOperation
/// @param contentView 点击的View
/// @param point 点击的点
/// @param indexPath 点击页数
- (void)contentView:(DJContentView*)contentView clicked:(NSString*)point indexPath:(NSIndexPath*)indexPath;

///浏览状态点击印章获取印章信息
- (void)contentView:(DJContentView*)contentView verifyInfo:(NSDictionary*)verifyInfo;
- (void)contentView:(DJContentView*)contentView longPressed:(NSDictionary*)info;
///点击单选区域的回调
- (void)contentView:(DJContentView *)contentView comboBoxBlockDidTap:(DJComboBoxHandle *)handle areaName:(NSString*)areaName;
///印章区域点击回调
- (void)contentView:(DJContentView *)contentView sealAreaDidTap:(DJZoomView *)zoomView;
///文字模版节点点击回调
- (void)contentView:(DJContentView*)contentView textAreaBlockNeedEdit:(NSString*)text handle:(DJTextAreaBlockHandle*)handle;
///手写模版节点点击回调
- (DJSeparateAreaBlockViewParams*)contentView:(DJContentView*)contentView drawAreaBlockNeedEdit:(DJSeparateAreaBlockView*)view;
///新加文字节点点击回调
- (void)contentView:(DJContentView*)contentView handle:(DJTextBlockHandle*)handle;
///新加手写节点点击回调
- (DJSeparateBlockView *)contentView:(DJContentView*)contentView drawBlockNeedEdit:(DJSeparateBlockView*)view;

///从授权平台获取授权回调
- (void)contentView:(DJContentView*)contentView getVerifylicResult:(DJResult*)verResult;

///使用地方数字签名合成多调意见回调
- (NSString*)contentView:(DJContentView *)contentView mergeSHA:(NSData*)SHA filePath:(NSString*)filePath;
/// 调用- (void)startMergeBySM2PubCert:(NSString*)pubCert合并使用SM2签名的回调，文件上有N个签名需要合并调用N+1次，最后一次用于合并完成保存出文件
/// @param contentView 要合并的文件View
/// @param digest 编辑后文件的摘要签名原文
/// @param complete 用于传回签名值
- (void)contentView:(DJContentView *)contentView mergeDigest:(NSString*)digest complete:(NSString *(^)(NSString*signData,NSString*fileName))complete;

@end

