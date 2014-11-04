//
//  ViewController.m
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/21.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Visit.h"
#import "VisitTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [NSMutableArray array];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    //fetch設定を生成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Visit class])];
    
    //sort条件を設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    self.dataSource = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:TableViewVisitCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection: %lu", (unsigned long)self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath: %ld", (long)indexPath.row);
    NSString *cellIdentifier = @"Cell";
    VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        NSLog(@"create new cell");
        cell = [[VisitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 
    Visit *visit  = [self.dataSource objectAtIndex:indexPath.row];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* arrivalDate = [outputFormatter stringFromDate:visit.arrival];
    NSString* departureDate;
    if ([visit.departure isEqualToDate: [NSDate distantFuture]]) {
        departureDate = @"N/A";
    } else {
        departureDate = [outputFormatter stringFromDate:visit.departure];
    }
    NSString* recordDate = [outputFormatter stringFromDate:visit.recordDate];
    NSLog(@"%@", recordDate);
    
    cell.record.text = recordDate;
    cell.latitude.text = [visit.latitude stringValue];
    cell.longitude.text = [visit.longitude stringValue];
    cell.accuracy.text = [visit.accuracy stringValue];
    cell.arrival.text = arrivalDate;
    cell.departure.text = departureDate;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VisitTableViewCell rowHeight];
}
@end
