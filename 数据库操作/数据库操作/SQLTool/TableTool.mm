//
//  TableTool.m
//  数据库操作
//
//  Created by cguo on 2017/3/22.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "TableTool.h"
#import "FMDB.h"
#import "PathUtils.h"
#import "FileUtils.h"
#import "EncryptUtils.h"
#import "DbService.h"
@interface TableTool ()
{
    FMDatabase *sqldb;
 
}
@property(nonatomic,strong) DbService*service;
@end
@implementation TableTool
static    TableTool *tool;


-(DbService *)service
{
    if (_service==nil) {
        [self makeSqlDB];
        _service=[[DbService alloc]initWithPath:[PathUtils dbPath] encryptKey:EncryKey];
    }
    return _service;
}
-(void)dealloc
{
    [sqldb close];
}
+(BOOL)deleteTableWithName:(NSString*)tableName
{
    BOOL res=NO;
    
    NSString *deleteStr=[NSString stringWithFormat:@"DROP TABLE %@",tableName];
    if ([isEncry isEqualToString:@"YES"]) {
            res=[[[TableTool shared]service ]executeUpdate:deleteStr];
    }else
    {
    
    res=[[[TableTool shared]makeSqlDB]executeUpdate:deleteStr];
    }
    return res;
}
+(BOOL)rePlayTable:(NSString *)newTableName oldTableName:(NSString*)oldTableName
{
    NSString *tableStr=[NSString stringWithFormat:@"alter table %@ rename to %@",oldTableName,newTableName];
    BOOL res=NO;
    if ([isEncry isEqualToString:@"YES"]) {
     
        res=[[[TableTool shared]service]executeUpdate:tableStr];
    }else
    {
        
        res=[[[TableTool shared]makeSqlDB]executeUpdate:tableStr];
    }
    return res;
}
-(FMDatabase *)GetSqldb
{
    if (sqldb==nil) {
        sqldb= [FMDatabase databaseWithPath:[PathUtils dbPath]];
        [sqldb open];
        if ([isEncry isEqualToString:@"YES"]) {
            
            [EncryptUtils encryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
        }else
        {
            [EncryptUtils unEncryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
            
        }
    }
    return sqldb;
}
-(BOOL)MakeNewtableWithtableName:(NSString *)tabelName
{
    NSString *sqlStr=[NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"modelID\" INTEGER PRIMARY KEY AUTOINCREMENT)",tabelName];
    BOOL result=NO;
    if ([isEncry isEqualToString:@"YES"]) {
        result= [[[TableTool shared]service] executeUpdate:sqlStr];
    }else
    {
        result= [[[TableTool shared]makeSqlDB] executeUpdate:sqlStr];
    }
    return result;
}

-(BOOL)MakeNewtable:(NSString *)sqlString
{
    BOOL result=NO;
    if ([isEncry isEqualToString:@"YES"]) {
       result= [[[TableTool shared]service] executeUpdate:sqlString];
    }else
    {
     result= [[[TableTool shared]makeSqlDB] executeUpdate:sqlString];
    }
    return result;
}
+(TableTool *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[TableTool alloc]init];
    });
    return tool;
}
-(FMDatabase*)makeSqlDB
{
    if (sqldb==nil) {
        if ([FileUtils fileIsAtPath:[PathUtils dbPath] ]) {
            sqldb=[[FMDatabase alloc]initWithPath:[PathUtils dbPath]];
            [sqldb open];
            if ([isEncry isEqualToString:@"YES"]) {
                
                [EncryptUtils encryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
            }else
            {
                [EncryptUtils unEncryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
                [EncryptUtils unEncryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
            }
            
        }else
        {
            if ([PathUtils srcPath] ==nil) {
            sqldb=  [FMDatabase databaseWithPath:[PathUtils dbPath]];
                if ([isEncry isEqualToString:@"YES"]) {
                    
                    [EncryptUtils encryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
                }else
                {
                [EncryptUtils unEncryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
                [EncryptUtils unEncryptDatabasePath:[PathUtils dbPath] encryptKey:EncryKey];
                }
//
              
            }else
            {
           
                [PathUtils copyNewDb];
            sqldb=[[FMDatabase alloc]initWithPath:[PathUtils dbPath]];
                
            }
              [sqldb open];
        
        }
     
    }
    return sqldb;
}
//表添加字段
+(BOOL)AddRowWithtableName:(NSString *)tableName WithROWName:(NSString*)rowName withtype:(NSString*)type
{
  
    if ([isEncry isEqualToString:@"YES"]) {
      
        if (![self isHasTableName:tableName InSQLName:SQLName]) {
            [[TableTool shared]MakeNewtableWithtableName:tableName];
          
        }
//            else
//        {
//            if ([self isHasRowinTable:tableName row:@"modelID"]) {
//                [self delegateRowIntable:tableName RoeName:@"modelID"];
//            }
//        }
        
        BOOL beginTrans= [[[TableTool shared]service] beginTransaction];
        BOOL sucess=NO;
        if(beginTrans)
        {
            
            BOOL hasFullPath=NO;
            NSString *executeQuert=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
            FMResultSet *s=[[[TableTool shared]service]dbexecuteQuery:executeQuert];
            while ([s next]) {
                NSString*fieldName=[s stringForColumn:@"name"];
                if([fieldName isEqualToString:rowName])
                {
                    hasFullPath=YES;
                }
                
            }
            [s close];
            
            
            if(!hasFullPath)
            {
                NSString *executeStatements=[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' %@",tableName,rowName,type];
                sucess=[[[TableTool shared]service] executeStatements:executeStatements];
                if(!sucess)
                {
                    [[[TableTool shared]service]rollback];
                
                }
            }
            
            sucess=[[[TableTool shared]service]commit];
            if(!sucess)
            {
                [[[TableTool shared]service]rollback];
                
                
                
            }
            
        }
        else
        {
            NSLog(@"beginTtans出错");
            return sucess;
        }
             return sucess;
    }else
    {
        if (![self isHasTableName:tableName InSQLName:SQLName]) {
            [[TableTool shared]MakeNewtableWithtableName:tableName];
            
        }
//        else
//        {
//            if ([self isHasRowinTable:tableName row:@"modelID"]) {
//                [self delegateRowIntable:tableName RoeName:@"modelID"];
//            }
//
//        }
        
        
    BOOL beginTrans= [[[TableTool shared]makeSqlDB] beginTransaction];
    BOOL sucess=NO;
    if(beginTrans)
    {
        
        BOOL hasFullPath=NO;
        NSString *executeQuert=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        FMResultSet *s=[[[TableTool shared]makeSqlDB] executeQuery:executeQuert];
        while ([s next]) {
            NSString*fieldName=[s stringForColumn:@"name"];
            if([fieldName isEqualToString:rowName])
            {
                hasFullPath=YES;
            }
            
        }
        [s close];
        
        
        if(!hasFullPath)
        {
            NSString *executeStatements=[NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' %@",tableName,rowName,type];
            sucess=[[[TableTool shared]makeSqlDB] executeStatements:executeStatements];
            if(!sucess)
            {
                [[[TableTool shared]makeSqlDB]rollback];
      
               
            }
        }
        
        sucess=[[[TableTool shared]makeSqlDB]commit];
        if(!sucess)
        {
            [[[TableTool shared]makeSqlDB]rollback];
           
            
        
        }
        
    }
             
    return sucess;
    }

}
//判断数据库中是否有该字段名
+(BOOL)isHasRowinTable:(NSString*)tableName row:(NSString*)rowName
{
     if ([isEncry isEqualToString:@"YES"]) {
         
         NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
         FMResultSet *result=[[[TableTool shared]service]dbexecuteQuery:sqlString];
         while ([result next]) {
             
        if ([rowName isEqualToString:result.resultDictionary[@"name"]]) {
            return YES;
             }
         }
         return NO;

     }else
     {
         NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
         FMResultSet *result=[[[TableTool shared]makeSqlDB]executeQuery:sqlString];
         while ([result next]) {
             
             if ([rowName isEqualToString:result.resultDictionary[@"name"]]) {
                 return YES;
             }
         }
         return NO;

     }
}


+(BOOL)delegateRowIntable:(NSString *)tableName RoeName:(NSString *)rowName
{
    if ([isEncry isEqualToString:@"YES"]) {
        NSMutableArray *rowArr=[[NSMutableArray alloc]init];
        NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        FMResultSet *result=[[[TableTool shared]service]dbexecuteQuery:sqlString];
        while ([result next]) {
            
        NSLog(@"%@", result.resultDictionary[@"name"]);
            if (![rowName isEqualToString:result.resultDictionary[@"name"]]) {
                [rowArr addObject:result.resultDictionary[@"name"]];
            }
        }
        if (rowArr.count==0) {
          
                NSLog(@"删除表字段出错");
           
            return NO;
        }
        NSString *str=rowArr[0];
        for (int i=1; i<rowArr.count; i++) {
            NSString *row=[NSString stringWithFormat:@",%@",rowArr[i]];
            str=[str stringByAppendingString:row];
        }
        NSLog(@"%@",str);
        NSString *newtableName=[tableName stringByAppendingString:@"new"];
        NSString *maketableStr=[NSString stringWithFormat:@"create table %@ as select %@ from %@",newtableName,str,tableName];
        BOOL success= [[TableTool shared]MakeNewtable:maketableStr];
        if (success) {
            
            success=[self deleteTableWithName:tableName];
            if (success) {
                success=[self rePlayTable:tableName oldTableName:newtableName];
                
                
            }
            
        }
        if (!success) {
            NSLog(@"删除表字段出错");
        }
        return success;
    }else
    {
        NSMutableArray *rowArr=[[NSMutableArray alloc]init];
        NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        FMResultSet *result=[[[TableTool shared]makeSqlDB]executeQuery:sqlString];
        while ([result next]) {
            
            NSLog(@"%@", result.resultDictionary[@"name"]);
            if (![rowName isEqualToString:result.resultDictionary[@"name"]]) {
                [rowArr addObject:result.resultDictionary[@"name"]];
            }
        }
        if (rowArr.count==0) {
            
            NSLog(@"删除表字段出错");
            
            return NO;
        }
        NSString *str=rowArr[0];
        for (int i=1; i<rowArr.count; i++) {
            NSString *row=[NSString stringWithFormat:@",%@",rowArr[i]];
            str=[str stringByAppendingString:row];
        }
        NSLog(@"%@",str);
        NSString *newTabeName=[tableName stringByAppendingString:@"new"];
        NSString *maketableStr=[NSString stringWithFormat:@"create table %@ as select %@ from %@",newTabeName,str,tableName];
        BOOL success= [[TableTool shared]MakeNewtable:maketableStr];
        if (success) {
            
            success=[self deleteTableWithName:tableName];
            if (success) {
                success=[self rePlayTable:tableName oldTableName:newTabeName];
                
                
            }
            
        }
        if (!success) {
            NSLog(@"删除表字段出错");
        }
        return success;
    }
  
}

//修改表字段
+(BOOL)changeRowIntable:(NSString *)tableName OldRoeName:(NSString *)oldrowName changeRoeName:(NSString *)rowName ChangeRowType:(NSString *)Type
{
    if ([isEncry isEqualToString:@"YES"]) {
       
        
        BOOL success= [self delegateRowIntable:tableName RoeName:oldrowName];
        if (success) {
            success=[self AddRowWithtableName:tableName WithROWName:rowName withtype:Type];
            if (!success) {
                NSLog(@"增加表字段出错");
            }
        }else
        {
            NSLog(@"删除表字段出错");

        }
        

        
    
        return success;
    }
    else
    {
    
    BOOL success= [self delegateRowIntable:tableName RoeName:oldrowName];
    if (success) {
        success=[self AddRowWithtableName:tableName WithROWName:rowName withtype:Type];
    }
    if (!success) {
        NSLog(@"修改表字段出错");
    }
    return success;
    }
    
}

+(FMResultSet*)extecuteQuery:(NSString*)sqlStr
{
    if ([isEncry isEqualToString:@"YES"]) {
        FMResultSet *res=[[[TableTool shared]service]dbexecuteQuery:sqlStr];
        return res;
    }else
    {
        FMResultSet *res=[[[TableTool shared]makeSqlDB]executeQuery:sqlStr];
        return res;
    }
}

+(FMResultSet*)extecuteQuery:(NSString*)sqlStr withArgumentsInArray:(NSArray*)arr
{
    if ([isEncry isEqualToString:@"YES"]) {
        
        FMResultSet *res=nil;
        if (sqlStr !=nil) {
            if (arr.count>0) {
            res =[[[TableTool shared]service]dbexecuteQuery:sqlStr withArgumentsInArray:arr];
            }else
            {
                res=[[[TableTool shared]service]dbexecuteQuery:sqlStr];
            }
            
            
        }
        return res;
        
    }else
    {
        FMResultSet *res=nil;
        if (sqlStr !=nil) {
            if (arr.count>0) {
                res =[[[TableTool shared]makeSqlDB]executeQuery:sqlStr withArgumentsInArray:arr];
            }else
            {
                res=[[[TableTool shared]makeSqlDB]executeQuery:sqlStr];
            }
            
            
        }
        return res;

    }
}

+(BOOL)extecuteUpdate:(NSString*)sqlStr
{
    if([isEncry isEqualToString:@"YES"])
    {
        BOOL isUpdate=[[[TableTool shared]service]executeUpdate:sqlStr];
        return isUpdate;
    }else
    {
        BOOL isupdate= [[[TableTool shared]makeSqlDB]executeUpdate:sqlStr];
        return isupdate;
    }
}



+(BOOL)extecuteUpdate:(NSString*)sqlStr param:(NSArray*)arr
{
    if([isEncry isEqualToString:@"YES"])
    {
        BOOL isUpdate=[[[TableTool shared]service]executeUpdate:sqlStr param:arr];
        return isUpdate;
    }else
    {
       BOOL isupdate= [[[TableTool shared]makeSqlDB]executeUpdate:sqlStr withArgumentsInArray:arr];
       return isupdate;
    }
}

+(NSArray*)getAllTableName:(NSString*)sqlName
{
    if ([isEncry isEqualToString:@"YES"]) {
      NSString *sqlString=[NSString stringWithFormat:@"select * from sqlite_master where type='table' order by name"];
        FMResultSet *result=[[[TableTool shared]service]dbexecuteQuery:sqlString];
        NSMutableArray *tableArr=[NSMutableArray array];
        while ([result next]) {
            
            NSLog(@"%@", result.resultDictionary[@"name"]);
           
                [tableArr addObject:result.resultDictionary[@"name"]];
           
        }
        return tableArr;
        
    }else
    {
        NSString *sqlString=[NSString stringWithFormat:@"select * from sqlite_master where type='table' order by name"];
        FMResultSet *result=[[[TableTool shared]makeSqlDB]executeQuery:sqlString];
        NSMutableArray *tableArr=[NSMutableArray array];
        while ([result next]) {
            
            NSLog(@"%@", result.resultDictionary[@"name"]);
          
                [tableArr addObject:result.resultDictionary[@"name"]];
           
        }
        return tableArr;

        
        
    }
}
+(BOOL)isHasTableName:(NSString *)tableName InSQLName:(NSString *)sqlName
{
    NSArray *tableArr=[self getAllTableName:sqlName];
    for (int i=0; i<tableArr.count; i++) {
        if ([tableArr[i] isEqualToString:tableName]) {
            return YES;
        }
    }
    return NO;
}

//获取表中所以的字段名
+(NSArray*)GetAllRowNameInTableName:(NSString *)tableName
{
    
    NSMutableArray *rowArr=[[NSMutableArray alloc]init];
    if ([isEncry isEqualToString:@"YES"]) {

        NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        FMResultSet *result=[[[TableTool shared]service]dbexecuteQuery:sqlString];
        while ([result next]) {
            
            NSLog(@"%@", result.resultDictionary[@"name"]);
            [rowArr addObject:result.resultDictionary[@"name"]];
        }
    }else
    {
        NSString *sqlString=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        FMResultSet *result=[[[TableTool shared]makeSqlDB]executeQuery:sqlString];
        while ([result next]) {
            
            NSLog(@"%@", result.resultDictionary[@"name"]);
            [rowArr addObject:result.resultDictionary[@"name"]];
    }
    }
        return rowArr;
}

@end
