//
//  CSCoreDataManager.m
//  CoreDataDemo04
//
//  Created by Andersen on 2020/4/1.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSCoreDataManager.h"
#import <MJExtension/MJExtension.h>

@interface CSCoreDataManager()
@property (nonatomic,strong)FloderEntity *browseFloderEntity;
@property (nonatomic,strong)FloderEntity *locaFloderEntity;
@property (nonatomic,strong)FloderEntity *meFloderEntity;
@property (nonatomic,strong)NSString *userPlist;
@end

@implementation CSCoreDataManager
static CSCoreDataManager *_manager;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _manager = [super allocWithZone:zone];
        [_manager loadDefaultFloder];
    });
    return _manager;
}

+ (CSCoreDataManager*)shareManager
{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken,^{
         _manager = [[CSCoreDataManager alloc]init];
         [_manager loadDefaultFloder];
     });
     return _manager;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

- (NSManagedObjectContext*)context
{
    return [CSCoreDataClient shareClient].context;
}

- (FloderEntity*)browseFloderEntity
{
    if (!_browseFloderEntity) {
        NSPredicate *browsePredicate = [NSPredicate predicateWithFormat:@"id = %lld",DEFAULTBROWSE_FLODER_ID];
        _browseFloderEntity = [[[CSCoreDataClient shareClient] fetchEntities:browsePredicate fromEntityName:@"FloderEntity"]lastObject];
        
        if (!_browseFloderEntity) {
            _browseFloderEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FloderEntity" inManagedObjectContext:self.context];
            _browseFloderEntity.id = DEFAULTBROWSE_FLODER_ID;
            _browseFloderEntity.name = DEFAULTBROWSE_FLODER_NAME;
            _browseFloderEntity.status = 0;
        }
    }
    return _browseFloderEntity;
}

- (FloderEntity*)locaFloderEntity
{
    if (!_locaFloderEntity) {
        NSPredicate *locaPredicate = [NSPredicate predicateWithFormat:@"id = %ld",DEFAULTLOCA_FLODER_ID];
        
        _locaFloderEntity = [[[CSCoreDataClient shareClient] fetchEntities:locaPredicate fromEntityName:@"FloderEntity"]lastObject];
        
        if (!_locaFloderEntity) {
            _locaFloderEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FloderEntity" inManagedObjectContext:self.context];
            _locaFloderEntity.id = DEFAULTLOCA_FLODER_ID;
            _locaFloderEntity.name = DEFAULTLOCA_FLODER_NAME;
            _locaFloderEntity.status = 0;
        }
    }
    return _locaFloderEntity;
}

- (FloderEntity*)meFloderEntity
{
    if (!_meFloderEntity) {
        NSPredicate *mePredicate = [NSPredicate predicateWithFormat:@"id = %lld",DEFAULTME_FLODER_ID];
        _meFloderEntity = [[[CSCoreDataClient shareClient] fetchEntities:mePredicate fromEntityName:@"FloderEntity"]lastObject];
        
        if (!_meFloderEntity) {
            _meFloderEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FloderEntity" inManagedObjectContext:[CSCoreDataClient shareClient].context];
            _meFloderEntity.id = DEFAULTME_FLODER_ID;
            _meFloderEntity.name = DEFAULTME_FLODER_NAME;
            _meFloderEntity.status = 0;
        }
    }
    return _meFloderEntity;
}


- (void)setEntity:(NSEntityDescription*)entity byObj:(id)obj
{
    NSDictionary *properties = [obj selfPropertyDictionary];
    
    for (NSString *key in properties.allKeys) {
        id value = [properties objectForKey:key];
        if (value) {
            [entity setValue:value forKey:key];
        }
    }
    
    [[CSCoreDataClient shareClient]saveContext];
}

- (id)fetchObjByEntity:(NSEntityDescription*)entity withClassName:(NSString*)className
{
    NSDictionary *properties = [entity selfPropertyDictionary];
    id obj = [NSObject objectOfClass:className fromJSON:properties];
    return obj;
}

