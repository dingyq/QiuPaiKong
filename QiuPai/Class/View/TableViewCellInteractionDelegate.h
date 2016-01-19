//
//  TableViewCellInteractionDelegate.h
//  QiuPai
//
//  Created by bigqiang on 15/12/12.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewCellInteractionDelegate <NSObject>

@optional
- (void)headImageClick:(id)sender;

- (void)getTagGoodsRequest:(NSInteger)goodsId;
- (void)commentButtonClick:(id)sender;

- (void)gotoBuyGoods:(NSString *)goodsName goodsId:(NSInteger)goodsId goodsUrl:(NSString *)goodsUrl;

- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId;
- (void)sendUserCollectRequest:(NSInteger)type itemId:(NSInteger)itemId;

- (void)sendUserAttentionRequest:(NSString *)evaluUserId;
- (void)loadMoreSubEvalution;
- (void)getTagGoodsRequest:(NSInteger)goodsId name:(NSString *)goodsName brand:(NSString *)goodsBrand evaluNum:(NSInteger)evaluNum;



@end
