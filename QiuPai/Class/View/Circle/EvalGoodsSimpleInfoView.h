//
//  EvalGoodsSimpleInfoView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/3.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvalGoodsSimpleInfoView : UIView

- (void)showGoodsSelectTip:(NSString *)tipStr;

- (void)setRacketLineInfo:(NSString *)imageUrl name:(NSString *)goodsName caiZhi:(NSString *)caiZhi;

- (void)setRacketInfo:(NSString *)imageUrl name:(NSString *)goodsName weight:(NSString *)weight balance:(NSString *)balance headSize:(NSString *)headSize;
@end
