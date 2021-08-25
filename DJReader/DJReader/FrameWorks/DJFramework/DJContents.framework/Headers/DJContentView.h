//
//  View.h
//  test1
//
//  Created by yons on 14-3-3.
//  Copyright (c) 2014年 yons. All rights reserved.
//  longPressText

#import <UIKit/UIKit.h>
#import <DJContents/DJContentViewDelegate.h>
#import <DJContents/DJAreaView.h>
#import <DJContents/DJZoomView.h>
#import <DJContents/DJBlockView.h>
#import <DJContents/DJSeparateBlockView.h>
#import <DJContents/DJTextAreaBlockHandle.h>
#import <DJContents/DJSeparateAreaBlockView.h>
#import <DJContents/DJTextBlockHandle.h>
#import <DJContents/DJResult.h>

#define DJBLANKBLOCKNOTIFICATION @"djblankblocknotification"
#define DJBLANKBLOCKNOTIFICATIONKEY @"djblankblocknotificationkey"

/*
 *@Des:DJContentView的状态
 *@Members: DJContentActionBrowse = 0:浏览状态，
 *1:全屏手写状态，
 *2:橡皮状态，可擦除全屏手写的笔迹
 *3:印章状态，在文档上拖动可拖出印章
 *4:文档编辑区域，点击文档对应区域会执行相应的代理方法，对相对的区域进行编辑，编辑方式为弹出框
 */
typedef NS_ENUM(int, DJContentAction)
{
    DJContentActionBrowse,
    DJContentActionWrite,
    DJContentActionErase,
    DJContentActionSeal,
    DJContentActionOperation,
    DJContentActionOperationDraw,
    DJContentActionCover,
    DJContentActionManager,
};

typedef void(^OpenCompleteBlock)(int result);
@interface DJContentView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
#pragma mark - 初始化接口
//文件有密码的话，必须在初始化之前设置;
+ (void)setPassword:(NSString*)pwd;
/// 加载某个用户的节点
/// @param userName 登录的用户名
/// @param load 是否加载模版用户创建的节点
+ (void)loginUser:(NSString*)userName loadOtherNodes:(BOOL)load;
/**
 加载字体包，必须在初始化之前设置;
 @param fontData 字体包Data
 @param fontName 字体包名(带后缀)
 @return 是否成功
 */
+ (BOOL)setFontData:(NSData *)fontData withFontName:(NSString *)fontName;
//YYYY/MM/DD
//YYYY-MM-DD
//YYYY年MM月DD日
+ (void)setTimeFormatter:(NSString*)formatter;

/*
 *@Des:第二版本初始化接口，增加了aip自由文件的初始化
 *@param: filePath:文件路径，frame:控件坐标。
 */
- (id)initWithFrame:(CGRect)frame pdfFilePath:(NSString*)filePath;
- (id)initWithFrame:(CGRect)frame pdfFileData:(NSData*)fileData;
- (id)initWithFrame:(CGRect)frame aipFilePath:(NSString*)filePath;
- (id)initWithFrame:(CGRect)frame aipFileData:(NSData*)fileData;
/*
 *@Des:第三版本初始化接口，在优化第二版本接口后，增加了文件页面绘制完成后的回调，用于客户自定义打开文件的动画设置
 *@param: filePath:文件路径，frame:控件坐标，complete:页面绘制完成后的回调
 */
- (id)initWithFrame:(CGRect)frame pdfFilePath:(NSString*)filePath complete:(OpenCompleteBlock)completBlock;
- (id)initWithFrame:(CGRect)frame pdfFileData:(NSData*)fileData complete:(OpenCompleteBlock)completBlock;
- (id)initWithFrame:(CGRect)frame ofdFilePath:(NSString*)fileData complete:(OpenCompleteBlock)completBlock;
- (id)initWithFrame:(CGRect)frame ofdFileData:(NSData*)fileData complete:(OpenCompleteBlock)completBlock;
- (id)initWithFrame:(CGRect)frame aipFilePath:(NSString*)filePath complete:(OpenCompleteBlock)completBlock;
- (id)initWithFrame:(CGRect)frame aipFileData:(NSData*)fileData complete:(OpenCompleteBlock)completBlock;

@property (nonatomic,weak) id<DJContentViewDelegate> contentViewDelegate;
@property (nonatomic,assign) DJContentAction currentAction;
@property (nonatomic,assign) UIColor* penColor;
@property (nonatomic,assign) CGFloat penStyle;
@property (nonatomic,assign) BOOL userPencil;
@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic,assign) float penWidth;
@property (nonatomic,assign) CGFloat contentZoomScale;

