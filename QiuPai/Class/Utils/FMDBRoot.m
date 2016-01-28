//
//  FMDBRoot.m
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "FMDBRoot.h"

@interface FMDBRoot() {
    FMDatabase *fmdb;
    NSInteger _openRC;
    NSString *dbPath;
}

@end

@implementation FMDBRoot


+ (instancetype)getInstance {
    static FMDBRoot *shareInstance;
    
    @synchronized(self) {
        if (shareInstance == nil) {
            shareInstance=[[FMDBRoot alloc] init];
        }
    }
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"QiuPaiInfo.sqlite"];
    _openRC = 0;
    return self;
}

- (NSString *)getCreateTableSqlArguments:(NSDictionary *)tableColumn {
    NSArray *keys = [tableColumn allKeys];
    NSMutableString *arguments = [NSMutableString stringWithString:@"'id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,"];
    for (NSString *key in keys) {
        [arguments appendString:[NSString stringWithFormat:@"'%@' %@, ", key, [tableColumn objectForKey:key]]];
    }
    [arguments deleteCharactersInRange:NSMakeRange([arguments length]-2, 2)];
    return arguments;
}

- (NSString *)getInsertDataSql:(NSString *)tableName tableColumnDic:(NSDictionary *)tableColumn {
    NSArray *keys = [tableColumn allKeys];
    NSMutableString *columnList = [NSMutableString stringWithString:@""];
    NSMutableString *valueList = [NSMutableString stringWithString:@""];
    for (NSString *key in keys) {
        [columnList appendString:[NSString stringWithFormat:@"%@, ", key]];
        //        [valueList appendString:@"?, "];
        [valueList appendString:[NSString stringWithFormat:@":%@, ", key]];
    }
    [columnList deleteCharactersInRange:NSMakeRange([columnList length]-2, 2)];
    [valueList deleteCharactersInRange:NSMakeRange([valueList length]-2, 2)];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, columnList, valueList];
    return sql;
}

- (void)closeDatabase {
    _openRC -- ;
    if (_openRC <= 0) {
        [fmdb close];
    }
}

// 打开数据库
- (void)readyDatabase {
//    BOOL success;
    //NSError *error;
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    success = [fileManager fileExistsAtPath:dbPath];
//    if (!success)
//        return;
    fmdb = [FMDatabase databaseWithPath:dbPath];
//    fmdb = [[FMDatabase alloc] initWithPath:dbPath];

    if (![fmdb open]) {
        [fmdb close];
        NSAssert1(0, @"Failed to open database file with message '%@'.", [fmdb lastErrorMessage]);
    } else {
        _openRC++;
    }
    // kind of experimentalish.
    [fmdb setShouldCacheStatements:YES];
}

#pragma mark 删除数据库
// 删除数据库
- (void)deleteDatabse {
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // delete the old db.
    if ([fileManager fileExistsAtPath:dbPath]) {
        [self closeDatabase];
        success = [fileManager removeItemAtPath:dbPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

// 判断是否存在表
- (BOOL) isTableExist:(NSString *)tableName {
    [self readyDatabase];
    FMResultSet *rs = [fmdb executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        [self closeDatabase];
        if (0 == count) {
            return NO;
        } else {
            return YES;
        }
    }
    [self closeDatabase];
    return NO;
}

// 创建表
- (BOOL)createTable:(NSString *)tableName withTableColumnDic:(NSDictionary *)tableColumn {
    NSString *arguments = [self getCreateTableSqlArguments:tableColumn];
    [self readyDatabase];
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![fmdb executeUpdate:sqlstr]) {
        //if ([fmdb executeUpdate:@"create table user (name text, pass text)"] == nil)
        NSLog(@"Create fmdb error!");
        return NO;
    }
    [self closeDatabase];
    return YES;
}

// 创建表
- (BOOL)createTable:(NSString *)tableName withArguments:(NSString *)arguments {
    [self readyDatabase];
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![fmdb executeUpdate:sqlstr]) {
        //if ([fmdb executeUpdate:@"create table user (name text, pass text)"] == nil)
        NSLog(@"Create fmdb error!");
        return NO;
    }
    [self closeDatabase];
    return YES;
}

// 删除表
- (BOOL)deleteTable:(NSString *)tableName {
    [self readyDatabase];
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![fmdb executeUpdate:sqlstr]) {
        NSLog(@"Delete table error!");
        return NO;
    }
    [self closeDatabase];
    return YES;
}

