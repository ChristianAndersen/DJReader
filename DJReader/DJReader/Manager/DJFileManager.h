//
//  DJFileManger.h
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJFileManager : NSObject
+ (DJFileManager*)shareManager;

/// 传入文件名获取OFD文件夹下所有文件
/// @param fileName 文件名
+ (NSString*)pathInOFDFloderDirectoryWithFileName:(NSString*)fileName;
+ (NSString*)pathInUserDirectoryWithFileName:(NSString*)fileName;
+ (NSString*)pathInDisplayDirectoryWithFileName:(NSString*)fileName;

/// 往用户文件夹下写文件，返回,路径和文件Data数据
/// @param sourcePath 源文件
/// @param path 目标文件位置
- (void)writeFile:(NSString*)sourcePath toPath:(NSString*)path;
- (NSDictionary*)writeFileWithPath:(NSString*)filePath;
/// 遍历某个文件目录下所有文件
/// @param diretory 要遍历的目录
/// @param fileList 写入数据的容器
- (void)readFileIn:(NSString*)diretory writeTo:(NSMutableDictionary*)fileList;
///根据分割符#判断文件有没有写过本地
- (void)readLocaFile:(NSString*)diretory writeTo:(NSMutableDictionary*)fileList;
- (void)deleteFile:(NSString*)sourcePath;
/// 判断是否是支持的文件格式
/// @param filePath 判断的文件路径
/// @param support 支持的文件
/// @param unSupport 不支持的文件，但是可以转换
/// @param unKnown 未知的文件格式
+ (void)judgeFile:(NSString*)filePath support:(void(^)(void))support unSupport:(void(^)(void))unSupport unKnown:(void(^)(void))unKnown;


/// 获取文件创建日期
/// @param source 文件路径
+ (NSString*)getFileCreateDate:(NSString*)source;
+ (NSString*)getFileModificationDate:(NSString*)source;
+ (long)getFileModificationDateInterval:(NSString*)source;
@end

NS_ASSUME_NONNULL_END