/*
 *@Des:多种操作的字符串数据，用于服务器合成
 *@Members:nodesString:全屏手写笔迹 sealsString:印章手写数据 blocksString:可移动区域数据
 * areaBlocksString:固定区域数据 postString:全部操作数据 postNoSealString:除印章外所有操作数据
 */
@property (nonatomic,readonly) NSString* nodesString;
@property (nonatomic,readonly) NSString* sealsString;
@property (nonatomic,readonly) NSString* blocksString;
@property (nonatomic,readonly) NSString* areaBlocksString;
@property (nonatomic,readonly) NSString* postString;
@property (nonatomic,readonly) NSString* postNoSealString;
@property (nonatomic,readonly) NSString* postBase64String;
@property (nonatomic,readonly) NSString* libNodes;
@property (nonatomic,readonly) CGPoint contentOffSet;
@property (nonatomic,readonly) CGSize contentSize;
@property (nonatomic,readonly) int pageCount;

//印章图片数据
@property (nonatomic,readonly) NSDictionary *sealInfo;
//最后一条编辑的文字
@property (nonatomic,readonly) NSString* lastString;
//文字意见类型（0:无用户信息即为代录，1:带用户信息）
@property (nonatomic,readonly) NSDictionary* textStringList;
//缓存意见
@property (nonatomic,readonly) NSString* cacheString;
//获取SHA1数据
@property (nonatomic,readonly) NSData *SHA1Data;


- (NSDictionary*)findTextLocationInPercent:(NSString*)text;
- (unsigned int)findTextPageNum:(NSString*)text;
- (CGPoint)findTextLocationInFile:(NSString*)text;
- (void)reloadFile;
- (void)setDrakMode:(BOOL)drak;
//设置可移动手写框的笔迹粗细
- (void)setDrawBlockPenWidth:(float)penWidth;
//设置可移动手写框的边框颜色
- (void)setBlocksBorderColor:(UIColor*)color;
//设置可移动背景框的背景颜色
- (void)setBlocksBackColor:(UIColor*)color;
//设置覆盖区域颜色
- (void)setCoverColor:(UIColor*)color;
- (void)setWaterMask:(NSString*)waterMask;
/*
 *@Des:undo:回退全屏手写上一步
 *redo:撤销上一步回退操作
 *clear:清除所有全屏手写的笔迹
 */
- (void)undo;
- (void)clear;
- (void)clearPaths;
- (void)clearBlocks;
- (void)clearDrawBlocks;
- (void)clearTextBlocks;
- (void)clearAreaBlocks;
//撤销印章
- (void)undoSeal;
/*
 *@Des:
 *previousPage 回到上一页
 *nextPage     滑到下一页
 */
- (void)previousPage;
- (void)nextPage;
//滑动任意页
- (void)gotoPage:(NSInteger)page;
- (void)gotoPage:(NSIndexPath*)indexPath offset:(CGPoint)offset;
- (void)scrollFileContentOffsetX:(float)offX;
- (void)scrollFileContentOffsetY:(float)offY;
- (void)addFooterHeight:(float)height;
- (void)addFooterView:(UIView*)footerView;
//Aip文件转换成Pdf
+ (BOOL)convertAip:(NSString*)aipFilePath intoPdf:(NSString*)pdfFilePath;
//把当前文件转成PDF
- (void)converAipToPDF;
/*
 *@Des:把文件存到指定位置
 *@param:filePath:文件另存位置
 */
- (void)saveToFile:(NSString*)filePathc;
- (void)saveToFile:(NSString *)filePath Success:(void (^)(int))success;
- (NSData*)getData;
/*
 * Des:当用户无操作返回上个界面的时候，需要关闭文档
 */
- (void)closeFile;
/*
 * Des:只合并全屏手写的笔迹
 */
- (void)mergeNodes;
/*
 * Des:只合并印章
 */
- (void)mergeSeals;
- (void)mergeSignSeals;
/*
 * Des:合并可移动编辑区域
 */
- (void)mergeBlocks;
/*
 * Des:合并固定编辑区域
 */
- (void)mergeAreaBlocks;
//根据证书只保存盖章
- (BOOL)mergeSealsInMemoryWithCertFile:(NSString*)filePath password:(NSString*)password;
- (BOOL)mergeSignSealsInMemoryWithCertFile:(NSString*)filePath password:(NSString*)password;
//固定区域内根据证书盖章
- (void)mergeAreasWithCertFile:(NSString*)filePath password:(NSString*)password;
/*
 *@Des:盖章所需要的证书，需要传入证书路径和密码
 *@param: filePatht:证书文件路径，password:证书密码。
 */
