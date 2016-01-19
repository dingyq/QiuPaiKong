//
//  GoodsDetailAndEvaluModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "GoodsDetailAndEvaluModel.h"

@implementation GoodsDetailAndEvaluModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.goodsId = [[attributes objectForKey:@"goodsId"] integerValue];
    self.type = [[attributes objectForKey:@"type"] integerValue];
    self.name = [attributes objectForKey:@"name"];
    self.picUrl = [attributes objectForKey:@"picUrl"];
    self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
    self.sellUrl = [attributes objectForKey:@"sellUrl"];
    self.desc = [attributes objectForKey:@"desc"];
    self.brand = [attributes objectForKey:@"brand"];
    self.weight = [[attributes objectForKey:@"weight"] floatValue];
    self.balance = [attributes objectForKey:@"balance"];
    self.headSize = [[attributes objectForKey:@"headSize"] floatValue];
    
    self.stiffness = [[attributes objectForKey:@"stiffness"] integerValue];
    self.stringPattern = [attributes objectForKey:@"stringPattern"];
    self.beamwidthA = [[attributes objectForKey:@"beamwidthA"] floatValue];
    self.beamwidthB = [[attributes objectForKey:@"beamwidthB"] floatValue];
    self.beamwidthC = [[attributes objectForKey:@"beamwidthC"] floatValue];
    self.color = [attributes objectForKey:@"color"];
    self.length = [[attributes objectForKey:@"length"] floatValue];
    self.price = [[attributes objectForKey:@"price"] integerValue];
    self.oriPrice = [[attributes objectForKey:@"oriPrice"] integerValue];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.evaluateNum = [[attributes objectForKey:@"evaluateNum"] integerValue];
    
    self.dia = [[attributes objectForKey:@"dia"] floatValue];
    self.material = [attributes objectForKey:@"material"];
    self.structure = [attributes objectForKey:@"structure"];
    self.character = [attributes objectForKey:@"character"];
    
    return self;
}

- (CGFloat)dia {
    return _dia?_dia:0;
}

- (NSString *)material {
    return _material?_material:@"暂无";
}

- (NSString *)structure {
    return _structure?_structure:@"暂无";
}

- (NSString *)character {
    return _character?_character:@"暂无";
}

- (NSString *)color {
    return _color?_color:@"暂无";
}

- (NSArray *)sellUrl {
    if ([_sellUrl count] > 0) {
        return _sellUrl;
    } else {
        return @[Goods_Default_Url];
    }
}

@end
