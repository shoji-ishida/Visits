//
//  ViewController.m
//  Visits
//
//  Created by 石田勝嗣 on 2014/10/21.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "VisitTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:TableViewVisitCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [self.fetchedResultsController sections].count;
    
    if (count == 0) {
        count = 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if ([self.fetchedResultsController sections].count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath: %ld", (long)indexPath.row);
    
    NSString *cellIdentifier = @"Cell";
    VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier  forIndexPath:indexPath];
    
    Visit *visit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSDateFormatter *formatter = nil;
    
    if(!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"yMMMdEEE HHmmss" options:0 locale:[NSLocale currentLocale]];
        [formatter setDateFormat:formatTemplate];
    }
    
    NSString* arrivalDate = [formatter stringFromDate:visit.arrival];
    NSString* departureDate;
    if ([visit.departure isEqualToDate: [NSDate distantFuture]]) {
        departureDate = @"N/A";
    } else {
        departureDate = [formatter stringFromDate:visit.departure];
    }
    NSString* recordDate = [formatter stringFromDate:visit.recordDate];
    
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
    
    return _fetchedResultsController;
}



@end