- (void)mergeAllWithCertFile:(NSString*)filePath password:(NSString*)password;
/*
 *@Des:盖章所需要的证书，需要传入证书路径和密码(与上面接口不一样的是内部实现方式不同)
 *@param: filePatht:证书文件路径，password:证书密码。
 */
- (void)mergeAllPostStringWithCertFile:(NSString*)filePath password:(NSString*)password;
/**
 把外部签名数据合成进文件
 @param signatureBase64 签名数据
 @return 文件位置
 */
- (NSString *)mergPDFDataWithSignature:(NSString*)signatureBase64;
///把所有数据转成印章合并，需要与代理一起使用 - (NSString*)contentView:(DJContentView *)contentView mergeSHA:(NSData*)SHA filePath:(NSString*)filePath
///代理函数详见DJContentViewDelegate.h文件
- (void)startMergeSignature;
- (void)startMergeBySM2PubCert:(NSString*)pubCert;

- (void)mergPDFDataWithSignData:(NSData*)signatureData;
- (void)loadCacheString:(NSString*)cacheString;
- (void)limitEditOnlyForUser;

//合并文件
- (int)mergeFile:(NSString*)filePath afterPage:(NSInteger)indexPage;
- (void)mergeFiles:(NSArray*)filePaths;
//新建页
- (int)insertPage:(NSInteger)indexPage;

//根据坐标添加图片
- (void)drawImage:(UIImage*)image toPDFWithRect:(CGRect)rect atPage:(int)page;
//绘制矢量数据
- (void)deleteAllImage;
- (int)drawPoint:(NSString*)points toArea:(NSString*)name atPage:(int)page;
- (int)drawImage:(UIImage*)image toArea:(NSString*)name atPage:(int)page;
- (DJResult*)login:(NSString*)userName andVerifylicFile:(NSString *)licFile;//登入并验证授权
//设置印章路径
- (UIImage*)setSealWithSealDataFilePath:(NSString*)filePath;
- (BOOL)setSealWithPNGImageFilePath:(NSString*)filePath andSealSize:(CGSize)sealSize;

#pragma mark - 手写相关方法
- (DJAreaView*)createAreaView:(CGRect)rect scale:(CGFloat)scale atPage:(int)pageNum;
- (DJAreaView*)createAreaViewStartPercentOffset:(CGPoint)offset scale:(CGFloat)scale areaName:(NSString*)areaName lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor  atPage:(int)pageNum;
- (DJAreaView*)createAreaViewStartPercentOffset:(CGPoint)offset scale:(CGFloat)scale areaName:(NSString*)areaName atPage:(int)pageNum;
- (DJAreaView*)createAreaViewWithPercentRect:(CGRect)rectInPercent atPage:(int)pageNum;

/*
 *@Des:弹出框手写，全手写的缩放，不新建区域，只是把笔记缩放到文档
 *@param: rectInDocument:手写区域在文档上显示区域的大小，page:在哪个页面显示。
 *@return: 与区域对应的手写view
 */
- (DJZoomView*)createZoomView:(CGRect)rectInDocument atPage:(int)pageNum;
- (DJZoomView*)createZoomViewWithPercentRect:(CGRect)rectInPercent atPage:(int)pageNum;
//把手写数据转成印章
- (DJZoomView*)createZoomViewForSeal:(CGRect)rect atPage:(int)page;
- (DJZoomView*)createSealForImage:(UIImage*)sealImage rect:(CGRect)rect atPage:(int)page shouldReturn:(BOOL)should;
- (void)createSeal:(CGPoint)location atPage:(int)page;///50000*50000的坐标系盖章
//创建一个获取手写数据和图片的类
+ (DJZoomView*)createZoomView;
- (DJZoomView*)createZoomViewWithPaths:(NSString*)paths inRect:(CGRect)rectInDocument atPage:(int)pageNum;
- (DJZoomView*)createZoomViewWithPathsArray:(NSArray*)paths inRect:(CGRect)rectInDocument atPage:(int)pageNum;
/*
 *@Des:新建一个手写板是田字格的手写区域(编辑状态不可移动)
 *@param:identfier:抄写文字标识 size:手写区域在文档上显示区域的大小，page:在哪个页面显示。
 */

//根据文字标识确定位置
- (DJBlockView*)createDJBlockViewWithAreaName:(NSString*)areaName identfier:(NSString*)identfier size:(CGSize)size fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight atPage:(int)pageNum forMattsStr:(NSString *)mattsStr;
//根据已有文字区域
- (DJBlockView*)createDJBlockViewWithAreaName:(NSString*)areaName fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight atPage:(int)pageNum forMattsStr:(NSString *)mattsStr;
//根据点击坐标
- (DJBlockView*)createDJBlockViewWithAreaName:(NSString*)areaName rect:(CGRect)rect  fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight atPage:(int)pageNum forMattsStr:(NSString *)mattsStr;

