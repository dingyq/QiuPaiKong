//
//  RacketCollectionDB.m
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "RacketCollectionDB.h"
#import "FMDBRoot.h"

@interface RacketCollectionDB(){
    NSString *_tableName;
    NSString *_primaryKey;
    NSDictionary *_tableColumn;
    NSDictionary *_columnType;
}

- (instancetype)init;
@end

@implementation RacketCollectionDB

+ (instancetype)getInstance {
    static RacketCollectionDB *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
        [shareInstance createTable];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BestSelectDB" ofType:@"plist"];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _primaryKey = [configDic objectForKey:@"PrimaryKey"];
    _tableName = [configDic objectForKey:@"TableName"];
    _tableColumn = [configDic objectForKey:@"DBType"];
    _columnType = [configDic objectForKey:@"OCType"];
    return self;
}

// 全删
- (void)clearAllDataOfTable {
    [[FMDBRoot getInstance] eraseTable:_tableName];
}

// 增
- (void)insertDataToTable:(NSDictionary *)valueDic {
    [[FMDBRoot getInstance] insertTable:_tableName withTableColumnDic:_tableColumn withColumnTypeDic:_columnType withValueDic:valueDic];
}

// 删
- (void)deleteDataOfTable:(NSDictionary *)valueDic {
    [[FMDBRoot getInstance] deleteRecordOfTable:_tableName key:_primaryKey value:[[valueDic objectForKey:_primaryKey] integerValue]];
}

// 改
- (void)updateDataOfTable:(NSDictionary *)valueDic mainKey:(NSString *)majorKey {
    [[FMDBRoot getInstance] updateRecordOfTable:_tableName withArguments:valueDic mainKey:majorKey];
}

// 查
- (NSMutableArray *)getLatestDataFromDB:(NSInteger)maxSortId {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where sortId < %ld order by sortId desc LIMIT %ld", _tableName, (long)maxSortId, (long)kPageSizeCount];
    if (maxSortId == 0) {
        sql = [NSString stringWithFormat:@"select * from %@ order by sortId desc LIMIT %ld", _tableName, (long)kPageSizeCount];
    }
    return [[FMDBRoot getInstance] queryTableWithSelfDefineSql:sql];
}

- (NSMutableArray *)queryDataFromTable:(NSNumber *)itemId{
    NSDictionary *dic = @{_primaryKey:itemId};
    return [[FMDBRoot getInstance] queryTable:_tableName withDic:dic];
}

- (void)deleteDataOfDB:(NSArray *)dataArr {
    for (int i = 0; i < [dataArr count]; i++) {
        NSDictionary *tmpDic = [dataArr objectAtIndex:i];
         NSArray *queryArr = [self queryDataFromTable:[tmpDic objectForKey:_primaryKey]];
        if ([queryArr count] > 0) {
            [self deleteDataOfTable:tmpDic];
        }
    }
}

- (void)syncDataToDB:(NSArray *)dataArr {
    for (int i = 0; i < [dataArr count]; i++) {
        NSDictionary *tmpDic = [dataArr objectAtIndex:i];
        
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
//        NSMutableArray *argsArr = [[NSMutableArray alloc] init];
        NSArray *typeKeyArr = [_columnType allKeys];
        for (NSString *key in typeKeyArr) {
//            id tmpObj = NSClassFromString([_columnType objectForKey:key]);
            id tmpObj;
            tmpObj = [tmpDic objectForKey:key];
            if (tmpObj == nil) {
                if ([[_columnType objectForKey:key] isEqualToString:@"NSString"]) {
                    tmpObj = @"";
                } else {
                    tmpObj = [NSNumber numberWithInt:1];
                }
            }
            [newDic setObject:tmpObj forKey:key];
//            [argsArr addObject:tmpObj];
        }
        
        NSArray *queryArr = [self queryDataFromTable:[tmpDic objectForKey:_primaryKey]];
        if ([queryArr count]) {
            //执行更新操作
            [self updateDataOfTable:newDic mainKey:_primaryKey];
        } else {
            //执行插入操作
            [self insertDataToTable:newDic];
        }
    }
}

// 建表
- (BOOL)createTable {
    if (![[FMDBRoot getInstance] isTableExist:_tableName]) {
        return [[FMDBRoot getInstance] createTable:_tableName withTableColumnDic:_tableColumn];
    } else {
        NSLog(@"table %@ already exist", _tableName);
        return NO;
    }
}

@end
