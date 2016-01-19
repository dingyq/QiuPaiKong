//
//  LocationChooseViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"
#import "CompleteInfomationDelagate.h"

typedef NS_ENUM(NSInteger, InfoModifyType) {
    InfoModifyTypeLocation = 1,
    InfoModifyTypePlayYear = 2,
    InfoModifyTypeSelfEvalu = 3,
};

@interface LocationChooseViewController : BaseViewController

@property (nonatomic, weak) id<CompleteInfomationDelagate> callDelegate;
@property (nonatomic, assign) InfoModifyType modifyType;
//@property (strong, nonatomic) NSString *areaValue;
//@property (strong, nonatomic) NSString *cityValue;

// 所在地
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;

// 球龄
@property (copy, nonatomic) NSString *playYear;

// 网球水平自测
@property (assign, nonatomic) NSInteger lvEvalu;

@end
