//
//  DDStarRatingView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(DDStarRatingView *)view score:(float)score;
@end

@interface DDStarRatingView : UIView

@property (nonatomic, assign) CGFloat currentScore;
@property (nonatomic, readonly) NSInteger numberOfStar;
@property (nonatomic, weak) id<StarRatingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number;
@end
