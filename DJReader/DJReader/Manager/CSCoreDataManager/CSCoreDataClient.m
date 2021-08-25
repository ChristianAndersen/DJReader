//
//  CSCoreDataClient.m
//  CoreDataDemo04
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSCoreDataClient.h"

@interface CSCoreDataClient()
@property (nonatomic,readwrite,strong)NSManagedObjectContext *backgroundContext;
@property (nonatomic,copy)void (^backgroundContextCompleted)(void);
@property (nonatomic)dispatch_queue_t backgroundQueue;
@property (nonatomic,copy)NSString *account,*password;
@end

@implementation CSCoreDataClient
static CSCoreDataClient *_client;
#pragma mark - Init

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _client = [super allocWithZone:zone];
        [_client initCoreDataStack];
    });
    return _client;
}

+ (CSCoreDataClient*)shareClient
{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken,^{
         _client = [[CSCoreDataClient alloc]init];
         [_client initCoreDataStack];
     });
     return _client;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _client;
}

- (void)initCoreDataStack
{
    _context = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    
    [_client managedObjectModel];
    [_client persistentStoreCoordinator:DEFAULTUSER_ACOUNT];
    [_client context];
}

- (void)registerBackThreadContextNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveBackThreadContextSave:) name:NSManagedObjectContextDidSaveNotification object:self.backgroundContext];
}

- (void)receiveBackThreadContextSave:(NSNotification*)note
{
    [self.context mergeChangesFromContextDidSaveNotification:note];
}

- (void)loginAccount:(NSString*)account password:(NSString*)password
{
    _client.account = account;
    _client.password = password;
}

#pragma mark - Core Data stack
- (dispatch_queue_t)backgroundQueue
{
    if (!_backgroundQueue) {
        _backgroundQueue = dispatch_queue_create("backgroundQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _backgroundQueue;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle]URLForResource:@"DJReader" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator:(NSString*)account
{
    if (!_persistentStoreCoordinator) {
        @try {
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
            NSURL *sqlURL = [[self documentDirectoryURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"DJReader_DataBase_%@",account]];
            NSError *error;
            //允许推断基本类型
            NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES};
            [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:options error:&error];
            if (error) {
                ShowMessage(@"", @"本地数据持久化失败，请尝试删除APP后重新，重新下载", RootController);
                NSLog(@"falied to create persistentStoreCoordinator %@",error.localizedDescription);
            }
        } @catch (NSException *exception) {
            ShowMessage(@"", @"本地数据出现错误，请尝试删除APP后重新，重新下载", RootController);
        } @finally {
            
        }
    }
     return _persistentStoreCoordinator;
}
-  (NSManagedObjectContext*)context
{
    if (!_context) {
        _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

- (NSManagedObjectContext*)backgroundContext
{
    if (!_context) {
        _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

- (NSURL*)documentDirectoryURL
{
    return [[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.context;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
//==================================================================================================================

//查寻实体
- (NSArray*)fetchEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];    
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSError *error = nil;
    NSArray *entityes = [self.context executeFetchRequest:request error:&error];
    return entityes;
}
//查寻实体
- (NSArray*)fetchEntitiesPredicate:(NSPredicate*)predicate fromEntityName:(NSString*)entityName
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];

    NSSortDescriptor *descriptors = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:descriptors];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *entityes = [self.context executeFetchRequest:request error:&error];
    return entityes;
}
//按条件查寻实体
- (NSArray*)fetchEntitiesPredicate:(NSPredicate*)predicate fromEntityName:(NSString*)entityName descriptors:(NSSortDescriptor *)descriptor
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    if(descriptor){
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    }
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *entityes = [self.context executeFetchRequest:request error:&error];
    return entityes;
}
//单体增加
- (void)insertEntity:(NSString*)entityName properties:(NSDictionary*)properties
{
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
    
    for (NSString *key in properties.allKeys) {
        [obj setValue:[properties objectForKey:key] forKey:key];
    }
    [self saveContext];
}
//群体增加
- (void)insertEntiies:(NSString*)entityName properties:(NSArray <NSDictionary<NSString *, id> *>*)dictionaries
{
    NSBatchInsertRequest *insertRequest = [[NSBatchInsertRequest alloc]initWithEntityName:entityName objects:dictionaries];
    insertRequest.resultType = NSPersistentHistoryResultTypeObjectIDs;
    NSBatchInsertResult *insertResult = [self.context executeRequest:insertRequest error:nil];
    
    NSArray <NSManagedObjectID*>*insertObjectIDS = insertResult.result;//返回更新成功的对象ID数组
    NSDictionary *insertDic = @{NSInsertedObjectsKey:insertObjectIDS};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:insertDic intoContexts:@[self.context]];
}

//单个删除
- (void)deleteEntity:(NSPredicate*)predicate fromEntityName:(NSString*)entityName
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *entityes = [self.context executeFetchRequest:request error:&error];
    
    for (int i=0; i<entityes.count; i++) {
        [self.context deleteObject:[entityes objectAtIndex:i]];
    }
    [self saveContext];
}

//群体删除
- (void)deleteEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setPredicate:predicate];
    
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    if (@available(iOS 11.0, *)) {
        deleteRequest.resultType = NSPersistentHistoryResultTypeObjectIDs;
    } else {
    }
    
    NSBatchDeleteResult *deleteResult = [self.context executeRequest:deleteRequest error:nil];
    NSArray <NSManagedObjectID*>*deleteObjectIDS = deleteResult.result;//返回更新成功的对象ID数组
    NSDictionary *deleteDic = @{NSDeletedObjectsKey:deleteObjectIDS};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:deleteDic intoContexts:@[self.context]];
}

//单个更新
- (void)updateEntity:(NSPredicate*)predicate fromEntityName:(NSString*)entityName properties:(NSDictionary*)properties
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *entityes = [self.context executeFetchRequest:request error:&error];
    id entity = entityes.lastObject;
    
    if (entityes == nil) {
        NSLog(@"fetch failed");
    }else{
        NSMutableArray *keys = [entity propertyKeys];
        for (NSString *key in keys) {
            id objValue = [properties objectForKey:key];
            if (!objValue) continue;
                
            if ([key isEqualToString:@"isvip"]||[key isEqualToString:@"star"])
            {
                NSNumber *value = objValue;
                [entity setValue:value forKeyPath:key];
            }else if ([objValue isKindOfClass:[NSString class]])
            {
                [entity setValue:objValue forKeyPath:key];
            }else if (![key isEqualToString:@"superFloders"]){
                [entity setValue:objValue forKeyPath:key];
            }
        }
    }
    [self saveContext];
}

//群体更新
- (void)updateEntities:(NSPredicate*)predicate fromEntityName:(NSString*)entityName properties:(NSDictionary*)properties
{
    NSBatchUpdateRequest *updataRequest = [[NSBatchUpdateRequest alloc]initWithEntityName:entityName];
    updataRequest.propertiesToUpdate = properties;
    updataRequest.resultType = NSUpdatedObjectIDsResultType;
    [updataRequest setPredicate:predicate];
    
    [_context executeRequest:updataRequest error:nil];
    NSBatchUpdateResult *updataResult = [self.context executeRequest:updataRequest error:nil];
    NSArray <NSManagedObjectID*>*updateObjectIDS = updataResult.result;//返回更新成功的对象ID数组
    NSDictionary *updateDict = @{NSUpdatedObjectsKey:updateObjectIDS};
    
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:updateDict intoContexts:@[self.context]];
}


- (void)dealloc
{
    self.backgroundContextCompleted = nil;
}
@end