- (DJReadUser*)fetchUser:(NSString*)account password:(NSString*)password
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account = %@",account];
    UserEntity *userEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"UserEntity"] lastObject];
    
    if (!userEntity) return nil;
    DJReadUser *user = [self fetchUser:userEntity];
    return user;
}

//根据模型去CoreData查找对应实体
- (FileEntity*)fetchFileEntity:(DJFileDocument*)file
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %ld",file.id];
    FileEntity *fileEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"FileEntity"] lastObject];
    return fileEntity;
}

- (SealEntity*)fetchSealEntityByID:(int64_t)id
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %ld",id];
    SealEntity *sealEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"SealEntity"]lastObject];
    return sealEntity;
}

- (FloderEntity*)fetchFloderEntity:(DJFloder*)floder
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %ld",floder.id];
    FloderEntity *floderEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"FloderEntity"] lastObject];
    return floderEntity;
}

- (UserEntity*)fetchUserEntity:(DJReadUser*)user
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %ld",user.id];
    UserEntity *entity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"UserEntity"] lastObject];
    return entity;
}

- (DJFileDocument*)fetchFileDocument:(FileEntity*)fileEntity
{
    if (fileEntity.id == 0) return nil;
    DJFileDocument *fileDocument = [[DJFileDocument alloc]init];
    fileDocument.id = fileEntity.id;
    fileDocument.name = fileEntity.name;
    fileDocument.create_time = fileEntity.create_time;
    fileDocument.modificationDate = fileEntity.modificationDate;
    fileDocument.last_open_time = fileEntity.last_open_time;
    fileDocument.last_read_position = fileEntity.last_read_position;
    fileDocument.length = fileEntity.length;
    fileDocument.star = fileEntity.star;
    fileDocument.status = fileEntity.status;
    fileDocument.filePath = fileEntity.filePath;
    
    for (FloderEntity *floderEntity in fileEntity.superFloders) {
        [fileDocument.superFloders addObject:@(floderEntity.id)];
    }
    return fileDocument;
}

- (DJFloder*)fetchFloder:(FloderEntity*)floderEntity
{
    DJFloder *floder = [[DJFloder alloc]init];
    floder.id = floderEntity.id;
    floder.name = floderEntity.name;
    floder.status = floderEntity.status;
    for (FileEntity *fileEntiy in floderEntity.files) {
        [floder.files addObject:@(fileEntiy.id)];
    }
    return floder;
}

- (DJReadUser*)fetchUser:(UserEntity*)userEntity
{
    NSDictionary *dic = [userEntity selfPropertyDictionary];
    DJReadUser *user = [NSObject objectOfClass:@"DJReadUser" fromJSON:dic];
    return user;
}

- (DJReadUser*)loadDefaultUser
{
    [[CSCoreDataClient shareClient]loginAccount:DEFAULTUSER_ACOUNT password:DEFAULTUSER_PWD];
    DJReadUser *defalutUser = [self fetchUser:DEFAULTUSER_ACOUNT password:DEFAULTUSER_PWD];
    
    if (!defalutUser) {
        NSMutableDictionary *userProperties = [[NSMutableDictionary alloc]init];
        [userProperties setValue:@(DEFAULTUSER_ID) forKey:@"id"];
        [userProperties setValue:DEFAULTUSER_ACOUNT forKey:@"account"];
        [userProperties setValue:DEFAULTUSER_NAME forKey:@"name"];
        [userProperties setValue:DEFAULTUSER_PWD forKey:@"password"];
        [self registerAccount:userProperties];
        defalutUser = [self fetchUser:DEFAULTUSER_ACOUNT password:DEFAULTUSER_PWD];
    }
    _manager.user = defalutUser;
    [self loadDefaultFloder];
    return defalutUser;
}
+ (BOOL)isLogin
{
    if (_manager.user) {
        return YES;
    }
    return NO;
}
- (void)loadDefaultFloder
{
    _browseFloderEntity = nil;
    _locaFloderEntity = nil;
    _meFloderEntity = nil;
    
    [self browseFloderEntity];
    [self locaFloderEntity];
    [self meFloderEntity];
    [[CSCoreDataClient shareClient]saveContext];
}

