//
//  PathUtils.m
//  数据库操作
//
//  Created by cguo on 2017/3/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "PathUtils.h"
#import "FileUtils.h"



@implementation PathUtils


+(NSString *)dbPath
{
    NSArray*paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@/%@",paths[0],SQLName);

    return [NSString stringWithFormat:@"%@/%@",paths[0],SQLName];
}

+(NSString*)srcPath
{
    NSRange tsr=[SQLName rangeOfString:@"."];
    NSString *sqlname=[SQLName substringToIndex:tsr.location];
    NSString *sqltype=[SQLName substringFromIndex:tsr.location+1];
    return [[NSBundle mainBundle]pathForResource:sqlname ofType:sqltype];
}

+(BOOL)copyNewDb
{
//    if ([self srcPath] ==nil) {
//        
//        return NO;
//        
//    }else
//    {
    return  [FileUtils copyItemAtPath:[self srcPath] toPath:[self dbPath]];
//    }
}

+(void)initDb
{
    if(![FileUtils fileIsAtPath:[self dbPath]])
    {
        [FileUtils copyItemAtPath:[self srcPath] toPath:[self dbPath]];
    }
}

+(BOOL)hasDb
{
    return [FileUtils fileIsAtPath:[self dbPath]];
}

@end
