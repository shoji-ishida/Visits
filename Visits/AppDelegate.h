//
//  AppDelegate.h
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/21.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

