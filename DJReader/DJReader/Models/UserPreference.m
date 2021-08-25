//
//  UserPreference.m
//  DJReader
//
//  Created by Andersen on 2020/4/23.
//  Copyright © 2020 Andersen. All rights reserved.
//

#import "UserPreference.h"

@implementation UserPreference

- (NSString*)fontNum
{
    if (!_fontNum) {
         _fontNum = [self.fontsNum objectAtIndex:0];
    }
    return _fontNum;
}
- (NSString*)fontName
{
    if (!_fontName) {
        _fontName = [self.fontsName.allKeys objectAtIndex:0];
    }
    return _fontName;
}
- (NSString*)fontNameKey
{
    if (!_fontNameKey) {
        _fontNameKey = [self.fontsName.allValues objectAtIndex:0];
    }
    return _fontNameKey;
}
- (ColorUnit*)colorUnit
{
    if (!_colorUnit) {
        _colorUnit = [self.colorUnits objectAtIndex:0];
    }
    return _colorUnit;
}

- (CGFloat)penWidth
{
    if (_penwidth < 1) {
        _penwidth = 3.0;
    }
    return _penwidth;
}
- (NSMutableArray*)fontsNum
{
    if (!_fontsNum) {
        _fontsNum = [[NSMutableArray alloc]init];
        [_fontsNum addObjectsFromArray:@[@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"]];
    }
    return _fontsNum;
}

- (NSMutableDictionary*)fontsName
{
    if (!_fontsName) {
        _fontsName = [[NSMutableDictionary alloc]init];
        [_fontsName setValue:@"PingFang SC" forKey:@"苹方"];
        [_fontsName setValue:@"KaiTi_GB2312" forKey:@"楷体"];
        [_fontsName setValue:@"FZFangSong-Z02S" forKey:@"仿宋"];
       // [_fontsName setValue:@"Songti SC" forKey:@"宋体"];
        [_fontsName setValue:@"Microsoft YaHei" forKey:@"雅黑"];
        [_fontsName setValue:@"HBXiYuanTi" forKey:@"圆体"];
        [_fontsName setValue:@"STXingkai" forKey:@"行楷"];
        [_fontsName setValue:@"FZTieJinLiShu-S17S" forKey:@"隶书"];
    }
    return _fontsName;
}

- (NSMutableArray*)colorUnits
{
    if (!_colorUnits) {
        _colorUnits = [[NSMutableArray alloc]init];
        NSArray*colors = @[@{@"r":@"0.0",@"g":@"0.0",@"b":@"0.0"},@{@"r":@"255.0",@"g":@"0.0",@"b":@"0.0"},@{@"r":@"0.0",@"g":@"255.0",@"b":@"0.0"},@{@"r":@"0.0",@"g":@"0.0",@"b":@"255.0"},@{@"r":@"255.0",@"g":@"255.0",@"b":@"0.0"},@{@"r":@"255.0",@"g":@"0.0",@"b":@"255.0"},@{@"r":@"0.0",@"g":@"255.0",@"b":@"255.0"},@{@"r":@"255.0",@"g":@"125.0",@"b":@"0.0"},@{@"r":@"255.0",@"g":@"0.0",@"b":@"125.0"},@{@"r":@"220.0",@"g":@"130.0",@"b":@"20.0"},@{@"r":@"20.0",@"g":@"140.0",@"b":@"60.0"},@{@"r":@"90.0",@"g":@"180.0",@"b":@"230.0"},@{@"r":@"200.0",@"g":@"100.0",@"b":@"80.0"},@{@"r":@"100.0",@"g":@"240.0",@"b":@"10.0"},@{@"r":@"20.0",@"g":@"40.0",@"b":@"60.0"},@{@"r":@"90.0",@"g":@"100.0",@"b":@"200.0"},@{@"r":@"210.0",@"g":@"189.0",@"b":@"50.0"},@{@"r":@"90.0",@"g":@"160.0",@"b":@"70.0"}];
        
        for (NSDictionary *color in colors) {
            ColorUnit *unit = [[ColorUnit alloc]init];
            unit.r = [[color objectForKey:@"r"] floatValue];
            unit.g = [[color objectForKey:@"g"] floatValue];
            unit.b = [[color objectForKey:@"b"] floatValue];
            [_colorUnits addObject:unit];
        }
    }
    return _colorUnits;
}
@end