- (DJReadUser*)loginAccount:(NSString*)account password:(NSString*)password
{
    DJReadUser *user = [self fetchUser:account password:password];
    if (!user) {
        return nil;
    }else{
        if (![account isEqualToString:DEFAULTUSER_ACOUNT]){
            _manager.user = user;
        }
        [[CSCoreDataClient shareClient] loginAccount:account password:password];
    }
    return user;
}
- (void)loginUser:(DJReadUser*)user
{
    _manager.user = user;
}
- (DJReadUser*)registerAccount:(NSDictionary*)registerInfo;
{
    int64_t id = [[registerInfo objectForKey:@"id"] longLongValue];
    int64_t status = [[registerInfo objectForKey:@"status"] intValue];

    NSString* account = [registerInfo objectForKey:@"account"];
    NSString* name = [registerInfo objectForKey:@"name"];
    NSString* password = [registerInfo objectForKey:@"password"];
    NSString* email = [registerInfo objectForKey:@"email"];
    NSString* avatar = [registerInfo objectForKey:@"avatar"];
    NSString* openid = [registerInfo objectForKey:@"openid"];
    NSString* uphone = [registerInfo objectForKey:@"uphone"];
    
    NSMutableDictionary *userProperties = [[NSMutableDictionary alloc]init];
    [userProperties setValue:@(id) forKey:@"id"];
    [userProperties setValue:@(status) forKey:@"status"];
    [userProperties setValue:account forKey:@"account"];
    [userProperties setValue:name forKey:@"name"];
    [userProperties setValue:email forKey:@"email"];
    [userProperties setValue:avatar forKey:@"avatar"];
    [userProperties setValue:password forKey:@"password"];
    [userProperties setValue:openid forKey:@"openid"];
    [userProperties setValue:uphone forKey:@"uphone"];

    [[CSCoreDataClient shareClient] insertEntity:@"UserEntity" properties:userProperties];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account = %@ AND password = %@",account,password];
    UserEntity * userEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"UserEntity"] lastObject];
    DJReadUser *registerUser = [self fetchUser:userEntity];
    return registerUser;
}
- (DJFileDocument*)writeFileData:(NSData*)fileData withName:(NSString*)fileName
{
    FloderDirectoryOption directories = FloderDirectoryOptionLoca;
    NSArray *files = [[CSCoreDataManager shareManager]fetchFileByFileName:fileName];
    
    if (files.count >= 1)
        [[CSCoreDataManager shareManager]deleteFileToCoreData:[files lastObject]];
    DJFileDocument *file = [self organizeFileInfoByData:fileData forName:fileName];//组织模型
    FileEntity *fileEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FileEntity" inManagedObjectContext:[CSCoreDataClient shareClient].context];
    fileEntity.id = file.id;
    fileEntity.name = file.name;
    fileEntity.sourceName = file.sourceName;
    fileEntity.create_time = file.create_time;
    fileEntity.filePath = file.filePath;
    fileEntity.last_read_position = file.last_read_position;
    fileEntity.last_open_time = file.last_open_time;
    fileEntity.status = file.status;
    fileEntity.star = file.star;
    fileEntity.length = file.length;
    
    if ((directories & FloderDirectoryOptionBrowse) > 0)
        {[self.browseFloderEntity addFilesObject:fileEntity];}
    if ((directories & FloderDirectoryOptionLoca) >0)
        {[self.browseFloderEntity addFilesObject:fileEntity];}
    if ((directories & FloderDirectoryOptionMe) >0)
        {[self.browseFloderEntity addFilesObject:fileEntity];}
    
    [[CSCoreDataClient shareClient] saveContext];
    return file;
}
- (DJFileDocument*)writeSourceFile:(NSString*)source
{
    FloderDirectoryOption directories = FloderDirectoryOptionLoca;
    NSArray *files = [self hasSameNameFile:source];
    DJFileDocument *file = [self organizeFileInfoByPath:source];//组织模型
    
    if (files.count > 0) {
        [[CSCoreDataManager shareManager] updataFileToCoreData:file];
    }else{
        FileEntity *fileEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FileEntity" inManagedObjectContext:[CSCoreDataClient shareClient].context];
        fileEntity.id = file.id;
        fileEntity.name = file.name;
        fileEntity.sourceName = file.sourceName;
        fileEntity.modificationDate = file.modificationDate;
        fileEntity.create_time = file.create_time;
        fileEntity.filePath = file.filePath;
        fileEntity.last_read_position = file.last_read_position;
        fileEntity.last_open_time = file.last_open_time;
        fileEntity.status = file.status;
        fileEntity.star = file.star;
        fileEntity.length = file.length;
        
        if ((directories & FloderDirectoryOptionBrowse) > 0)
            {[self.browseFloderEntity addFilesObject:fileEntity];}
        if ((directories & FloderDirectoryOptionLoca) >0)
            {[self.browseFloderEntity addFilesObject:fileEntity];}
        if ((directories & FloderDirectoryOptionMe) >0)
            {[self.browseFloderEntity addFilesObject:fileEntity];}
    }
    [[CSCoreDataClient shareClient] saveContext];
    return file;
}
- (void)deleteFileToCoreData:(DJFileDocument*)file
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",file.id];
    [[CSCoreDataClient shareClient] deleteEntity:predicate fromEntityName:@"FileEntity"];
    [[DJFileManager shareManager] deleteFile:file.filePath];
}
- (void)updataFileToCoreData:(DJFileDocument*)file
{
//    根据id找文件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",file.id];
//    FileEntity *fileEntity = [[[CSCoreDataClient shareClient] fetchEntities:predicate fromEntityName:@"FileEntity"] lastObject];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",file.id];
    FileEntity *fileEntity = [[[CSCoreDataClient shareClient] fetchEntities:predicate fromEntityName:@"FileEntity"] lastObject];
    [fileEntity removeSuperFloders:fileEntity.superFloders];
    
    NSArray *superFloders = file.superFloders;
    for (int i =0;i<superFloders.count;i++) {
        NSPredicate *floderPredicate = [NSPredicate predicateWithFormat:@"id = %ld",[[superFloders objectAtIndex:i]intValue]];
        FloderEntity *newFloderEntity = [[[CSCoreDataClient shareClient]fetchEntities:floderPredicate fromEntityName:@"FloderEntity"] lastObject];
        [fileEntity addSuperFlodersObject:newFloderEntity];
    }
    [[CSCoreDataClient shareClient] updateEntity:predicate fromEntityName:@"FileEntity" properties:[file selfPropertyDictionary]];
}
- (void)updataUserInfo:(DJReadUser*)user
{
    NSPredicate *predicate;
    if (user.uphone.length == 11) {
        predicate = [NSPredicate predicateWithFormat:@"uphone = %@",user.uphone];
    }else if(user.openid){
        predicate = [NSPredicate predicateWithFormat:@"openid = %@",user.openid];
    }else{
        return;
    }
    [DJReadManager shareManager].loginUser.uphone = user.uphone;
    [DJReadManager shareManager].loginUser.openid = user.openid;
    [[CSCoreDataClient shareClient] updateEntity:predicate fromEntityName:@"UserEntity" properties:[user selfPropertyDictionary]];
}
- (NSArray<DJFileDocument*>*)fetchFileByFileName:(NSString*)fileName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",fileName];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    NSArray *files = [self fetchAllFileFromCoreData:predicate descriptors:descriptor];
    return files;
}
- (NSArray<DJFileDocument*>*)fetchFileContainName:(NSString*)fileName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sourceName = %@",fileName];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    NSArray *files = [self fetchAllFileFromCoreData:predicate descriptors:descriptor];
    return files;
}

