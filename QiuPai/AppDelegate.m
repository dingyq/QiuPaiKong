//
//  AppDelegate.m
//  QiuPai
//
//  Created by bigqiang on 15/11/3.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "AppDelegate.h"
#import "QiuPaiUserModel.h"
#import "QiuPaiUser.h"
#import "WXApiManager.h"

@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    tabBarController.selectedIndex = 2;
    tabBarController.tabBar.tintColor = CustomGreenColor;
    
    NSArray *viewControllers = [tabBarController viewControllers];
    for (int i = 0; i < [viewControllers count]; i ++) {
        DDNavigationController *nc = [viewControllers objectAtIndex:i];
//        [nc addAlphaView];
        if (i == 0) {
            [nc.tabBarItem setImage:[UIImage imageNamed:@"tab_precise_select_nor"]];
            [nc.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_precise_select_sel"]];
            [nc.tabBarItem setTitle:@"精选"];
        } else if (i == 1) {
            [nc.tabBarItem setImage:[UIImage imageNamed:@"tab_circle_nor"]];
            [nc.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_circle_sel"]];
            [nc.tabBarItem setTitle:@"评测"];
        } else if (i == 2) {
            [nc.tabBarItem setImage:[UIImage imageNamed:@"tab_me_nor"]];
            [nc.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_me_sel"]];
            [nc.tabBarItem setTitle:@"我"];
        }
    }
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    /*
    // 推送服务
    if (KSystemVersion > 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //忽略警告
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound)];
#pragma clang diagnostic pop
    }
     */
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;
    
    // 为了延长启动页的展示时间，这里可手动延时
    // [NSThread sleepForTimeInterval:1.0];

    // 友盟统计上报
    [MobClick startWithAppkey:KUMengAppKey reportPolicy:BATCH channelId:Request_Channel];
    // 向微信注册
    [WXApi registerApp:KWXAppId withDescription:@"qiupaikong"];
    
    // QQ
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[QQSdkCall getInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[QQSdkCall getInstance]];
    
    return YES;
}


#pragma mark -
#pragma mark qq login notify back

-(void)loginSuccessed{
    NSLog(@"loginSuccessed");
//    NSString* openId = [[[QQSdkCall getInstance] oauth] openId];
//    NSString* accessToken = [[[QQSdkCall getInstance] oauth] accessToken];
//    NSDictionary* dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:openId, @"openId", accessToken, @"accessToken", @"0", @"errCode", nil];
}

-(void)loginFailed{
    NSLog(@"loginFailed");
//    NSDictionary* dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"openId", @"", @"accessToken", @"-1", @"errCode", nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//#if !TARGET_IPHONE_SIMULATOR
////    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
////    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
//    // Set the defaults to disabled unless we find otherwise...
//    NSString *pushBadge = @"enabled";
//    NSString *pushAlert = @"enabled";
//    NSString *pushSound = @"enabled";
//    if (KSystemVersion > 8.0) {
//        NSUInteger rntypes = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
//        pushBadge = (rntypes & UIUserNotificationTypeBadge) ? @"enabled" : @"disabled";
//        pushAlert = (rntypes & UIUserNotificationTypeAlert) ? @"enabled" : @"disabled";
//        pushSound = (rntypes & UIUserNotificationTypeSound) ? @"enabled" : @"disabled";
//    } else {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
//        pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
//        pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
//#pragma clang diagnostic pop
//    }
//    // Get the users Device Model, Display Name, Unique ID, Token & Version Number
////    UIDevice *dev = [UIDevice currentDevice];
////    NSString *deviceName = dev.name;
////    NSString *deviceModel = dev.model;
////    NSString *deviceSystemVersion = dev.systemVersion;
////    
////    // Prepare the Device Token for Registration (remove spaces and < >)
////    NSString *devToken = [[[[deviceToken description]
////                               stringByReplacingOccurrencesOfString:@"<" withString:@""]
////                              stringByReplacingOccurrencesOfString:@">" withString:@""]
////                             stringByReplacingOccurrencesOfString: @" " withString: @""];
//#endif


}


- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    NSArray* strArr = [url.absoluteString componentsSeparatedByString:@":"];
    NSString* headStr = strArr[0];
    if ([headStr isEqualToString:KWXAppId]) {
        NSLog(@"weixin");
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else
//        if([headStr isEqualToString:[NSString stringWithFormat:@"tencent%@", KQQAppId]])
         {
        NSLog(@"qq");
        return [TencentOAuth HandleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    NSArray* strArr = [url.absoluteString componentsSeparatedByString:@":"];
    NSString* headStr = strArr[0];
    if ([headStr isEqualToString:KWXAppId]) {
        NSLog(@"weixin");
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else if([headStr isEqualToString:[NSString stringWithFormat:@"tencent%@", KQQAppId]]) {
        NSLog(@"qq");
        return [TencentOAuth HandleOpenURL:url];
    } else
//        if ([headStr isEqualToString:Url_Schema_Header_Qpk])
    {
        
        return YES;
    }
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.barbecue.TestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QiuPai" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QiuPai.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