+ (DJSeparateBlockView*)createSignViewWithfontSize:(CGFloat)fontSize fontHeight:(CGFloat)fontHeight;

/*
 *@Des:根据文档位置往文档新建可移动手写区域
 *@param:
 *rect       手写区域在文档上显示区域的大小
 *page       在哪个页面显示
 *fontSize   文字宽度
 *lineHeight 文字高度
 *@return:   与区域对应的手写view
 */
- (DJSeparateBlockView*)createSeparateBlockView:(CGRect)rectInDocument atPage:(int)pageNum
                                       fontSize:(CGFloat)fontSize
                                     lineHeight:(CGFloat)lineHeight;
/*
 *@Des:根据文档位置百分比往文档上新建可以移动手写区域
 *@param:
 *PercentRect:手写区域在文档上显示区域的大小百分比
 *page:在哪个页面显示
 *fontSize:文字宽度 lineHeight:文字高度
 *@return: 与区域对应的手写view
 */
//标信项目
- (DJSeparateBlockView*)createSeparateBlockViewWithPercentRect:(CGRect)rectInPercent atPage:(int)pageNum fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight;
/*
 *@Des:根据名字往文字编辑区域手写
 *@param:
 *areaName:目标区域名字
 *page:在哪个页面显示
 *fontSize:文字宽度 lineHeight:文字高度
 *@return: 与区域对应的手写view
 */

//
- (DJSeparateAreaBlockView*)drawTextAreaBlockWithAreaName:(NSString*)areaName
                                                   atPage:(int)pageNum
                                                 fontSize:(CGFloat)fontSize
                                               lineHeight:(CGFloat)lineHeight;
/*
 *@Des:根据名字往文档上固定区域区域手写
 *@param:
 *AreaName 手写目标区域
 *page:在哪个页面显示
 *fontSize:文字宽度
 *lineHeight:文字高度
 *@return: 与区域对应的手写view
 */
- (DJSeparateAreaBlockView*)drawAreaBlockWithAreaName:(NSString*)areaName
                                               atPage:(int)pageNum
                                             fontSize:(CGFloat)fontSize
                                           lineHeight:(CGFloat)lineHeight;
#pragma mark - 键盘文字输入相关方法
//根据区域名字往区域内添加文字
- (void)setTextAreaBlockWithText:(NSString *)text withName:(NSString *)areaName;
- (void)setNodeRect:(CGRect)rect withName:(NSString*)areaName;
- (void)eraseNodes:(CGPoint)point atPage:(int)page;
//根据下拉框名 设置下拉框选项
- (void)setComboBoxWithOption:(int)option toAreaName:(NSString *)areaName;
- (void)editTextAreaBlocksWithAttributedDictionary:(NSDictionary*)dic atPage:(NSInteger)pageNum;
+ (int)setAipValues:(NSString*)values toFilePath:(NSString*)filePath;

/*
 *@Des:在当前页往文档上添加可移动文字区域，
 *@param:
 *Text       手写目标区域
 *page       在哪个页面显示
 *font       文字大小
 *userImage:是否使用电子签名(图片)
 *time：时间
 *useUserName:是否使用电子签名(文字)
 *如果俩个都不使用,默认是不显示电子签名
 */
- (DJAreaIndexPath)addBlankTextBlockWithText:(NSString *)text inRect:(CGRect)rect supRect:(CGRect)nodeRect font:(UIFont *)font useInfo:(BOOL)useInfo time:(NSString *)time;
- (DJAreaIndexPath)addBlankTextBlockWithText:(NSString *)text
                                   sufString:(NSString *)text
                                      inRect:(CGRect)rect
                                        font:(UIFont*)font;
- (DJTextBlockHandle*)addTextBlockWithtext:(NSString*)text
                      atPage:(int)pageNum
                      inRect:(CGRect)rect
                        font:(UIFont*)font
                 useUserInfo:(BOOL)use
                        time:(NSString *)time;
- (DJTextBlockHandle*)addTextBlockToPage:(int)pageNum inRect:(CGRect)rect;
//新加节点设置节点名
- (void)setTextBlockWithText:(NSString *)text
                      atPage:(int)pageNum
                    withName:(NSString *)areaName
                        font:(UIFont *)font
                       color:(UIColor *)color
                   alignment:(NSTextAlignment)alignment;
