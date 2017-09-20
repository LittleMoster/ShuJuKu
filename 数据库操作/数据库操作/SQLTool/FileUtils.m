//
//  FileUtils.m
//  数据库操作
//
//  Created by cguo on 2017/3/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+(BOOL)fileIsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}
+(BOOL)copyItemAtPath:(NSString *)scrPath toPath:(NSString *)toPath

{
//    NSLog(@"%@",toPath);
//    NSLog(@"%@",scrPath);
    return [[NSFileManager defaultManager]copyItemAtPath:scrPath toPath:toPath error:nil];
}

+(BOOL)deletefileAtPath:(NSString*)path
{
    return [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
}
//创建文件目录
+(BOOL)makeDirectory:(NSString*)path
{
    return [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}
+(BOOL)writDataToPath:(NSString *)path data:(NSData *)data
{
  return   [data writeToFile:path atomically:YES];
}
@end
