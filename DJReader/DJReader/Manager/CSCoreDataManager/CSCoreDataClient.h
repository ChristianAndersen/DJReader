//
//  CSCoreDataClient.h
//  CoreDataDemo04
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "DJReader+CoreDataModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface CSCoreDataClient : NSObject
@property (nonatomic,readwrite,strong)NSManagedObjectModel *managedObjectModel;
@property (nonatomic,readwrite,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,readwrite,strong)NSManagedObjectContext *context;

+ (CSCoreDataClient*)shareClient;
- (void)loginAccount:(NSString*)account password:(NSString*)password;

//查询所有符合条件的实体
- (NSArray*)fetchEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName;
//查寻实体
- (NSArray*)fetchEntitiesPredicate:(NSPredicate*)predicate fromEntityName:(NSString*)entityName;
//按条件查寻实体
- (NSArray*)fetchEntitiesPredicate:(NSPredicate*)predicate fromEntityName:(NSString*)entityName descriptors:(NSSortDescriptor *)descriptor;
///群体删除，单体删除，只是COreData删除的接口不同
//单个增加
- (void)insertEntity:(NSString*)entityName properties:(NSDictionary*)properties;
//群体增加
- (void)insertEntiies:(NSString*)entityName properties:(NSArray <NSDictionary<NSString *, id> *>*)dictionaries;
//单体删除
- (void)deleteEntity:(NSPredicate*)predicate fromEntityName:(NSString*)entityName;
//群体删除
- (void)deleteEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName;
//单个更新,只对查询到的数据最后一个做赋值
- (void)updateEntity:(NSPredicate*)predicate fromEntityName:(NSString*)entityName properties:(NSDictionary*)properties;
//群体更新，对所有查询的实体做更新，插入一样的数据
- (void)updateEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName properties:(NSDictionary*)properties;
- (void)saveContext;
@end

NS_ASSUME_NONNULL_END
