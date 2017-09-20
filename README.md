# ShuJuKu

#项目下载地址  https://github.com/LittleMoster/ShuJuKu

#使用教程：
#1.把该项目中的SQLTool、EncryptTool、EncryptSQL三个文件夹拖到自己的项目中；
#2.使用cocoapod安装加密数据库框架   --- pod 'FMDB/SQLCipher'
#3.在SQLTool/TableTool.h中，修改以下字段：isEncry(NOs是指数据库不加密、YES是指数据库加密)


#使用的一些相关的方法

###//通过模型创建数据库表--这个方法没多大的作用,下面的方法包含改功能
-(BOOL)GetTableByModel;
###//模型类调用这个方法，然后把数据保存到数据库中,已模型的类名为表名字，没有表会自动创建；
-(BOOL)SaveDateWithModelInSQL;
###//通过数据库表创建模型数组
+(NSMutableArray*)GetAllModelArrByTable;
###//根据条件查找数据库并返回符合条件的模型数组
+(NSMutableArray*)GetModelArrByTableWithId:(id)ID;
###//根据条件查找数据库并返回符合条件的模型数组
+(NSMutableArray*)GetModelArrByTableWithArr:(NSArray*)arr;
###//和上面的方法一样，只不过返回的是模型而不是模型数组，当查询的结果有多条时，返回第一条数据。
###+(id)GetModelByTable;
###+(id)GetModelByTableWithId:(id)ID;
+(id)GetModelByTableWithArr:(NSArray *)arr;
###//删除数据库中存储的模型数据
-(BOOL)DeleteModelByTable;
###//删除数据库中存储的所有模型数据
+(BOOL)DeleteAllModelByTable;
###//删除符合条件的模型数据
###-(BOOL)DeleteModelByTableWithKey:(id)key;
###-(BOOL)DeleteModelByTableWithArr:(NSArray*)arr;

###//更新-改模型数据---把数据库中存在key的模型数据删除，然后把调用该方法的模型数据保存到数据库
-(BOOL)ChangeModelInTableWithKey:(id)key;
###//更新-改模型数据---传入查询的条件数组把数据库中存在的模型数据删除，然后把调用该方法的模型数据保存到数据库
###-(BOOL)ChangeModelInTableWithArray:(NSArray *)arr;

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

