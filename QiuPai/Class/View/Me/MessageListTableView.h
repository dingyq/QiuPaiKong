//
//  MessageListTableView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomListTableViewDelegate.h"

@class MessageListTableView;

typedef NS_ENUM(NSInteger, MessageListTableType) {
    MessageListTableTypeComment = 1,
    MessageListTableTypeLike = 2,
};

@interface MessageListTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, weak) id<CustomListTableViewDelegate>myDelegate;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, assign) NSInteger type;

@end
