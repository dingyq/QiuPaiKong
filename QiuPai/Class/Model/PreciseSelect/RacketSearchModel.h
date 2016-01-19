//
//  RacketSearchModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RacketSearchModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *balance; //平衡点
@property (nonatomic, copy) NSString *brand; //品牌
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger evaluateNum; //评测数
@property (nonatomic, assign) NSInteger goodsId; //商品Id
@property (nonatomic, assign) CGFloat headSize; //拍面大小(英寸)
@property (nonatomic, assign) NSInteger isLike; //是否已喜欢 0否1是
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbPicUrl;
@property (nonatomic, assign) GoodsSearchType type; //商品类别，1球拍(目前只有球拍，也只有球拍有下面参数)
@property (nonatomic, assign) NSInteger weight; //穿线重量(g)


@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger save;
@property (nonatomic, assign) NSInteger isPrivilege;
@property (nonatomic, strong) NSArray *sellUrl;

@property (nonatomic, assign) NSInteger itemStatus;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (float)getSearchResultCellHeight;
- (float)getZanListCellHeight;

@end
