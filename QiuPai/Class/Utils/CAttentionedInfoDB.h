//
//  CAttentionedInfoDB.h
//  QiuPai
//
//  Created by bigqiang on 16/1/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAttentionedInfoDB : NSObject


+ (instancetype)getInstance;

//- (BOOL)createTable; // 建表

- (void)clearAllDataOfTable; // 清空表内全部数据

- (void)insertDataToTable:(NSDictionary *)valueDic; // 插入单条数据库记录

- (void)deleteDataOfTable:(NSDictionary *)valueDic; // 清空表内单条数据

- (void)updateDataOfTable:(NSDictionary *)valueDic mainKey:(NSString *)majorKey; // 更新单条数据库记录

//- (NSMutableArray *)getLatestDataFromDB:(NSInteger)maxSortId;
- (NSMutableArray *)getLatestDataFromDB:(NSInteger)maxSortId;

- (void)syncDataToDB:(NSArray *)dataArr; // 批量更新数据库

- (void)deleteDataOfDB:(NSArray *)dataArr; // 批量删除数据


@end