// 清除表
- (BOOL)eraseTable:(NSString *)tableName {
    [self readyDatabase];
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![fmdb executeUpdate:sqlstr]) {
        NSLog(@"Erase table error!");
        return NO;
    }
    [self closeDatabase];
    return YES;
}

// 获得表的数据条数
- (BOOL)getTableItemCount:(NSString *)tableName {
    [self readyDatabase];
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *rs = [fmdb executeQuery:sqlstr];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"TableItemCount %ld", (long)count);
        return count;
    }
    [self closeDatabase];
    return 0;
}



- (NSMutableArray *)queryTable:(NSString *)tableName withDic:(NSDictionary *)dic {
    [self readyDatabase];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSArray *keys = [dic allKeys];
    NSString *keyStr = [keys objectAtIndex:0];
    NSString *value = [dic objectForKey:keyStr];
    FMResultSet *rs = 0x00;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = %@", tableName, keyStr, value];
    rs = [fmdb executeQuery:sql];
    while ([rs next]) {
        [tmpArr addObject:[rs resultDictionary]];
    }
    [self closeDatabase];
    
    return tmpArr;
}

- (NSMutableArray *)queryTableWithSelfDefineSql:(NSString *)sql {
    [self readyDatabase];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = 0x00;
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by num(字段名) desc", tableName];
    rs = [fmdb executeQuery:sql];
    while ([rs next]) {
        [tmpArr addObject:[rs resultDictionary]];
    }
    [self closeDatabase];
    
    // 输出查询结果
    for (NSDictionary *dic in tmpArr) {
        NSMutableString *tmpStr = [NSMutableString stringWithString:@""];
        NSArray *keyArr = [dic allKeys];
        for (NSString *key in keyArr) {
            //            NSString *string = NSStringFromClass([[dic objectForKey:key] superclass]);
            //            id tmpObj = NSClassFromString(string);
            id tmpObj;
            tmpObj = [dic objectForKey:key];
            [tmpStr appendString:[NSString stringWithFormat:@"%@ = %@, ", key, tmpObj]];
        }
        //        NSLog(@"%@", tmpStr);
    }
    
    return tmpArr;
}

// 查询数据
- (NSMutableArray *)queryTable:(NSString *)tableName {
    [self readyDatabase];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = 0x00;
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    rs = [fmdb executeQuery:sql];
    while ([rs next]) {
        [tmpArr addObject:[rs resultDictionary]];
    }
    [self closeDatabase];
    
    // 输出查询结果
    for (NSDictionary *dic in tmpArr) {
        NSMutableString *tmpStr = [NSMutableString stringWithString:@""];
        NSArray *keyArr = [dic allKeys];
        for (NSString *key in keyArr) {
//            NSString *string = NSStringFromClass([[dic objectForKey:key] superclass]);
//            id tmpObj = NSClassFromString(string);
            id tmpObj;
            tmpObj = [dic objectForKey:key];
            [tmpStr appendString:[NSString stringWithFormat:@"%@ = %@, ", key, tmpObj]];
        }
        //        NSLog(@"%@", tmpStr);
    }
    
    return tmpArr;
}

// 插入数据
- (BOOL)insertTable:(NSString*)tableName withTableColumnDic:(NSDictionary *)tableColumnDic
     withColumnTypeDic:(NSDictionary *)columeType withValueDic:(NSDictionary *)valueDic {
    if (![self isTableExist:tableName]) {
        [self createTable:tableName withTableColumnDic:tableColumnDic];
    }
    [self readyDatabase];
    
    NSString * sql = [self getInsertDataSql:tableName tableColumnDic:tableColumnDic];
    
    NSMutableDictionary *argsDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *argsArr = [[NSMutableArray alloc] init];
    
    // 字段补齐
    NSArray *typeKeyArr = [columeType allKeys];
    for (NSString *key in typeKeyArr) {
//        id tmpObj = NSClassFromString([columeType objectForKey:key]);
        id tmpObj;
        tmpObj = [valueDic objectForKey:key];
        if (tmpObj == nil) {
            if ([[columeType objectForKey:key] isEqualToString:@"NSString"]) {
                tmpObj = @"";
            } else {
                tmpObj = [NSNumber numberWithInt:1];
            }
        }
        [argsDic setObject:tmpObj forKey:key];
        [argsArr addObject:tmpObj];
    }
    
    BOOL result = [fmdb executeUpdate:sql withArgumentsInArray:argsArr];
    [self closeDatabase];
    return result;
}

