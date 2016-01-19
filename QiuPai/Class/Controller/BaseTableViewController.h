//
//  BaseTableViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController


@property (nonatomic, strong) DDActivityIndicatorView *netIndicatorView;
@property (nonatomic, strong) NoDataTipView *noDataTipV;
@property (nonatomic, strong) BadNetTipView *badNetTipV;


- (void)backToPreVC:(id)sender;

@end
