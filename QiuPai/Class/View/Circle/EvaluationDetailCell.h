//
//  EvaluationDetailCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellInteractionDelegate.h"

@class EvaluationDetailModel;

typedef NS_ENUM(NSInteger, EvaluationDetailCellType) {
    EvaluationDetailCellType_Evalu = 1,
    EvaluationDetailCellType_Comment = 2,

};

@interface EvaluationDetailCell : UITableViewCell
@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(EvaluationDetailCellType)type;

- (void)bindContentCellWithModel:(EvaluationDetailModel *)infoModel cellSection:(NSInteger)section cellIndex:(NSInteger)row hideGoodsTag:(BOOL)isHideTag;

//- (void)bindContentCellWithDic:(NSDictionary *)contDic;
//
//- (void)bindCommentCellWithDic:(NSDictionary *)contDic;

@end
