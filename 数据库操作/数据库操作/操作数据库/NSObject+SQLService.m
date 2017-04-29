//
//  NSObject+SQLService.m
//  数据库操作
//
//  Created by cguo on 2017/4/1.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "NSObject+SQLService.h"
#import <objc/runtime.h>
#import "TableTool.h"
#import "PathUtils.h"
#import "DbService.h"
#import "ProductModel.h"
#import <objc/message.h>
@implementation NSObject (SQLService)


-(BOOL)SaveDateWithModelInSQL
{


    
        NSString *modelname=NSStringFromClass([self class]);
        BOOL success=NO;
        success=  [self GetTableByModel];
    


    
        NSArray *modelarr=[self fetchIvarList:[self class]];
        NSMutableArray *KeyArr=[[NSMutableArray alloc]init];
        NSMutableArray *valueArr=[[NSMutableArray alloc]init];
        for (int i=0; i<modelarr.count; i++) {
            
//            获取模型类中所有的字段名以及其类型
            NSString *type= [self GetTypeName:modelarr[i][@"type"]];
            NSString *valueName=[self GetivarName:modelarr[i][@"ivarName"]];
            if ([type isEqualToString:@"TEXT"]) {
                
     
//            在text前面添加中文，避免出错，由于当保存的字段是NSString类型，并且没有汉字时会报错，所以就在TEXT类型的数据前面默认添加一个汉字。
                NSString* valueStr=[@"家" stringByAppendingString:[self valueForKey:valueName]];
                [valueArr addObject:valueStr];
                [KeyArr addObject:valueName];
            }else
            {
                [valueArr addObject:[self valueForKey:valueName]];
                [KeyArr addObject:valueName];
            }
        }
//    添加数据到数据库表
        NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@",modelname,KeyArr,valueArr];
        
        success= [TableTool extecuteUpdate:sqlStr];

 
    return success;
}
//删除数据库中存储的模型数据
+(BOOL)DeleteModelByTable
{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@",NSStringFromClass([self class])];
    BOOL success= [TableTool extecuteUpdate:sqlStr];
    if (!success) {
        NSLog(@"删除错误");
        
    }
    return success;
}

-(BOOL)DeleteModelByTableWithKey:(id)key
{
    
    
    NSArray *modelArr= [self fetchIvarList:[self class]];
    
    
    NSMutableArray *typeArr=[[NSMutableArray alloc]init];
    NSMutableArray *ivarArr=[[NSMutableArray alloc]init];
    for (int i=0; i<modelArr.count; i++) {
        
        
        NSString *type= [self GetTypeName:modelArr[i][@"type"]];
        NSString *ivarName=[self GetivarName:modelArr[i][@"ivarName"]];
        [typeArr addObject:type];
        [ivarArr addObject:ivarName];
        
        
    }
    //查询数据库表中的所有数据
    NSString *value;
    NSString *sqlStrSearch=[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass([self class])];
        FMResultSet *s=[TableTool extecuteQuery:sqlStrSearch];
    while ([s next]) {
        for (int i=0; i<ivarArr.count; i++) {
            if ([typeArr[i] isEqualToString:@"TEXT"]) {
                 value=[[self UnicodeToutf:s.resultDictionary[ivarArr[i]]] substringFromIndex:1];
            }else
            {
                value=s.resultDictionary[ivarArr[i]];
            }
            if ([key isEqualToString:value]) {
                //删除数据库中符合要求的数据
                NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where %@=?",NSStringFromClass([self class]),ivarArr[i]];
                BOOL success= [TableTool extecuteUpdate:sqlStr param:@[s.resultDictionary[ivarArr[i]]]];
                return success;
            }
        }
        
    }
    return YES;
    
}

+(NSMutableArray*)GetModelArrByTable
{
    return  [self GetModelArrByTableWithId:nil];
    
}
+(NSMutableArray*)GetModelArrByTableWithId:(id)ID
{
    NSMutableArray*arrM=[[NSMutableArray alloc]init];
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass([self class])];
    FMResultSet *s=[TableTool extecuteQuery:sqlStr];
    while ([s next]) {
        
      
        if ([self GetModelByResultSet:s WithId:ID]!=nil) {
            //判断返回的模型是否为空，不为空就添加到模型数组中
            [arrM addObject:[self GetModelByResultSet:s WithId:ID]];

        }
        
    
        
    }
    return arrM;
    
    
}

