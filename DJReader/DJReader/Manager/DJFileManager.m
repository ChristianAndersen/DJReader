//
//  DJFileManger.m
//  DJReader
//
//  Created by Andersen on 2020/3/27.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "DJFileManager.h"
#import "CSSnowIDFactory.h"
#import "CSCoreDataManager.h"

@implementation DJFileManager

static DJFileManager *_manager;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _manager = [super allocWithZone:zone];
        [self initDirectory];
    });
    return _manager;
}

+ (DJFileManager*)shareManager
{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken,^{
         _manager = [[DJFileManager alloc]init];
         [self initDirectory];
     });
     return _manager;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

+ (NSString*)pathInUserDirectory
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    NSString * dicPath = [documentPath stringByAppendingPathComponent:DJReadUser_DIRECTORY];
    return dicPath;
}

+ (NSString*)pathInUserDirectoryWithFileName:(NSString*)fileName
{
    NSString *userDirectoryPath = [DJFileManager pathInUserDirectory];
    NSString *filePath=[userDirectoryPath stringByAppendingPathComponent:fileName];
    return filePath;
}
+ (NSString*)pathInDisplayDirectoryWithFileName:(NSString*)fileName{
    NSString *userDirectoryPath = [DJFileManager pathInUserDirectory];
    NSString *dicPath = [userDirectoryPath stringByAppendingPathComponent:DJReadFloder_DISPLAY];
    NSString *filePath=[dicPath stringByAppendingPathComponent:fileName];
    return filePath;
}
+ (NSString*)pathInOFDFloderDirectoryWithFileName:(NSString*)fileName
{
    NSString *userDirectoryPath = [DJFileManager pathInUserDirectory];
    NSString *dicPath = [userDirectoryPath stringByAppendingPathComponent:DJReadFloder_DIRECTORY];
    NSString *filePath=[dicPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString*)pathInSealFloderDirectoryWithFileName:(NSString*)fileName
{
    NSString *userDirectoryPath = [DJFileManager pathInUserDirectory];

    NSString *dicPath = [userDirectoryPath stringByAppendingPathComponent:DJReadFloder_DIRECTORY];
    NSString *filePath=[dicPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString*)userDirectoryWithUserName:(NSString*)userName
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    BOOL isDirectory;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    NSString* dicPath = [documentPath stringByAppendingPathComponent:DJReadUser_DIRECTORY];
    dicPath=[dicPath stringByAppendingPathComponent:userName];
    
    if ([fileManager fileExistsAtPath:dicPath isDirectory:&isDirectory]&&isDirectory) {
        return dicPath;
    }else{
        [fileManager createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dicPath;
}


+ (void)initDirectory
{
    [self createDirectory:DJReadUser_DIRECTORY];
    [self createDirectory:[DJReadUser_DIRECTORY stringByAppendingPathComponent:DJReadFloder_DISPLAY]];
    [self createDirectory:[DJReadUser_DIRECTORY stringByAppendingPathComponent:DJReadFloder_DIRECTORY]];
    [self createDirectory:[DJReadUser_DIRECTORY stringByAppendingPathComponent:DJReadSeal_DIRECTORY]];
    [self createDirectory:[DJReadUser_DIRECTORY stringByAppendingPathComponent:DJReadDatabase_DIRECTORY]];
}

+ (void)createDirectory:(NSString*)directory
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    directory = [documentPath stringByAppendingPathComponent:directory];
    
    if([fileManager fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory)
    {
        return;
    }else
    {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)deleteDirectory:(NSString*)directory
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    BOOL isDirectory;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    directory = [documentPath stringByAppendingPathComponent:directory];
    
    if([fileManager fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory)
    {
        [fileManager removeItemAtPath:directory error:nil];
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)writeFile:(NSString*)sourcePath toPath:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:sourcePath]) {
        [[NSData dataWithContentsOfFile:sourcePath] writeToFile:path atomically:YES];
    }
}

- (NSDictionary*)writeFileWithPath:(NSString*)filePath
{
    long fileID = [[CSSnowIDFactory shareFactory]nextID];
    long create_time = [CSSnowIDFactory getCurrentDateInterval];
    long last_Open_time = create_time;
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    if (!fileData) return nil;
    
    NSString *fileName = [filePath lastPathComponent];
    NSArray *nameComponents = [fileName componentsSeparatedByString:@"#"];
    fileName = [nameComponents lastObject];
    NSString *localPathName = [NSString stringWithFormat:@"%ld#%@",fileID,fileName];
    NSString *localPath = [DJFileManager pathInOFDFloderDirectoryWithFileName:localPathName];
    [fileData writeToFile:localPath atomically:YES];
    
    NSDictionary *info = @{@"filePath":localPath,@"fileData":fileData,@"name":fileName,@"id":@(fileID),@"create_time":@(create_time),@"last_open_time":@(last_Open_time),@"length":@(fileData.length)};
    return info;
}
//转换完成
- (void)readLocaFile:(NSString*)diretory writeTo:(NSMutableDictionary*)fileList
{
    if (!diretory)return;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:diretory];
    NSString *filePath;
    NSArray *dirEnums = [dirEnum allObjects];
    
    for (id fileName in dirEnums) {
        BOOL isDiretory;
        filePath = [diretory stringByAppendingPathComponent:fileName];
        [manager fileExistsAtPath:filePath isDirectory:&isDiretory];
        
        if (isDiretory) {
            continue;
        }else if(([fileName containsString:@".pdf"]||[fileName containsString:@".aip"]||[fileName containsString:@".ofd"]||[fileName containsString:@".docx"])&&![filePath containsString:@"/temp"]&&![filePath containsString:@"Inbox"]&&![filePath containsString:DJReadFloder_DISPLAY]){
            NSString *key = [fileName lastPathComponent];
            NSArray *files = [[CSCoreDataManager shareManager] fetchFileByFileName:key];//利用files判断有没有写过本地文件
            if ([manager fileExistsAtPath:filePath] && files.count == 0)
            {
                [fileList setValue:filePath forKey:key];
            }
        }
    }
}
- (void)initCoreData:(NSString*)diretory writeTo:(NSMutableDictionary*)fileList
{
        if (!diretory)return;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:diretory];
        NSString *filePath;
        NSArray *dirEnums = [dirEnum allObjects];
        
        for (id fileName in dirEnums) {
            filePath = [diretory stringByAppendingPathComponent:fileName];
            BOOL isDiretory;
            [manager fileExistsAtPath:filePath isDirectory:&isDiretory];
            
            if (isDiretory) {
                continue;
            }else if(([fileName containsString:@".pdf"]||[fileName containsString:@".aip"]||[fileName containsString:@".ofd"])&&![filePath containsString:@"/temp"]&&![filePath containsString:@"com.dianju.OFD-Inbox"]&&![filePath containsString:DJReadFloder_DISPLAY]){
                NSString *key = [fileName lastPathComponent];
                if ([manager fileExistsAtPath:filePath]) {
                    [fileList setValue:filePath forKey:key];
                }
            }
        }
}

