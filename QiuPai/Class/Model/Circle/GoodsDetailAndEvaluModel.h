//
//  GoodsDetailAndEvaluModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailAndEvaluModel : NSObject

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbPicUrl;
@property (nonatomic, strong) NSArray *sellUrl;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, assign) CGFloat headSize;
@property (nonatomic, assign) NSInteger stiffness;
@property (nonatomic, copy) NSString *stringPattern;
@property (nonatomic, assign) CGFloat beamwidthA;
@property (nonatomic, assign) CGFloat beamwidthB;
@property (nonatomic, assign) CGFloat beamwidthC;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat oriPrice;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger evaluateNum;
@property (nonatomic, assign) CGFloat swiWeight;

@property (nonatomic, assign) CGFloat dia;
@property (nonatomic, copy) NSString *material;  // 材料
@property (nonatomic, copy) NSString *structure; // 结构
@property (nonatomic, copy) NSString *character; // 特性

@property (nonatomic, assign) NSInteger isJunior;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
