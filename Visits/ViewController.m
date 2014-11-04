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
    NSLog(@"cellForRowAtIndexPath");
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 
    Visit *visit  = [self.dataSource objectAtIndex:indexPath.row];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* arrivalDate = [outputFormatter stringFromDate:visit.arrival];
    NSString* departureDate = [outputFormatter stringFromDate:visit.departure];
    
    //緯度経度・到着時間・出発時間をローカル通知で表示
    NSMutableString* message = [NSMutableString string];
    [message appendString:[NSString stringWithFormat:@"緯度：%@\n",visit.latitude]];
    [message appendString:[NSString stringWithFormat:@"経度：%@\n",visit.longitude]];
    [message appendString:[NSString stringWithFormat:@"半径：%@\n",visit.accuracy]];
    [message appendString:[NSString stringWithFormat:@"到着時間：%@\n",arrivalDate]];
    [message appendString:[NSString stringWithFormat:@"出発時間：%@\n",departureDate]];
    
    cell.textLabel.text = message;
    return cell;
}

@end
