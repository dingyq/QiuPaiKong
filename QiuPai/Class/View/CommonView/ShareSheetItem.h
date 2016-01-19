//
//  ShareSheetItem.h
//  QiuPai
//
//  Created by bigqiang on 15/12/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSheetItem : UIButton

@property (nonatomic, assign) int btnIndex;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end
