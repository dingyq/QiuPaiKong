//
//  MyLikeListTableView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomListTableViewDelegate.h"

// 1 我喜欢的专题 2我喜欢的物品 3我喜欢的评测
typedef NS_ENUM(NSInteger, LikeListTableType) {
    LikeListTableTypeSpecialTopic = 1,
    LikeListTableTypeGoods = 2,
    LikeListTableTypeEvaluation = 3,
};

@interface MyLikeListTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, weak) id<CustomListTableViewDelegate>myDelegate;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, assign) NSInteger type;
@end