- (NSMutableArray<DJFileDocument*>*)fetchAllFileFromCoreData
{
    NSPredicate *predicate;
    NSArray *fileEntities = [[CSCoreDataClient shareClient] fetchEntities:predicate fromEntityName:@"FileEntity"];
    NSMutableArray *files = [[NSMutableArray alloc]init];
    
    for (FileEntity *entity in fileEntities)
    {
        DJFileDocument *file = [self fetchFileDocument:entity];
        NSData *data = [[NSData alloc]initWithContentsOfFile:file.filePath];
        if (data) {
            [files addObject:file];
        }else{
            [[CSCoreDataManager shareManager]deleteFileToCoreData:file];
        }
    }
    return files;
}

- (NSArray<DJFileDocument*>*)fetchAllFileFromCoreData:(NSPredicate*)predicate descriptors:(NSSortDescriptor *)descriptor{
    NSArray *fileEntities = [[CSCoreDataClient shareClient]fetchEntitiesPredicate:predicate fromEntityName:@"FileEntity" descriptors:descriptor];
    NSMutableArray *files = [[NSMutableArray alloc]init];
    
    for (FileEntity *entity in fileEntities) {
        DJFileDocument *file = [self fetchFileDocument:entity];
        NSData *fileData = [[NSData alloc]initWithContentsOfFile:file.filePath];
        if (fileData){
           [files addObject:file];
        }else{
           [[CSCoreDataManager shareManager]deleteFileToCoreData:file];
        }
    }
    return files;
}

