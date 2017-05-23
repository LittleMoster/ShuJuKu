//
//  FileUtils.h
//  数据库操作
//
//  Created by cguo on 2017/3/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject


+(BOOL)fileIsAtPath:(NSString*)path;

+(BOOL)deletefileAtPath:(NSString*)path;

+(BOOL)makeDirectory:(NSString*)path;

+(BOOL)copyItemAtPath:(NSString *)scrPath toPath:(NSString *)toPath;

+(BOOL)writDataToPath:(NSString*)path data:(NSData*)data;
@end
