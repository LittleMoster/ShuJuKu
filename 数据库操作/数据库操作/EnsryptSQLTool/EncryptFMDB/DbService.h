//
//  DbService.h
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/17.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "FMDB.h"

@interface DbService : NSObject

- (instancetype)initWithPath:(NSString *)path encryptKey:(NSString *)encryptKey;


//数据库中是否存在表
- (BOOL)tableExists:(NSString *)tableName;

//数据库操作语句--查询
-(FMResultSet*)dbexecuteQuery:(NSString*)sql withArgumentsInArray:(NSArray*)arr;

-(FMResultSet*)dbexecuteQuery:(NSString*)sql;

/** query first row and column */
- (id)executeScalar:(NSString *)sql param:(NSArray *)param;

/** row for table */
- (NSInteger)rowCount:(NSString *)tableName;

/** update 数据的增，删，改*/
- (BOOL)executeUpdate:(NSString *)sql param:(NSArray *)param;

- (BOOL)executeUpdate:(NSString *)sql;
/** query table with default construction */
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass;

/** query table with default construction and custom operation */
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass performBlock:(void (^)(id model, FMResultSet *rs))block;


-(BOOL)beginTransaction;

-(BOOL)executeStatements:(NSString*)sql;

-(BOOL)rollback;

-(BOOL)commit;
@end
