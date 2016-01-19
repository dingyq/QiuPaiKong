//
//  QiuPaiUser.m
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "QiuPaiUser.h"
#import "QiuPaiUserModel.h"
#import "AppDelegate.h"

static NSString *tableName = @"QiuPaiUser";
@implementation QiuPaiUser

// Insert code here to add functionality to your managed object subclass

+ (NSManagedObjectContext *)getManagedContext {
    AppDelegate * delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    return context;
}

+ (void)saveDataToCoreData:(QiuPaiUserModel *)userModel {
    [QiuPaiUser insertDataToCoreData:userModel];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userModel.userId forKey:@"userId"];
    [ud synchronize];
    
    NSArray *fetchedObjects = [QiuPaiUser queryDataFromCoreData:userModel.userId];
    for (QiuPaiUser *info in fetchedObjects) {
        NSLog(@"uid: %@", info.userId);
        NSLog(@"name: %@", info.nick);
        NSLog(@"headUrl: %@", info.headPic);
    }
}

// 是否存在记录
+ (BOOL)userIsExistInCoreData:(NSString *)usrId {
    NSManagedObjectContext *context = [QiuPaiUser getManagedContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId like %@", usrId];
    //首先你需要建立一个request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:context]];
    //这里相当于sqlite中的查询条件，具体格式参考苹果文档
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if ([result count] <= 0) {
        return false;
    }
    return true;
}

// 增加
+ (void)insertDataToCoreData:(QiuPaiUserModel *)userModel {
    if ([QiuPaiUser userIsExistInCoreData:userModel.userId]) {
        [QiuPaiUser updateDataToCoreData:userModel];
    } else {
        NSManagedObjectContext *context = [QiuPaiUser getManagedContext];
        QiuPaiUser *qpUser = [NSEntityDescription insertNewObjectForEntityForName:tableName
                                                           inManagedObjectContext:context];
        qpUser.userId = userModel.userId;
        qpUser.headPic = userModel.headPic;
        qpUser.nick = userModel.nick;
        qpUser.sex = userModel.sex;
        qpUser.age = userModel.age;
        qpUser.playYear = userModel.playYear;
        qpUser.racquet = userModel.racquet;
        qpUser.province = userModel.province;
        qpUser.city = userModel.city;
        qpUser.lvEevaluate = userModel.lvEevaluate;
        
        qpUser.height = userModel.height;
        qpUser.weight = userModel.weight;
        qpUser.selfEveluate = userModel.selfEveluate;
        qpUser.backHand = userModel.backHand;
        qpUser.playFreq = userModel.playFreq;
        qpUser.grapHand = userModel.grapHand;
        qpUser.otherGame = userModel.otherGame;
        qpUser.powerSelfEveluate = userModel.powerSelfEveluate;
        qpUser.staOrBurn = userModel.staOrBurn;
        qpUser.injuries = userModel.injuries;
        qpUser.style = userModel.style;
        qpUser.region = userModel.region;
        qpUser.star = userModel.star;
        qpUser.color = userModel.color;
        qpUser.brand = userModel.brand;
        qpUser.gripSize = userModel.gripSize;
        
        qpUser.concernNum = userModel.concernNum;
        qpUser.messageNum = userModel.messageNum;
        qpUser.nConcerned = userModel.nConcerned;
        qpUser.nLike = userModel.nLike;
        qpUser.nMessage = userModel.nMessage;
        
        qpUser.authkey = userModel.authKey;
        qpUser.score = userModel.score;
        qpUser.concernedNum = userModel.concernedNum;
        
        qpUser.report = userModel.report;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

// 删除
+ (void)deleteDataFromCoreData:(NSString *)usrId {
    NSManagedObjectContext *context = [QiuPaiUser getManagedContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]) {
        for (NSManagedObject *obj in datas) {
            [context deleteObject:obj];
        }
        if (![context save:&error]) {
            NSLog(@"error:%@",error);
        }
    }
}

// 查询
+ (NSMutableArray *)queryDataFromCoreData:(NSString *)usrId {
    NSManagedObjectContext *context = [QiuPaiUser getManagedContext];
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (QiuPaiUser *info in fetchedObjects) {
        if ([info.userId isEqualToString:usrId]) {
            [resultArray addObject:info];
        }
    }
    return resultArray;
}

// 更新
+ (void)updateDataToCoreData:(QiuPaiUserModel *)userModel {
    NSManagedObjectContext *context = [QiuPaiUser getManagedContext];
    //首先你需要建立一个request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:context]];
    //这里相当于sqlite中的查询条件，具体格式参考苹果文档
    if (userModel.userId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId like %@", userModel.userId];
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        for (QiuPaiUser *info in result) {
    
            info.headPic = userModel.headPic;

            info.nick = userModel.nick;
            info.sex = userModel.sex;
            info.age = userModel.age;
            info.playYear = userModel.playYear;
            info.racquet = userModel.racquet;
            info.province = userModel.province;
            info.city = userModel.city;
            info.lvEevaluate = userModel.lvEevaluate;
    
            info.height = userModel.height;
            info.weight = userModel.weight;
            info.selfEveluate = userModel.selfEveluate;
            info.backHand = userModel.backHand;
            info.playFreq = userModel.playFreq;
            info.grapHand = userModel.grapHand;
            info.otherGame = userModel.otherGame;
            info.powerSelfEveluate = userModel.powerSelfEveluate;
            info.staOrBurn = userModel.staOrBurn;
            info.injuries = userModel.injuries;
            info.style = userModel.style;
            info.region = userModel.region;
            info.star = userModel.star;
            info.color = userModel.color;
            info.brand = userModel.brand;
            info.gripSize = userModel.gripSize;
            
            info.concernNum = userModel.concernNum;
            info.messageNum = userModel.messageNum;
            info.nConcerned = userModel.nConcerned;
            info.nLike = userModel.nLike;
            info.nMessage = userModel.nMessage;
            
            info.authkey = userModel.authKey;
            info.score = userModel.score;
            info.concernedNum = userModel.concernedNum;
            
            info.report = userModel.report;
        }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}



@end
