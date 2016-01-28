//
//  QiuPaiUserModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//
//  球拍用户model
//  单例模式
//
//


#import "QiuPaiUserModel.h"
#import "QiuPaiUser.h"
#import "LoginInViewController.h"

static QiuPaiUserModel *sharedQPUser = nil;
static NSString *tableName = @"QiuPaiUser";

@interface QiuPaiUserModel(){
    NSManagedObjectContext *_managedObjectcontext;
}

@end

@implementation QiuPaiUserModel

@synthesize playFreq = _playFreq;
@synthesize powerSelfEveluate = _powerSelfEveluate;
@synthesize injuries = _injuries;
@synthesize staOrBurn = _staOrBurn;
@synthesize style = _style;
@synthesize region = _region;
@synthesize headPic = _headPic;
@synthesize nick = _nick;
@synthesize sex = _sex;
@synthesize age = _age;
@synthesize playYear = _playYear;
@synthesize racquet = _racquet;
@synthesize province = _province;
@synthesize city = _city;
@synthesize lvEevaluate = _lvEevaluate;
@synthesize height = _height;
@synthesize weight = _weight;
@synthesize selfEveluate = _selfEveluate;
@synthesize backHand = _backHand;
@synthesize grapHand = _grapHand;
@synthesize otherGame = _otherGame;
@synthesize gripSize = _gripSize;
@synthesize star = _star;
@synthesize color = _color;
@synthesize brand = _brand;
@synthesize userId = _userId;

+ (QiuPaiUserModel *)getUserInstance {
    @synchronized(self) {
        if (sharedQPUser == nil) {
            sharedQPUser = [[QiuPaiUserModel alloc] initFromCoreData];
        }
    }
    return sharedQPUser;
}

- (void)clearUserInfo {

}

- (instancetype)initFromCoreData {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *usrId = [ud objectForKey:@"userId"];
    self.userId = usrId;
    self.isTimeOut = NO;
    
    NSArray *result = [QiuPaiUser queryDataFromCoreData:usrId];
    if ([result count] > 0) {
        QiuPaiUser *info = (QiuPaiUser *)[result objectAtIndex:0];
        self.isTimeOut = NO;
        
        self.headPic = info.headPic;
        self.nick = info.nick;
        self.sex = info.sex;
        self.age = info.age;
        self.playYear = info.playYear;
        self.racquet = info.racquet;
        self.province = info.province;
        self.city = info.city;
        self.lvEevaluate = info.lvEevaluate;
        
        self.height = info.height;
        self.weight = info.weight;
        self.selfEveluate = info.selfEveluate;
        self.backHand = info.backHand;
        self.playFreq = info.playFreq;
        self.grapHand = info.grapHand;
        self.otherGame = info.otherGame;
        self.powerSelfEveluate = info.powerSelfEveluate;
        self.staOrBurn = info.staOrBurn;
        self.injuries = info.injuries;
        self.style = info.style;
        self.region = info.region;
        self.star = info.star;
        self.color = info.color;
        self.brand = info.brand;
        self.gripSize = info.gripSize;
        
        self.thumbHeadPic = info.thumbHeadPic;
        self.concernNum = info.concernNum;
        self.messageNum = info.messageNum;
        self.nConcerned = info.nConcerned;
        self.nLike = info.nLike;
        self.nMessage = info.nMessage;
        self.concernedNum = info.concernedNum;
        self.score = info.score;
        self.authKey = info.authkey;
        
        self.report = info.report;
    } else {
        self.isTimeOut = YES;
    }
    return self;
}

- (void)updateWithDic:(NSDictionary *)dic {
    if (dic == nil) {
        self.isTimeOut = YES;
        return;
    }
    if ([dic objectForKey:@"userId"]) {
        //存储最近登录用户的id
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[dic objectForKey:@"userId"] forKey:@"userId"];
        [ud synchronize];
        self.userId = [dic objectForKey:@"userId"];
    }
    self.isTimeOut = NO;
    self.headPic = [dic objectForKey:@"headPic"];
    self.thumbHeadPic = [dic objectForKey:@"thumbHeadPic"];
    self.nick = [dic objectForKey:@"nick"];
    self.sex = [dic objectForKey:@"sex"];
    self.age = [dic objectForKey:@"age"];
    self.playYear = [dic objectForKey:@"playYear"];
    self.racquet = [dic objectForKey:@"racquet"];
    self.province = [dic objectForKey:@"province"];
    self.city = [dic objectForKey:@"city"];
    self.lvEevaluate = [dic objectForKey:@"lvEevaluate"];
    
    self.height = [dic objectForKey:@"height"];
    self.weight = [dic objectForKey:@"weight"];
    self.selfEveluate = [dic objectForKey:@"selfEveluate"];
    self.backHand = [dic objectForKey:@"backHand"];
    self.playFreq = [dic objectForKey:@"playFreq"];
    self.grapHand = [dic objectForKey:@"grapHand"];
    self.otherGame = [dic objectForKey:@"otherGame"];
    self.powerSelfEveluate = [dic objectForKey:@"powerSelfEveluate"];
    self.staOrBurn = [dic objectForKey:@"staOrBurn"];
    self.injuries = [dic objectForKey:@"injuries"];
    self.style = [dic objectForKey:@"style"];
    self.region = [dic objectForKey:@"region"];
    self.star = [dic objectForKey:@"star"];
    self.color = [dic objectForKey:@"color"];
    self.brand = [dic objectForKey:@"brand"];
    self.gripSize = [dic objectForKey:@"gripSize"];
    
    self.concernNum = [dic objectForKey:@"concernNum"];
    self.messageNum = [dic objectForKey:@"messageNum"];
    self.nConcerned = [dic objectForKey:@"newConcerned"];
    self.nLike = [dic objectForKey:@"newLike"];
    self.nMessage = [dic objectForKey:@"newMessage"];
    self.concernedNum = [dic objectForKey:@"concernedNum"];
    self.score = [dic objectForKey:@"score"];
    if ([dic objectForKey:@"authkey"]) {
        self.authKey = [dic objectForKey:@"authkey"];
    }
    self.report = [dic objectForKey:@"report"];
    
    [QiuPaiUser saveDataToCoreData:self];
}