- (NSArray<DJFloder*>*)fetchAllFlodersFromCoreData
{
    NSArray *floderEntities = [[CSCoreDataClient shareClient] fetchEntities:nil fromEntityName:@"FloderEntity"];
    NSMutableArray *floders = [[NSMutableArray alloc]init];
    for (FloderEntity *floderEntity in floderEntities) {
        DJFloder *floder = [self fetchFloder:floderEntity];
        [floders addObject:floder];
    }
    return floders;
}

- (DJFileDocument*)fectchFileDocumentByID:(int64_t)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",id];
    FileEntity *fileEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"FileEntity"] lastObject];
    return [self fetchFileDocument:fileEntity];
}
- (DJFileDocument*)fectchFileDocumentByEntity:(FileEntity*)entity
{
    return [self fetchFileDocument:entity];
}

- (DJFloder*)fectchFloderByID:(int64_t)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",id];
    FloderEntity *floderEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"FloderEntity"] lastObject];
    return [self fetchFloder:floderEntity];
}

- (NSArray<DJFileDocument*>*)fetchFloderFilesByID:(int64_t)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %ld",id];
    FloderEntity *floderEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"FloderEntity"] lastObject];
    
    NSMutableArray *files = [[NSMutableArray alloc]init];
    for(FileEntity *fileEntity in floderEntity.files)
    {
        [files addObject:[self fetchFileDocument:fileEntity]];
    }
    return files;
}

