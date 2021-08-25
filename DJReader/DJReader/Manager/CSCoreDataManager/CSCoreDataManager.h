//
//  CSCoreDataManager.h
//  CoreDataDemo04
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJReadUser.h"
#import "DJReader+CoreDataModel.h"
#import "CSCoreDataClient.h"
#import "DJFileDocument.h"
#import "DJFloder.h"
#import "SealUnit.h"
#import "DJFileManager.h"

NS_ASSUME_NONNULL_BEGIN
@interface CSCoreDataManager : NSObject
@property (nonatomic,assign)BOOL isLoging;
@property (nonatomic,strong)DJReadUser *user;
@property (nonatomic,readwrite,strong)NSManagedObjectContext *context;

/// 单例初始化
+ (CSCoreDataManager*)shareManager;

#pragma 用户数据查找
+ (BOOL)isLogin;
///记录用户登录
- (void)cacheUser:(DJReadUser*)user;
///上个登录的用户,输入一个有效时间(单位分钟)，返回最近登录的一个用户
- (DJReadUser*)prvUser:(int)time;
- (BOOL)fetchPrvUserIsVIP;
- (void)fetchPrvUser:(void(^)(DJReadUser*user))hander;/// 清除用户登入记录
- (void)cleanCacheUser;
///缓存用到本地plist文件，做默认用户登入
///游客的身份数据库会存着用户列表
///@param registerInfo registerInfo de scription
- (DJReadUser*)registerAccount:(NSDictionary*)registerInfo;
///登入用户并且切换数据库
- (DJReadUser*)loginAccount:(NSString*)account password:(NSString*)password;
- (void)loginUser:(DJReadUser*)user;
///查找用户
- (DJReadUser*)fetchUser:(NSString*)account password:(NSString*)password;


#pragma 文件查找
/// 直接写入不去重
- (DJFileDocument*)writeSourceFile:(NSString*)source;
//- (DJFileDocument*)writeFileData:(NSData*)fileData withName:(NSString*)fileName;
/// 删除文件
/// @param file fileModel
- (void)deleteFileToCoreData:(DJFileDocument*)file;
/// 修改文件属性
/// @param file fileModel
- (void)updataFileToCoreData:(DJFileDocument*)file;
/// 更新用户属性
- (void)updataUserInfo:(DJReadUser*)user;
/// 查找文件
- (DJFileDocument*)fectchFileDocumentByID:(int64_t)id;
- (DJFileDocument*)fectchFileDocumentByEntity:(FileEntity*)entity;
- (NSArray<DJFloder*>*)fetchAllFlodersFromCoreData;//查询所有文件夹
- (NSMutableArray<DJFileDocument*>*)fetchAllFileFromCoreData;//查询所有文件
/// 查询某个文件夹下所有文件
- (NSArray<DJFileDocument*>*)fetchFloderFilesByID:(int64_t)id;
/// 根据名字查找文件
/// @param fileName 文件名字
- (NSArray<DJFileDocument*>*)fetchFileByFileName:(NSString*)fileName;
- (NSArray<DJFileDocument*>*)fetchFileContainName:(NSString*)fileName;
///查看文件在CoreData是否存在内容相同的文件
- (BOOL)fileIsDuplicate:(NSString *)source;

#pragma 文件夹操作
///按条件查询所有文件夹
- (NSArray<DJFileDocument*>*)fetchAllFileFromCoreData:(NSPredicate*)predicate descriptors:(NSSortDescriptor *)descriptor;
///查询所有文件夹
- (DJFloder*)fectchFloderByID:(int64_t)id;


#pragma 印章数据查找
- (void)writeSeal:(SealUnit*)sealUnit;
- (void)updateSeal:(SealUnit*)sealUnit;
- (void)deleteSealByID:(int64_t)sealID;
- (SealUnit*)fetchSealByID:(int64_t)sealID;
- (SealUnit*)fetchSealBySource:(NSString*)source;
- (SealUnit*)fetchSeal:(SealEntity*)sealEntity;

@end

NS_ASSUME_NONNULL_END