+ (void)saveSelfToCoreData {
    [QiuPaiUser saveDataToCoreData:[QiuPaiUserModel getUserInstance]];
}

- (void)showUserLoginVC {
    LoginInViewController *vc = [[LoginInViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
//    vc.loginDelegate = self;
    [vc.navigationController setNavigationBarHidden:NO animated:NO];
    DDNavigationController* nav = [[DDNavigationController alloc] initWithRootViewController:vc];
    
    [[Helper getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

- (void)userLogout {
    self.isTimeOut = YES;
}

- (void)clearAllUserData {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    [ud setObject:@"" forKey:@"userId"];
    [ud removeObjectForKey:@"userId"];
    [ud synchronize];
    self.userId = @"";
    self.headPic = @"";
    self.headPic = @"";
    self.nick = @"";
    self.sex = @0;
    self.age = @0;
    self.playYear = @"";
    self.racquet = @"";
    self.province = @"";
    self.city = @"";
    self.lvEevaluate = @0;
    
    self.height = @0;
    self.weight = @0;
    self.selfEveluate = @0;
    self.backHand = @0;
    self.playFreq = @0;
    self.grapHand = @0;
    self.otherGame = @0;
    self.powerSelfEveluate = @0;
    self.staOrBurn = @0;
    self.injuries = @0;
    self.style = @0;
    self.region = @0;
    self.star = @[];
    self.color = @[];
    self.brand = @[];
    self.gripSize = @0;
    
    self.concernNum = @0;
    self.messageNum = @0;
    self.nConcerned = @0;
    self.nLike = @0;
    self.nMessage = @0;
    self.concernedNum = @0;
    self.score = @0;
    self.authKey = @"";
    
    self.report = @{};
}

- (NSString *)headPic {
    return _headPic?_headPic:@"";
}

- (NSString *)nick {
    return _nick?_nick:@"";
}

- (NSString *)playYear {
    return _playYear?_playYear:@"";
}

- (NSString *)racquet {
    return _racquet?_racquet:@"";
}

- (NSString *)province {
    return _province?_province:@"";
}

- (NSString *)city {
    return _city?_city:@"";
}

- (NSNumber *)lvEevaluate {
    return [_lvEevaluate integerValue] > 0 ? _lvEevaluate:@10;
}

- (NSString *)userId {
    return _userId?_userId:@"";
}

- (NSString *)authKey {
    return _authKey?_authKey:@"";
}

//- (NSString *)userId {
//    if (_userId == nil || [_userId isEqualToString:@""]) {
//        _isTimeOut = NO;
//        return @"vida01";
//    }
//    return _userId;
//}
//
//- (NSString *)authKey {
//    return _authKey?_authKey:@"abc";
//}

- (NSNumber *)height {
    return _height?_height:@0;
}

- (NSNumber *)weight {
    return _weight?_weight:@0;
}

- (NSNumber *)age {
    return _age?_age:@0;
}

- (NSNumber *)sex {
    return _sex?_sex:@0;
}

- (NSNumber *)selfEveluate {
    return _selfEveluate?_selfEveluate:@1;
}

- (NSNumber *)playFreq {
    return _playFreq?_playFreq:@1;
}

- (NSNumber *)powerSelfEveluate {
    return _powerSelfEveluate?_powerSelfEveluate:@1;
}

- (NSNumber *)injuries {
    return _injuries?_injuries:@1;
}

- (NSNumber *)region {
    return _region?_region:@1;
}

- (NSNumber *)style {
    return _style?_style:@1;
}

- (NSString *)wbRefreshToken {
    return _wbRefreshToken ? _wbRefreshToken:@"";
}

- (void)setIsTimeOut:(BOOL)isTimeOut {
    _isTimeOut = isTimeOut;
    if (_isTimeOut) {
        // 登录态失效
        [self clearAllUserData];
    }
}

@end