//判断模型路径下的文件是否是coreData模型下的文件，是否需要改名 0:改名，写入本地 1:不用重新写入 2:不需要改名,需要写入本地
- (NSInteger)file:(NSString*)sourceFilePath mapFile:(DJFileDocument*)file
{
    NSString *fileMD5 = fileMD5WithPath(sourceFilePath);
    NSString *EntityMD5 = fileMD5WithPath(file.filePath);
    
    if ([fileMD5 isEqualToString:EntityMD5]) {//内容相同
        //如果内容相同，名字相同，不需要写入
        return 1;
    }else{
        return 2;
    }
}
- (NSArray*)hasSameNameFile:(NSString*)source
{
    NSString *fileName = [source lastPathComponent];
    NSArray *files = [self fetchFileContainName:fileName];
    return files;
}
//判断模型路径下的文件是否是coreData模型下的文件，是否需要改名 0:改名，写入本地 1:不用重新写入 2:不需要改名,需要写入本地
- (NSInteger)file:(NSString*)filePath mapEntity:(FileEntity*)fileEntity
{
    NSString *sourceName = [[filePath.lastPathComponent componentsSeparatedByString:@"#"]lastObject];
    NSString *fileMD5 = fileMD5WithPath(filePath);
    NSString *EntityMD5 = fileMD5WithPath(fileEntity.filePath);

    if (![fileMD5 isEqualToString:EntityMD5] && [sourceName isEqualToString:fileEntity.name]) {
        //名字相同，内容不同，需要改名，并写入本地
        return 0;
    }else if ([fileMD5 isEqualToString:EntityMD5] && [sourceName isEqualToString:fileEntity.name]) {
        //名字相同，内容相同，取出旧的不用写
        return 1;
    }else{
        //名字不同,需要写进本地
        return 2;
    }
}
- (void)writeSeal:(SealUnit*)sealUnit
{
    SealEntity *sealEntity = [self fetchSealEntityByID:sealUnit.id];
    if (sealEntity) return;
    
    sealEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SealEntity" inManagedObjectContext:self.context];
    
    [self setEntity:(NSEntityDescription*)sealEntity byObj:sealUnit];
    [[CSCoreDataClient shareClient]saveContext];
}

- (void)updateSeal:(SealUnit*)sealUnit
{
    SealEntity *sealEntity = [self fetchSealEntityByID:sealUnit.id];
    if (!sealEntity) return;
    [self setEntity:(NSEntityDescription*)sealEntity byObj:sealUnit];
}
- (void)deleteSealByID:(int64_t)sealID
{
    SealEntity *sealEntity = [self fetchSealEntityByID:sealID];
    if (!sealEntity) return;
    [self.context deleteObject:sealEntity];
}

- (SealUnit*)fetchSealByID:(int64_t)sealID
{
    SealEntity *sealEntity = [self fetchSealEntityByID:sealID];
    SealUnit *unit = [self fetchObjByEntity:(NSEntityDescription*)sealEntity withClassName:@"SealUnit"];
    return unit;
}
- (SealUnit*)fetchSeal:(SealEntity*)sealEntity
{
    SealUnit *unit = [self fetchSealByID:sealEntity.id];
    return unit;
}

- (SealUnit*)fetchSealBySource:(NSString*)source
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"source = %@",source];
    SealEntity *sealEntity = [[[CSCoreDataClient shareClient]fetchEntities:predicate fromEntityName:@"SealEntity"]lastObject];
    SealUnit *unit = [self fetchObjByEntity:(NSEntityDescription*)sealEntity withClassName:@"SealUnit"];
    return unit;
}

#pragma Plist
- (NSString*)userPlist
{
    if (!_userPlist) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [documentPaths objectAtIndex:0];
        NSString *directory = [documentPath stringByAppendingPathComponent:@"用户"];
        NSString *filePath = [directory stringByAppendingPathComponent:@"用户列表.plist"];
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        
        if (![fileManager fileExistsAtPath:filePath]) {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        _userPlist = filePath;
    }
    return _userPlist;
}

//以时间为Key，账户密码组成的字典作为值组成用户缓存列表
- (void)cacheUser:(DJReadUser*)user
{
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:DateFormatter];
    NSString *timeFlag=[dateformatter stringFromDate:date];
    NSMutableDictionary *userList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.userPlist];
    
    if (userList == nil)
    {
        userList = [[NSMutableDictionary alloc]init];
    }
    NSDictionary *userInfo = @{timeFlag:user.name,};
    [userList setObject:userInfo forKey:user.account];//以时间为Key，
    [userList writeToFile:self.userPlist atomically:YES];
}

