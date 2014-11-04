//
//  Visit.h
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/30.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Visit : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSDate * arrival;
@property (nonatomic, retain) NSDate * departure;
@property (nonatomic, retain) NSDate * recordDate;

@end