- (BOOL)insertTable:(NSString*)sql withDic:(NSDictionary *)argsDic {
    [self readyDatabase];
    BOOL result = [fmdb executeUpdate:sql withParameterDictionary:argsDic];
    [self closeDatabase];
    return result;
}

- (BOOL)insertTable:(NSString*)sql withArr:(NSMutableArray *)argsArr {
    [self readyDatabase];
    BOOL result = [fmdb executeUpdate:sql withArgumentsInArray:argsArr];
    [self closeDatabase];
    return result;
}

// 修改数据
//- (BOOL)updateTable:(NSString*)sql, ... {
//    [self readyDatabase];
//    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
//    va_list arguments;
//    va_start(arguments, sql);
//    id eachObj;
//    while ((eachObj = va_arg(arguments, id))) {
//        [tmpArr addObject:eachObj];
//    }
//    BOOL result = [fmdb executeUpdate:sql withArgumentsInArray:tmpArr];
//    [self closeDatabase];
//    va_end(arguments);
//    return result;
//}

- (BOOL)updateRecordOfTable:(NSString *)tableName withArguments:(NSDictionary *)valueArgsDic mainKey:(NSString *)majorKey {
    NSString *headStr = [NSString stringWithFormat:@"UPDATE %@ SET ", tableName];
    NSMutableString * sqlStr = [[NSMutableString alloc] initWithString:headStr];
    NSArray *keys = [valueArgsDic allKeys];
    for (int i = 0; i < [keys count]; i ++) {
        NSString *keyStr = [keys objectAtIndex:i];
        [sqlStr appendString:[NSString stringWithFormat:@"%@ = '%@', ", keyStr, [valueArgsDic objectForKey:keyStr]]];
    }
    [sqlStr deleteCharactersInRange:NSMakeRange(sqlStr.length - 2, 2)];
    [sqlStr appendString:[NSString stringWithFormat:@" WHERE %@ = '%@'", majorKey, [valueArgsDic objectForKey:majorKey]]];

    [self readyDatabase];
    if (![fmdb executeUpdate:sqlStr]) {
        NSLog(@"update data error!");
        [self closeDatabase];
        return NO;
    }
    [self closeDatabase];
    return YES;
}

// 删除数据
- (BOOL)deleteRecordOfTable:(NSString *)tableName key:(NSString *)key value:(NSInteger)value {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%ld'", tableName, key, (long)value];
    [self readyDatabase];
    if (![fmdb executeUpdate:sql]) {
        NSLog(@"delete data error!");
        [self closeDatabase];
        return NO;
    }
    [self closeDatabase];
    return YES;
}

- (void)multiThread:(NSString *)sql withArgumentsInArray:(NSArray *)arr {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    NSUInteger arrLen = [arr count];
    dispatch_async(q1, ^{
        for (NSUInteger i = 0; i < arrLen/2; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                BOOL res = [db executeUpdate:sql withArgumentsInArray:[arr objectAtIndex:i]];
                if (!res) {
                    NSLog(@"error to add db data");
                } else {
                    NSLog(@"succ to add db data 1");
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (NSUInteger j = arrLen/2; j < arrLen; j++) {
            [queue inDatabase:^(FMDatabase *db) {
                BOOL res = [db executeUpdate:sql withArgumentsInArray:[arr objectAtIndex:j]];
                if (!res) {
                    NSLog(@"error to add db data");
                } else {
                    NSLog(@"succ to add db data 2");
                }
            }];
        }
    });
}



// 暂时无用
#pragma mark 获得单一数据

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName {
    [self readyDatabase];
    NSInteger result = NO;
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [fmdb executeQuery:sql];
    if ([rs next])
        result = [rs intForColumnIndex:0];
    [rs close];
    [self closeDatabase];
    return result;
}

// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName {
    BOOL result;
    result = [self getDb_Integerdata:tableName withFieldName:fieldName];
    return result;
}

// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName {
    [self readyDatabase];
    NSString *result = @"";
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [fmdb executeQuery:sql];
    if ([rs next])
        result = [rs stringForColumnIndex:0];
    [rs close];
    [self closeDatabase];
    return result;
}

// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName {
    [self readyDatabase];
    NSData *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [fmdb executeQuery:sql];
    if ([rs next])
        result = [rs dataForColumnIndex:0];
    [rs close];
    [self closeDatabase];
    return result;
}

@end