//判断之前有没有用户登入
- (void)fetchPrvUser:(void(^)(DJReadUser*user))hander
{
    DJReadUser *prvUser;
    //所有缓存用户的额列表
    NSMutableDictionary *userList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.userPlist];
    if (!userList) hander(nil);
    NSDate *prvDate;
    NSString *prvAccount;
    
    for (NSString *key in userList.allKeys) {
        NSDictionary *info = [userList objectForKey:key];
        NSString *timeDateStr = [info.allKeys lastObject];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:DateFormatter];
        NSDate *tmpDate = [dateFormatter dateFromString:timeDateStr];

        NSComparisonResult result = [prvDate compare:tmpDate];
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            prvDate = tmpDate;
            prvAccount = key;
        }
    }
    prvUser = [self fetchUser:prvAccount password:@""];
    if (!prvUser && hander){
        hander(prvUser);
        return;
    }
    [[DJReadManager shareManager]requestUserInfo:prvUser.uphone andOpenid:prvUser.openid complete:hander];
}

- (BOOL)fetchPrvUserIsVIP
{
    DJReadUser *prvUser;
    //所有缓存用户的额列表
    NSMutableDictionary *userList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.userPlist];
    NSDate *prvDate;
    NSString *prvAccount;
    
    for (NSString *key in userList.allKeys) {
        NSDictionary *info = [userList objectForKey:key];
        NSString *timeDateStr = [info.allKeys lastObject];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:DateFormatter];
        NSDate *tmpDate = [dateFormatter dateFromString:timeDateStr];

        NSComparisonResult result = [prvDate compare:tmpDate];
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            prvDate = tmpDate;
            prvAccount = key;
        }
    }
    prvUser = [self fetchUser:prvAccount password:@""];
    if (prvUser && prvUser.isvip == 1) {
        return YES;
    }else{
        return NO;
    }
}
- (void)cleanCacheUser
{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:self.userPlist]) {
        [fileManager removeItemAtPath:self.userPlist error:nil];
        self.userPlist = nil;
    }
    [CSCoreDataManager shareManager].user = nil;
}

//判断一定时间内有没有用户登录
- (DJReadUser*)prvUser:(int)time
{
    NSDate *  date = [NSDate dateWithTimeIntervalSinceNow:0];
    date = [date dateByAddingTimeInterval:-time * 60];
    DJReadUser *prvUser;
    //所有缓存用户的额列表
    NSMutableDictionary *userList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.userPlist];
    NSDate *prvDate;
    NSString *prvAccount;
    NSDictionary *prvInfo;
    NSString *prvPWD;
    
    for (NSString *key in userList.allKeys) {
        NSDictionary *info = [userList objectForKey:key];
        NSString *timeDateStr = [info.allKeys lastObject];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:DateFormatter];
        NSDate *tmpDate = [dateFormatter dateFromString:key];

        NSComparisonResult result = [prvDate compare:tmpDate];
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            prvDate = tmpDate;
            prvInfo = info;
            prvAccount = key;
            prvPWD = [info objectForKey:timeDateStr];
        }
    }
    
    if(!prvDate) return nil;
    NSComparisonResult result = [prvDate compare:date];//如果最后一个用户在30分钟内登录过了
    if (result == NSOrderedAscending) {
        return nil;
    }else{
        prvUser = [self fetchUser:prvAccount password:prvPWD];
        return prvUser;
    }
}