//更新-改变数据库保存的模型
-(BOOL)ChangeModelInTable:(id)key
{
    BOOL success=NO;
    if (key==nil) {
        return success;
    }
       success=  [self DeleteModelByTableWithKey:key];
    if (success) {
        success=  [self SaveDateWithModelInSQL];
    }
    
    return success;
}
//查询数据，根据指定的条件数组去查询
+(NSMutableArray*)GetModelArrByTableWithArr:(NSArray*)arr
{
    NSMutableArray *modelArr=[[NSMutableArray alloc]init];
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    NSMutableArray *ivarNameArr=[[NSMutableArray alloc]init];
    BOOL success;
    if (arr.count==0) {
        return resultArr;
    }
   
        if (arr.count==1) {
           resultArr=[self GetModelArrByTableWithId:arr[0]];
        }else
        {
            for (int i=0; i<arr.count; i++) {
                if (i==0) {
                    modelArr=[self GetModelArrByTableWithId:arr[i]];
                }else
                {
                for (int j=0; j<modelArr.count;j++) {
//                    NSDictionary *dicValue=modelArr[j];
                    success=NO;
                    NSArray * getModelArr=[self fetchIvarList:[modelArr[j] class]];
                    for (int i=0; i<getModelArr.count; i++) {
                        NSString *ivarName=[self GetivarName: getModelArr[i][@"ivarName"]];
                        [ivarNameArr addObject:ivarName];
                    }
                   
                    for (int k=0; k<ivarNameArr.count; k++) {
                       NSString *valueName= [modelArr[j] valueForKey:ivarNameArr[k]];
                        if ([arr[i]isEqualToString:valueName]) {
//
                            success=YES;
                        }
                       
                    }
                    if (!success) {
                        [modelArr removeObjectAtIndex:j];
                    }
                    
                }
                }
                if (i==arr.count-1) {
                    return modelArr;
                }
            }
        }
    return resultArr;
}

+(id)GetModelByResultSet:(FMResultSet*)s WithId:(id)Id
{
   
    NSString *IdStr=[NSString stringWithFormat:@"%@",Id];
    NSArray *modelArr= [self fetchIvarList:[self class]];
    
  
    NSMutableArray *typeArr=[[NSMutableArray alloc]init];
    NSMutableArray *ivarArr=[[NSMutableArray alloc]init];
    for (int i=0; i<modelArr.count; i++) {
        
        
        NSString *type= [self GetTypeName:modelArr[i][@"type"]];
        NSString *ivarName=[self GetivarName:modelArr[i][@"ivarName"]];
        [typeArr addObject:type];
        [ivarArr addObject:ivarName];
        
        
    }
    NSString *className=NSStringFromClass([self class]);
    id model= objc_msgSend(objc_msgSend(objc_getClass([className  UTF8String]), sel_registerName("alloc")), sel_registerName("init"));
    
    for (int i=0; i<ivarArr.count; i++) {
       

            if (Id==nil) {
                if ([typeArr[i] isEqualToString:@"TEXT"]) {
                    NSString *valueName=[s.resultDictionary[ivarArr[i]] substringFromIndex:1];
                    [model setValue:valueName forKey:ivarArr[i]];

                }else
                {
                [model setValue:s.resultDictionary[ivarArr[i]] forKey:ivarArr[i]];
                }
                if(i==ivarArr.count-1)
                {
                    return model;
                }

            }else
            {
                if ([Id isKindOfClass:[NSString class]]) {
                    NSString *valueName=[NSString stringWithFormat:@"%@", s.resultDictionary[ivarArr[i]]];
                    valueName=[[self replaceUnicode:valueName] substringFromIndex:1];
                    if ([Id isEqualToString:valueName]) {
                        for (int j=0; j<ivarArr.count; j++) {
                            
                            if ([typeArr[j] isEqualToString:@"TEXT"]) {
                                  NSString * valueName=[self replaceUnicode:s.resultDictionary[ivarArr[j]]];
                               valueName=[valueName substringFromIndex:1];
                              
                                [model setValue:valueName forKey:ivarArr[j]];
                                
                            }else
                            {
                                [model setValue:s.resultDictionary[ivarArr[j]] forKey:ivarArr[j]];
                            }
                            if(j==ivarArr.count-1)
                            {
                            return model;
                          }
                        }
//                        [model setValue:s.resultDictionary[ivarArr[i]] forKey:ivarArr[i]];
//
                    }

                }else
                {
                    NSString *resultStr=[NSString stringWithFormat:@"%@",s.resultDictionary[ivarArr[i]]];
                    if ([IdStr isEqualToString:resultStr]) {
                        for (int j=0; j<ivarArr.count; j++) {
                            
                            if ([typeArr[j] isEqualToString:@"TEXT"]) {
                                NSString *valueName=[s.resultDictionary[ivarArr[j]] substringFromIndex:1];
                                [model setValue:valueName forKey:ivarArr[j]];
                                
                            }else
                            {
                                [model setValue:s.resultDictionary[ivarArr[j]] forKey:ivarArr[i]];
                            }
                            if(j==ivarArr.count-1)
                            {
                                return model;
                            }
                        }
                    }

                }
            }
          
       
    }
    
   
    return nil;

}


