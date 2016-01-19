//
//  RacketSearchModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "RacketSearchModel.h"

@implementation RacketSearchModel


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.balance = [attributes objectForKey:@"balance"];
        self.brand = [attributes objectForKey:@"brand"];
        self.desc = [attributes objectForKey:@"desc"];
        self.evaluateNum = [[attributes objectForKey:@"evaluateNum"] integerValue];
        self.goodsId = [[attributes objectForKey:@"goodsId"] integerValue];
        self.headSize = [[attributes objectForKey:@"headSize"] floatValue];
        self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
        self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
        self.name = [attributes objectForKey:@"name"];
        self.picUrl = [attributes objectForKey:@"picUrl"];
        self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
        self.type = [[attributes objectForKey:@"type"] integerValue];
        self.weight = [[attributes objectForKey:@"weight"] integerValue];
        
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
        self.price = [[attributes objectForKey:@"price"] integerValue];
        self.save = [[attributes objectForKey:@"save"] integerValue];
        self.isPrivilege = [[attributes objectForKey:@"isPrivilege"] integerValue];
        
        self.sellUrl = [attributes objectForKey:@"sellUrl"];
        self.itemStatus = [[attributes objectForKey:@"itemStatus"] integerValue];

    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    RacketSearchModel *tmpModel = [[self class] allocWithZone:zone];
    tmpModel.balance = [self.balance copy];
    tmpModel.brand = [self.brand copy];
    tmpModel.desc = [self.desc copy];
    tmpModel.evaluateNum = self.evaluateNum;
    tmpModel.goodsId = self.goodsId;
    tmpModel.headSize = self.headSize;
    tmpModel.isLike = self.likeNum;
    tmpModel.likeNum = self.isLike;
    tmpModel.name = [self.name copy];
    tmpModel.picUrl = [self.picUrl copy];
    tmpModel.thumbPicUrl = [self.thumbPicUrl copy];
    tmpModel.type = self.type;
    tmpModel.weight = self.weight;
    
    tmpModel.sortId = self.sortId;
    tmpModel.itemId = self.itemId;
    tmpModel.price = self.price;
    tmpModel.save = self.save;
    tmpModel.isPrivilege = self.isPrivilege;
    tmpModel.sellUrl = [self.sellUrl copy];
    
    return tmpModel;
}

- (NSInteger)goodsId {
    return _goodsId?_goodsId:_itemId;
}

- (NSString *)brand {
    return _brand?_brand:@"未知";
}

- (float)getSearchResultCellHeight {
    float height = 82.0f;
    return height;
}

- (float)getZanListCellHeight {
    return [self getSearchResultCellHeight];
}

@end
