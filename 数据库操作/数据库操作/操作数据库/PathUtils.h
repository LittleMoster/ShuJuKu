//
//  PathUtils.h
//  数据库操作
//
//  Created by cguo on 2017/3/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SQLName @"mySQLdb.sqlite"
@interface PathUtils : NSObject



+(NSString*)dbPath;

+(NSString*)srcPath;

+(void)initDb;

+(BOOL)copyNewDb;

+(BOOL)hasDb;

@end
