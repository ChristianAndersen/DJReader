//
//  CSSnowIDFactory.m
//  DJReader
//
//  Created by Andersen on 2020/3/31.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "CSSnowIDFactory.h"
#import <sys/time.h>
#import <Security/SecRandom.h>
#import "MD5.h"
static CSSnowIDFactory *_factory;
@interface CSSnowIDFactory()
@property(nonatomic,assign)long workerId,datacenterId,sequence,twepoch,workerIdBits,datacenterIdBits,maxWorkerId;
@property(nonatomic,assign)long maxDatacenterId;//最大支持数据中心节点数0~31，一共32个
@property(nonatomic,assign)long sequenceBits;//序列号12位
@property(nonatomic,assign)long workerIdShift;//机器节点左移12位
@property(nonatomic,assign)long datacenterIdShift;//数据中心节点左移17位
@property(nonatomic,assign)long timestampLeftShift;//时间毫秒数左移22位
@property(nonatomic,assign)long sequenceMask;//最大为4095
@property(nonatomic,assign)long lastTimestamp;
@end

@implementation CSSnowIDFactory
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _factory = [super allocWithZone:zone];
        [_factory initValues];
    });
    return _factory;
}

+ (CSSnowIDFactory*)shareFactory
{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken,^{
         _factory = [[CSSnowIDFactory alloc]init];
         [_factory initValues];
     });
    
     return _factory;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _factory;
}

- (instancetype)initWith:(long)workerId datacenterID:(long)datacenterId
{
    if (self = [super init]) {
        [self initValues];
        if (workerId > _maxWorkerId || workerId < 0)return nil;
        if (datacenterId > _maxDatacenterId || datacenterId < 0)return nil;
            
        _workerId = workerId;
        _datacenterId = datacenterId;
    }
    
    return self;
}

- (void)initValues
{
    _sequence = 0L;
    _twepoch = 1288834974657L;//唯一随机时间变量
    //Thu, 04 Nov 2010 01:42:54 GMT
    _workerIdBits = 5L;
    //节点ID长度
    _datacenterIdBits = 5L;
    //数据中心ID长度
    _maxWorkerId = -1L ^ (-1L << _workerIdBits);
    //最大支持机器节点数0~31，一共32个
    _maxDatacenterId = -1L ^ (-1L << _datacenterIdBits);
    //最大支持数据中心节点数0~31，一共32个
    _sequenceBits = 12L;
    //序列号12位
    _workerIdShift = _sequenceBits;
    //机器节点左移12位
    _datacenterIdShift = _sequenceBits + _workerIdBits;
    //数据中心节点左移17位
    _timestampLeftShift = _sequenceBits + _workerIdBits + _datacenterIdBits;
    //时间毫秒数左移22位
    _sequenceMask = -1L ^ (-1L << _sequenceBits);
    //最大为4095
    _lastTimestamp = -1L;
}

- (NSString*)getSnowFlakeID
{
    NSString *dateFormat = [CSSnowIDFactory getCurrentTimeDate];
    return [NSString stringWithFormat:@"%@%ld",dateFormat,[self nextID]];
}

- (long)nextID
{
    long timestamp = [CSSnowIDFactory getCurrentDateInterval];
    if (timestamp == _lastTimestamp) {
        _sequence = (_sequence + 1) & _sequenceMask;
        
        if (_sequence == 0) {
            //自旋等待下一秒
            timestamp = [self tilNextMillis:_lastTimestamp];
        }
    }else{
        _sequence = 0L;
    }
    _lastTimestamp = timestamp;
    long nextID= ((timestamp - _twepoch) << _timestampLeftShift) | (_datacenterId << _datacenterIdShift) | (_workerId << _workerIdShift) | _sequence;
    return nextID;
}
//自旋等待
- (long)tilNextMillis:(long)lastTimeStamp
{
    long timestamp = [CSSnowIDFactory getCurrentDateInterval];
    while (timestamp <= lastTimeStamp) {
        timestamp = [CSSnowIDFactory getCurrentDateInterval];
    }
    return timestamp;
}

+ (NSString*)getCurrentTimeDate
{
    NSDate *  senddate=[NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
   
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SS"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

+ (int64_t)getCurrentTimeDateIntValue
{
    NSDate *  senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddhhmmSSS"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return [locationString longLongValue];
}

+ (long)getCurrentDateInterval{
    NSDate *dateNow = [NSDate date];
    long timesp = (long)[dateNow timeIntervalSince1970]*1000;
    return timesp;
}

+ (NSString *)randomKey
{
    /* Get Random UUID */
    NSString *UUIDString;
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    CFStringRef UUIDStringRef = CFUUIDCreateString(NULL, UUIDRef);
    UUIDString = (NSString *)CFBridgingRelease(UUIDStringRef);
    CFRelease(UUIDRef);
    /* Get Time */
    double time = CFAbsoluteTimeGetCurrent();
    /* MD5 With Sale */
    return [[NSString stringWithFormat:@"%@%f", UUIDString, time] MD5];
}

@end
