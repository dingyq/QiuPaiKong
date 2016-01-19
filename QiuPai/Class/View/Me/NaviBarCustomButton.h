//
//  NaviBarCustomButton.h
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviBarCustomButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame numTip:(NSString *)numStr tipTitle:(NSString *)tipStr;
- (void)setTitle:(NSString *)strValue;
@end
