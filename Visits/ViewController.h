//
//  ViewController.h
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/21.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visit.h"


static NSString * const TableViewVisitCellIdentifier = @"TableViewVisitCell";

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

