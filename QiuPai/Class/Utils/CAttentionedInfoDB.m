//
//  CAttentionedInfoDB.m
//  QiuPai
//
//  Created by bigqiang on 16/1/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "CAttentionedInfoDB.h"
#import "FMDBRoot.h"

@interface CAttentionedInfoDB(){
    NSString *_tableName;
    NSString *_primaryKey;
    NSDictionary *_tableColumn;
    NSDictionary *_columnType;
}
@end

@implementation CAttentionedInfoDB

+ (instancetype)getInstance {
    static CAttentionedInfoDB *shareInstance = nil;
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CircleInfoDB" ofType:@"plist"];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _primaryKey = [configDic objectForKey:@"PrimaryKey"];
    _tableName = [[configDic objectForKey:@"TableName"] objectAtIndex:1];
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
    if (!valueDic) {
        return;
    }
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
- (NSMutableArray *)queryDataFromDB {
    return [[FMDBRoot getInstance] queryTable:_tableName];
}

- (NSMutableArray *)queryDataFromTable:(NSNumber *)itemId{
    NSDictionary *dic = @{_primaryKey:itemId};
    return [[FMDBRoot getInstance] queryTable:_tableName withDic:dic];
}

- (NSMutableArray *)getLatestDataFromDB:(NSInteger)maxSortId {
    NSString *sql = @"";
    if (maxSortId == 0) {
        sql = [NSString stringWithFormat:@"select * from %@ where (isConcerned=1 AND evaluateUserId!='%@') order by sortId desc LIMIT %ld", _tableName, [QiuPaiUserModel getUserInstance].userId, (long)kPageSizeCount];
        
        //            sql = [NSString stringWithFormat:@"select * from %@ where (isConcerned=1) order by sortId desc LIMIT %ld", _tableName, (long)kPageSizeCount];
    } else {
        sql = [NSString stringWithFormat:@"select * from %@ where (sortId < %ld AND isConcerned=1 AND evaluateUserId!='%@') order by sortId desc LIMIT %ld", _tableName, (long)maxSortId, [QiuPaiUserModel getUserInstance].userId, (long)kPageSizeCount];
        
        //            sql = [NSString stringWithFormat:@"select * from %@ where (sortId < %ld AND isConcerned=1) order by sortId desc LIMIT %ld", _tableName, (long)maxSortId, (long)kPageSizeCount];
    }
    return [[FMDBRoot getInstance] queryTableWithSelfDefineSql:sql];
}

- (void)deleteDataOfDB:(NSArray *)dataArr {
    for (int i = 0; i < [dataArr count]; i++) {
        NSDictionary *tmpDic = [dataArr objectAtIndex:i];
        NSArray *queryArr = [self queryDataFromTable:[tmpDic objectForKey:_primaryKey]];
        if ([queryArr count] > 0) {
            NSLog(@"delete");
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
            NSLog(@"update");
            [self updateDataOfTable:newDic mainKey:_primaryKey];
        } else {
            //执行插入操作
            NSLog(@"insert");
            [self insertDataToTable:newDic];
        }
    }
}

- (BOOL)createTable {
    if (![[FMDBRoot getInstance] isTableExist:_tableName]) {
        return [[FMDBRoot getInstance] createTable:_tableName withTableColumnDic:_tableColumn];
    } else {
        NSLog(@"table %@ already exist", _tableName);
        return NO;
    }
}


@end
