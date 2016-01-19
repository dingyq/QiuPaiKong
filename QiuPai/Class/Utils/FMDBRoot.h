//
//  FMDBRoot.h
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBRoot : NSObject

+ (instancetype)getInstance;

//+ (id)modelWithDBName:(NSString *)dbName;
//- (id)initWithDBName:(NSString *)dbName;

// 生成插入表sql
- (NSString *)getInsertDataSql:(NSString *)tableName tableColumnDic:(NSDictionary *)tableColumn;

// 删除数据库
- (void)deleteDatabse;

// 数据库存储路径
//- (NSString *)getPath:(NSString *)dbName;
// 打开数据库
//- (void)readyDatabse;

// 判断是否存在表
- (BOOL)isTableExist:(NSString *)tableName;
// 获得表的数据条数
- (BOOL)getTableItemCount:(NSString *)tableName;
// 创建表
- (BOOL)createTable:(NSString *)tableName withArguments:(NSString *)arguments;
- (BOOL)createTable:(NSString *)tableName withTableColumnDic:(NSDictionary *)tableColumn;

// 删除表-彻底删除表
- (BOOL) deleteTable:(NSString *)tableName;
// 清除表-清数据
- (BOOL) eraseTable:(NSString *)tableName;
// 查询数据
- (NSMutableArray *)queryTable:(NSString *)tableName;
- (NSMutableArray *)queryTable:(NSString *)tableName withDic:(NSDictionary *)dic;
- (NSMutableArray *)queryTableWithSelfDefineSql:(NSString *)sql;

// 增加数据
- (BOOL)insertTable:(NSString*)sql withDic:(NSDictionary *)argsDic;
- (BOOL)insertTable:(NSString*)sql withArr:(NSMutableArray *)argsArr;
- (BOOL)insertTable:(NSString*)tableName withTableColumnDic:(NSDictionary *)tableColumnDic
  withColumnTypeDic:(NSDictionary *)columeType withValueDic:(NSDictionary *)valueDic;

// 修改数据
- (BOOL)updateRecordOfTable:(NSString *)tableName withArguments:(NSDictionary *)valueArgsDic mainKey:(NSString *)majorKey;

// 删除数据
- (BOOL)deleteRecordOfTable:(NSString *)tableName key:(NSString *)key value:(NSInteger)value;
//- (BOOL)deleteRecordOfTable:(NSString *)tableName;
// 多线程处理
- (void)multiThread:(NSString *)sql withArgumentsInArray:(NSArray *)arr;

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName;


@end