- (void)readFileIn:(NSString*)diretory writeTo:(NSMutableDictionary*)fileList
{
    if (!diretory)return;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:diretory];
    NSString *filePath;
    
    NSArray *dirEnums = [dirEnum allObjects];
    
    for (id fileName in dirEnums) {
        filePath = [diretory stringByAppendingPathComponent:fileName];
        BOOL isDiretory;
        [manager fileExistsAtPath:filePath isDirectory:&isDiretory];
        
        if (isDiretory) {
            continue;
        }else if(([fileName containsString:@".pdf"]||[fileName containsString:@".aip"]||[fileName containsString:@".ofd"])&&![filePath containsString:@"/temp"]&&![filePath containsString:DJReadFloder_DISPLAY]){
            NSString *key = [fileName lastPathComponent];
            
            if ([manager fileExistsAtPath:filePath]) {
                [fileList setValue:filePath forKey:key];
            }
        }
    }
}

- (void)deleteFile:(NSString*)sourcePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSData *data = [[NSData alloc]initWithContentsOfFile:sourcePath];
    if(data)
    {
        [fileManager removeItemAtPath:sourcePath error:nil];
    }
}
+ (void)judgeFile:(NSString*)filePath support:(void(^)(void))support unSupport:(void(^)(void))unSupport unKnown:(void(^)(void))unKnown
{
    NSString *extension = [filePath pathExtension];
    if ([extension isEqualToString:@"aip"]||[extension isEqualToString:@"pdf"]||[extension isEqualToString:@"ofd"]) {
        if (support)  support();
    }else if([extension isEqualToString:@"doc"]||[extension isEqualToString:@"ppt"]||[extension isEqualToString:@"xls"]||[extension isEqualToString:@"docx"]||[extension isEqualToString:@"pptx"]||[extension isEqualToString:@"xlsx"]){
        if (unSupport) unSupport();
    }else{
        if (unKnown) unKnown();
    }
}
+ (NSDictionary *)getFileAttribute:(NSString*)source
{
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:source error:&error];
    if (fileAttributes) {
        NSNumber *fileSize;
        NSString *fileOwner, *creationDate;
        NSDate *fileModDate;
        //文件大小
        if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
        }
        //文件创建日期
        if ((creationDate = [fileAttributes objectForKey:NSFileCreationDate])) {
            NSLog(@"File creationDate: %@\n", creationDate);
        }
        //文件所有者
        if ((fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName])) {
            NSLog(@"Owner: %@\n", fileOwner);
        }
        //文件修改日期
        if ((fileModDate = [fileAttributes objectForKey:NSFileModificationDate])) {
            NSLog(@"Modification date: %@\n", fileModDate);
        }
    }
    return fileAttributes;
}
+ (NSString*)getFileCreateDate:(NSString*)source
{
    NSDictionary *fileAttributes = [DJFileManager getFileAttribute:source];
    NSString *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
    return creationDate;
}
+ (NSString*)getFileOwner:(NSString*)source
{
    NSDictionary *fileAttributes = [DJFileManager getFileAttribute:source];
    NSString *owner = [fileAttributes objectForKey:NSFileOwnerAccountName];
    return owner;
}
+ (NSString*)getFileModificationDate:(NSString*)source
{
    NSDictionary *fileAttributes = [DJFileManager getFileAttribute:source];
    NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *modificationStr = [dateFormatter stringFromDate:fileModDate];
    return modificationStr;
}
+ (long)getFileModificationDateInterval:(NSString*)source
{
    NSDictionary *fileAttributes = [DJFileManager getFileAttribute:source];
    NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
    NSTimeInterval timeInterval = fileModDate.timeIntervalSince1970*1000;
    return timeInterval;
}
@end
