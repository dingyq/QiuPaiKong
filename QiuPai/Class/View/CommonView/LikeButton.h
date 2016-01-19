//
//  LikeButton.h
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame numTip:(NSString *)numStr;
- (void)setTitleTip:(NSString *)strValue;

@end