//编辑textBlock
- (void)editTextBlock:(NSString*)text atPage:(int)pageNum withTime:(NSString*)time
        areaIndexPath:(DJAreaIndexPath)areaIndexPath;
//编辑textBlock
- (void)editTextBlockTextWithtext:(NSString*)text
                          sufText:(NSString*)sufText
                           atPage:(int)pageNum
                    areaIndexPath:(DJAreaIndexPath)areaIndexPath;

//删除文字节点
- (void)removeTextBlock:(DJAreaIndexPath)areaIndexPath;
- (void)removeTextAreaBlock:(NSString*)areaName;
//删除新加手写节点
- (void)removeDrawBlock:(DJSeparateBlockView*)view;
//在指定页新建可以的文字区域

//根据区域名获得区域名字
- (NSDictionary*)getSignMessage;
- (NSString *)getTextBlockWithName:(NSString*)areaName;
- (NSArray *)getFilesImage:(double)imageScale;//获取文件图片
+ (NSArray *)getFilesImage:(NSString*)filePath imageScale:(double)imageScale;
- (CGSize)getPageSize:(int)page;
- (CGRect)getBlockViewRectWithName:(NSString*)areaName;


/*
 *userImage：是否使用电子签名(图片)
 *time：时间
 *useUserName：是否使用电子签名(文字)
 *如果俩个都不使用,默认是不显示电子签名
 */

//设置user的属性
/*
 * @Des:         设置user的属性同时可以验证用户的授权，登录
 * @param:
 * userId        用户id
 * userName      用户名
 * verifylicFile 验证授权文件
 * userDesc      用户描述
 * usePngImage   是否是png图片
 * userNameFont  设置文字签名的字体大小，如果不设置，默认字体为block中添加的文字的字体大小
 * userImageRect 图片的rect
 * userImagePath 图片路径
 */
- (void)setUserInfoWithUserId:(NSString *)userId
                     userName:(NSString *)userName
                verifylicFile:(NSString *)licFile
                  usePngImage:(BOOL)usePngImage
                 userSealSize:(CGSize)sealSize
                userImagePath:(NSString *)userImagePath;

- (void)setUserInfoWithUserId:(NSString *)userId userName:(NSString *)userName;
//设置user的照片如身份证等
/*
 *测试接口
 */
- (void)setUserCardImageView:(UIImageView *)imageView atPage:(int)pageNum;

/*旧印章平台获取授权
 *userName 授权账号，每个账号能获取的授权个数有限制
 *IP:印章平台地址
 */
- (void)login:(NSString*)userName userId:(NSString*)userId forServerIP:(NSString*)IP;
///新印章平台
- (void)loginForServerIP:(NSString*)IP userID:(NSString*)userID pwd:(NSString*)pwd busID:(NSString*)busID complete:(void(^)(id object))complete;

///旧印章平台获取授权
+ (void)verify:(NSString*)userID forServerIP:(NSString*)IP complete:(void(^)(DJResult*))complete;
+ (void)requestLIC:(NSString*)IP withName:(NSString*)name hander:(void(^)(DJResult*))hander;
///验证万能码授权
+ (int)verify:(NSString*)licCode verifylicFile:(NSString*)licFile;
///仅阅模式，取消右上角授权名字
+ (int)readVerify:(NSString*)licCode verifylicFile:(NSString*)licFile;

///只需要对文字区域添加用户信息
- (void)loginUserName:(NSString *)userName;
///印章平台获取印章列表
+ (void)getSealListFromServer:(NSString*)IP info:(NSDictionary*)info complete:(void(^)(id sealList, NSError *error))complete;
+ (void)getSealData:(NSString*)sealId forServerIP:(NSString*)IP complete:(void(^)(id sealData,NSError *error))complete;
//通过服务器来进行签名，来合成文件
- (void)mergWithSN:(NSString*)SN andPWD:(NSString*)PWD forServer:(NSString*)IP complete:(void (^)(NSString* filePath))complete;
//上传文件至印章平台盖章盖章
+ (void)sealCoverToServer:(NSString*)address attributies:(NSDictionary*)attributies complete:(void(^)(NSData * data, NSURLResponse * response, NSError *error))complete;

///手机号获取授权
+ (void)getVerifyCodeFromBaseIP:(NSString*)IP andPhone:(NSString*)phoneNum complete:(void (^)(id response,NSError *error))complete;//1:获取短信验证码
///根据手机号和验证码获取授权
+ (void)verify:(NSString*)IP phone:(NSString*)phonNum verifyCode:(NSString*)code userID:(NSString*)userID projectName:(NSString*)projectName userName:(NSString*)userName  complete:(void (^)(id response,NSError *error))complete;
@end
