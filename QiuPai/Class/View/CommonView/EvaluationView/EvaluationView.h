//
//  EvaluationView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RacketCollectionInfoModel;
@class CircleInfoModel;

@interface EvaluationView : UIView

@property (nonatomic, strong) UILabel *textView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame showDetailContent:(BOOL)showBrief;

- (void)setPicArr:(NSArray *)picArr thumbPicArray:(NSArray *)thumbPicArr title:(NSString *)title contentStr:(NSString *)content isCircleList:(BOOL)circleList;
@end
