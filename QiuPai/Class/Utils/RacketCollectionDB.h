//
//  RacketCollectionDB.h
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RacketCollectionDB : NSObject

+ (instancetype)getInstance;

//- (BOOL)createTable; // 建表

- (void)clearAllDataOfTable; // 清空表内全部数据

- (void)deleteDataOfTable:(NSDictionary *)valueDic; // 清空表内单条数据

- (void)insertDataToTable:(NSDictionary *)valueDic; // 插入单条数据库记录

- (void)updateDataOfTable:(NSDictionary *)valueDic mainKey:(NSString *)majorKey; // 更新单条数据库记录

- (NSMutableArray *)getLatestDataFromDB:(NSInteger)maxSortId;

- (void)syncDataToDB:(NSArray *)dataArr; // 批量更新数据库

- (void)deleteDataOfDB:(NSArray *)dataArr; // 批量删除数据

@end
