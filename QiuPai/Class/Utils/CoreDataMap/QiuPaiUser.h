//
//  QiuPaiUser.h
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class QiuPaiUserModel;
@interface QiuPaiUser : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (NSMutableArray *)queryDataFromCoreData:(NSString *)usrId;
+ (void)saveDataToCoreData:(QiuPaiUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END

#import "QiuPaiUser+CoreDataProperties.h"