+(id)GetModelByTableWithId:(id)ID
{
    if ([self GetModelArrByTableWithId:ID].count==0) {
        NSLog(@"%@模型类为空", NSStringFromClass([self class]));

        return nil;
    }
    return [self GetModelArrByTableWithId:ID].firstObject;
}
+(id)GetModelByTable
{
    if ([self GetModelArrByTableWithId:nil].count==0) {
        NSLog(@"%@模型类为空", NSStringFromClass([self class]));
       
        return nil;
    }
        return [self GetModelArrByTableWithId:nil].firstObject;
}

-(BOOL)GetTableByModel
{
    
    NSString *name=NSStringFromClass([self class]);
    BOOL success=NO;
        NSString *key = @"CFBundleShortVersionString";
        // 获得当前软件的版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        // 获得沙盒中存储的版本号
        NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
        if (![currentVersion isEqualToString:sanboxVersion]) {
            if ([TableTool isHasTableName:modelname InSQLName:SQLName]) {
                success=[TableTool deleteTableWithName:modelname];
            }
            if (!success) {
                NSLog(@"删除表失败，更新model字段出错");
            }
            // 存储版本号
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //判断是否有这个模型的表。有就删除表
    if ([TableTool isHasTableName:name InSQLName:SQLName])
    {
        [TableTool deleteTableWithName:name];
    }
    //判断是否有这个模型的表。没有就创建表
    
    if (![TableTool isHasTableName:name InSQLName:SQLName]) {
        //没有表就根据模型id创建表，在后面再删除该字段
        success=[[TableTool shared]MakeNewtableWithtableName:name];
        if (success) {
            NSArray *modelArr= [self fetchIvarList:[self class]];
            
            NSLog(@"%@",modelArr);
            NSMutableArray *typeArr=[[NSMutableArray alloc]init];
            NSMutableArray *ivarArr=[[NSMutableArray alloc]init];
            for (int i=0; i<modelArr.count; i++) {
                
                
                NSString *type= [self GetTypeName:modelArr[i][@"type"]];
                NSString *ivarName=[self GetivarName:modelArr[i][@"ivarName"]];
                [typeArr addObject:type];
                [ivarArr addObject:ivarName];
                
            }
            
          
            for (int i=0; i<ivarArr.count; i++) {
                success= [TableTool AddRowWithtableName:NSStringFromClass([self class]) WithROWName:ivarArr[i] withtype:typeArr[i] ];
                if (!success) {
                    return success;
                }
            }
            
        }
        if (success) {
            [TableTool delegateRowIntable:NSStringFromClass([self class]) RoeName:@"modelID"];
            
        }

    }
 
      return success;
  }



-(NSString*)GetivarName:(NSString*)name
{
    if ([name hasPrefix:@"_"]) {
        return [name stringByReplacingOccurrencesOfString:@"_"withString:@""];

    }else
    {
        return name;
    }
    
}

-(NSString *)GetTableRowType:(NSString*)type
{
    NSString *rowType=[self GetTypeName:type];
    if ([rowType isEqualToString:@"INTEGER"]) {
        return @"hehe";
    }
     return @"hehe";
}

-(NSString*)GetTypeName:(NSString*)type
{
    
    if ([type isEqualToString:@"i"]) {
        return @"INTEGER";
    }
    if ([type isEqualToString:@"f"]) {
            return @"FLOAT";
    }
    if ([type isEqualToString:@"d"]) {
            return @"REAL";
    }
    if ([type isEqualToString:@"s"]) {
         return @"SMALLINT";
    }
    if ([type isEqualToString:@"l"]) {
         return @"REAL";
    }
    if ([type isEqualToString:@"q"]) {
         return @"REAL";
    }
    if ([type isEqualToString:@"c"]) {
        return @"VARCHAR";
    }
    if ([type isEqualToString:@"b"]) {
        return @"BOOLEAN";
    }
    if ([type isEqualToString:@"@\"NSString\""]) {
        return @"TEXT";
    }else
    {
        return @"REAL";
    }
}

- (NSArray *)fetchIvarList:(Class)class {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dic[@"type"] = [NSString stringWithUTF8String: ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String: ivarName];
        
        [mutableList addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

//Unicode转UTF-8
-(NSString*) UnicodeToutf:(NSString*)aUnicodeString

{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                           mutabilityOption:NSPropertyListImmutable
                           
                                                                     format:NULL
                           
                                                           errorDescription:NULL];
    
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
}

//Unicode转UTF-8
+ (NSString*) replaceUnicode:(NSString*)aUnicodeString

{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                           mutabilityOption:NSPropertyListImmutable
                           
                                                                     format:NULL
                           
                                                           errorDescription:NULL];
    
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
}
//utf-8转Unicode
-(NSString *)utf8ToUnicode:(NSString *)string
{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >= '0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
        }
        
        else if(_char >= 'a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else if(_char >= 'A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else
            
        {
            
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            
        }
        
    }
    
    return s;
    
}


@end
