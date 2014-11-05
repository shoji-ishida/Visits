//
//  MapViewController.h
//  Visits
//
//  Created by ishida on 2014/11/04.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *accuracy;
@end
