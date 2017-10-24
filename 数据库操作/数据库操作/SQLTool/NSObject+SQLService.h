//
//  NSObject+SQLService.h
//  数据库操作
//
//  Created by cguo on 2017/4/1.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SQLService)

//通过模型创建数据库表--这个方法没多大的作用,下面的方法包含改功能
-(BOOL)GetTableByModel;
//模型类调用这个方法，然后把数据保存到数据库中,已模型的类名为表名字，没有表会自动创建；
-(BOOL)SaveDateWithModelInSQL;
//通过数据库表创建模型数组
+(NSMutableArray*)GetAllModelArrByTable;
//根据条件查找数据库并返回符合条件的模型数组
+(NSMutableArray*)GetModelArrByTableWithId:(id)ID;
//根据条件查找数据库并返回符合条件的模型数组
+(NSMutableArray*)GetModelArrByTableWithArr:(NSArray*)arr;
//和上面的方法一样，只不过返回的是模型而不是模型数组，当查询的结果有多条时，返回第一条数据。
+(instancetype)GetModelByTable;
+(instancetype)GetModelByTableWithId:(id)ID;
+(instancetype)GetModelByTableWithArr:(NSArray *)arr;
//删除数据库中存储的模型数据
-(BOOL)DeleteModelByTable;
//删除数据库中存储的所有模型数据
+(BOOL)DeleteAllModelByTable;
//删除符合条件的模型数据
-(BOOL)DeleteModelByTableWithKey:(id)key;
-(BOOL)DeleteModelByTableWithArr:(NSArray*)arr;

//更新-改模型数据---把数据库中存在key的模型数据删除，然后把调用该方法的模型数据保存到数据库
-(BOOL)ChangeModelInTableWithKey:(id)key;
//更新-改模型数据---传入查询的条件数组把数据库中存在的模型数据删除，然后把调用该方法的模型数据保存到数据库
-(BOOL)ChangeModelInTableWithArray:(NSArray *)arr;
@end
