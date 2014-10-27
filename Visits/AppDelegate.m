//
//  AppDelegate.m
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/21.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property CLLocationManager* manager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // CLLocationManagerの生成とデリゲートの設定
    self.manager = [CLLocationManager new];
    [self.manager setDelegate:self];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
    }
    //Visitの取得開始
    [self.manager startMonitoringVisits];
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];

    if (self.dataSource == nil) {
        self.dataSource = [NSMutableArray array];    
    }
    return YES;
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

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* arrivalDate = [outputFormatter stringFromDate:visit.arrivalDate];
    NSString* departureDate = [outputFormatter stringFromDate:visit.departureDate];
    NSString* latitude = [NSString stringWithFormat:@"%f",visit.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f",visit.coordinate.longitude];
    
    //緯度経度・到着時間・出発時間をローカル通知で表示
    NSMutableString* message = [NSMutableString string];
    [message appendString:[NSString stringWithFormat:@"緯度：%@\n",latitude]];
    [message appendString:[NSString stringWithFormat:@"経度：%@\n",longitude]];
    [message appendString:[NSString stringWithFormat:@"到着時間：%@\n",arrivalDate]];
    [message appendString:[NSString stringWithFormat:@"出発時間：%@\n",departureDate]];
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self.dataSource addObject:visit];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Got authorization, start tracking Visists");
            //[self.manager startMonitoringVisits];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.manager requestAlwaysAuthorization];
        default:
            break;
    }
}

@end