#pragma SomeMethod
//查看是否有相同内容的文件
- (BOOL)fileIsDuplicate:(NSString *)source
{
    NSArray *fileComponents = [source.lastPathComponent componentsSeparatedByString:@"#"];
    NSString *fileName = [fileComponents lastObject];
    NSArray *files = [self fetchFileByFileName:fileName];
    NSInteger writeType = 0;
    DJFileDocument *sourceDocument;
    
    for (DJFileDocument *fileDocument in files) {
        writeType = [self file:source mapFile:fileDocument];
        if (writeType == 1) {
            sourceDocument = fileDocument;
            break;
        }
    }
    if (writeType == 1) {//名字一样，内容一样
        return YES;
    }else{//名字一样，内容不一样，要改名
        return NO;
    }
}
- (DJFileDocument*)organizeFileInfoByData:(NSData*)fileData forName:(NSString*)fileName
{
    long fileID = [[CSSnowIDFactory shareFactory] nextID];
    //long create_time = [CSSnowIDFactory getCurrentDateInterval];
    long create_time = 1606816860000;
    long last_Open_time = create_time;
    
    NSString *namePath = [[NSString alloc]initWithFormat:@"%lu#%@",create_time,fileName];
    NSString *filePath = [DJFileManager pathInOFDFloderDirectoryWithFileName:namePath];
    [fileData writeToFile:filePath atomically:YES];
    
    NSDictionary *info = @{@"filePath":filePath,
                           @"fileData":fileData,
                           @"name":fileName,
                           @"sourceName":fileName,
                           @"id":@(fileID),
                           @"create_time":@(create_time),
                           @"last_open_time":@(last_Open_time),
                           @"length":@(fileData.length)};
    return [NSObject objectOfClass:@"DJFileDocument" fromJSON:info];
}
- (DJFileDocument*)organizeFileInfoByPath:(NSString*)source fileCount:(NSInteger)count
{
    long long fileID = [[CSSnowIDFactory shareFactory] nextID];
    long long  create_time = [CSSnowIDFactory getCurrentDateInterval];
    long long last_Open_time = create_time;
    
    NSString *sourceName = [source lastPathComponent];
    NSString *firstName = [[sourceName componentsSeparatedByString:@"."] firstObject];
    NSString *fileType = [[sourceName componentsSeparatedByString:@"."] lastObject];
    NSString *fileName;
    
    if (count == 0) {
        fileName = [[NSString alloc]initWithFormat:@"%@.%@",firstName,fileType];
    }else{
        fileName = [[NSString alloc]initWithFormat:@"%@_%lu.%@",firstName,count+1,fileType];
    }
    
    NSString *namePath = [[NSString alloc]initWithFormat:@"%lld#%@",create_time,fileName];
    NSString *newPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:namePath];
    NSData *fileData = [NSData dataWithContentsOfFile:source];
    [fileData writeToFile:newPath atomically:YES];
    [[DJFileManager shareManager] deleteFile:source];
    
    NSDictionary *info = @{@"filePath":newPath,
                           @"fileData":fileData,
                           @"name":fileName,
                           @"sourceName":sourceName,
                           @"id":@(fileID),
                           @"create_time":@(create_time),
                           @"last_open_time":@(last_Open_time),
                           @"length":@(fileData.length)};
    return [NSObject objectOfClass:@"DJFileDocument" fromJSON:info];
}
- (DJFileDocument*)organizeFileInfoByPath:(NSString*)source
{
    long long fileID = [[CSSnowIDFactory shareFactory] nextID];
    long long create_time = [CSSnowIDFactory getCurrentDateInterval];
    long long last_Open_time = create_time;
    long long modificationTime = [DJFileManager getFileModificationDateInterval:source];
    
    NSString *sourceName = [source lastPathComponent];
    NSString *newPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:sourceName];
    
    NSData *fileData = [NSData dataWithContentsOfFile:source];
    if (![source isEqualToString:newPath]) {
        [fileData writeToFile:newPath atomically:YES];
        [[DJFileManager shareManager] deleteFile:source];
    }
    NSDictionary *info = @{@"filePath":newPath,
                           @"fileData":fileData,
                           @"name":sourceName,
                           @"sourceName":sourceName,
                           @"modificationDate":@(modificationTime),
                           @"id":@(fileID),
                           @"create_time":@(create_time),
                           @"last_open_time":@(last_Open_time),
                           @"length":@(fileData.length)};
    return [NSObject objectOfClass:@"DJFileDocument" fromJSON:info];
}
- (void)dealloc
{
    _browseFloderEntity = nil;
    _locaFloderEntity = nil;
    _meFloderEntity = nil;
}
@end
