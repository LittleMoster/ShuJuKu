//
//  TableTool.h
//  数据库操作
//
//  Created by cguo on 2017/3/22.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#define isEncry @"NO"  //YES代表加密--NO代表不加密
#define EncryKey @"123456abc"  //加密的key


/*
 数据库语句
 @"ALTER TABLE 'o_I_Service' ADD 'Costs_B' REAL"-------增加表字段
 @"ALTER TABLE 'o_I_Service' DROP COLUMN 'Costs_B'"----删除表字段
 @"DROP FROM shopCar"   -----删除表
 @""         --增加表
 */

@interface TableTool : NSObject


//单例模式
+(TableTool*)shared;
//创建数据库
-(FMDatabase *)GetSqldb;
//从本地拷贝数据库--需要本地的资源文件上有这个数据库文件
-(FMDatabase *)makeSqlDB;
//-(FMDatabase*)initSqlDB;
//创建表--这个创建表是指通过模型创建表
-(BOOL)MakeNewtableWithtableName:(NSString *)tabelName;

//增加表
-(BOOL)MakeNewtable:(NSString *)sqlString;
//删除表
+(BOOL)deleteTableWithName:(NSString*)tableName;
//表增加字段
+(BOOL)AddRowWithtableName:(NSString *)tableName WithROWName:(NSString*)rowName withtype:(NSString*)type;
//表删除字段
+(BOOL)delegateRowIntable:(NSString*)tableName RoeName:(NSString *)rowName;
//修改表字段
/*
 tablename--表名
 oldrowName --原来的表字段名
 rowName --修改的字段名（如果不需要修改就写一样）
 Type-修改的字段类型--不需要修改就写原来的
 */
+(BOOL)changeRowIntable:(NSString *)tableName OldRoeName:(NSString *)oldrowName changeRoeName:(NSString *)rowName ChangeRowType:(NSString *)Type;
+(NSArray*)GetAllRowNameInTableName:(NSString *)tableName;


//重命名数据库
+(BOOL)rePlayTable:(NSString *)newTableName oldTableName:(NSString*)oldTableName;

//数据库操作语句
+(FMResultSet*)extecuteQuery:(NSString*)sqlStr withArgumentsInArray:(NSArray*)arr;
+(FMResultSet*)extecuteQuery:(NSString*)sqlStr;

//更新数据库-增、删、改
+(BOOL)extecuteUpdate:(NSString*)sqlStr param:(NSArray*)arr;

+(BOOL)extecuteUpdate:(NSString*)sqlStr;
//获取所有表名
+(NSArray*)getAllTableName:(NSString*)sqlName;
//是否存在这个表
+(BOOL)isHasTableName:(NSString *)tableName InSQLName:(NSString *)sqlName;


@end
