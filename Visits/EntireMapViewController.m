//
//  EntireMapViewController.m
//  Visits
//
//  Created by 石田勝嗣 on 2014/12/17.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import "EntireMapViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Visit.h"


@interface EntireMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation EntireMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

    self.mapView.mapType = MKMapTypeStandard;
    [self.mapView setDelegate:self];
    
    [self addAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    double minLat = 9999.0;
    double minLng = 9999.0;
    double maxLat = -9999.0;
    double maxLng = -9999.0;
    double lat, lng;
    for (id<MKAnnotation> annotation in self.mapView.annotations){
        lat = annotation.coordinate.latitude;
        lng = annotation.coordinate.longitude;
        //find largest/smallest latitude
        if(minLat > lat)
            minLat = lat;
        if(lat > maxLat)
            maxLat = lat;
        
        //find largest/smallest longitude
        if(minLng > lng)
            minLng = lng;
        if(lng > maxLng)
            maxLng = lng;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat + minLat) / 2.0, (maxLng + minLng) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat + .05, maxLng - minLng + .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addAnnotations {
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *fetchedResultsController
    = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                          managedObjectContext:self.managedObjectContext
                                            sectionNameKeyPath:nil
                                                     cacheName:nil];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSArray *moArray = [fetchedResultsController fetchedObjects];
    for (Visit *visit in moArray) {
        if (![visit.departure isEqualToDate: [NSDate distantFuture]]) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([visit.latitude doubleValue], [visit.longitude doubleValue]);
            MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
            pin.coordinate = coord;
            [self.mapView addAnnotation:pin];
        }
    }
}
@end
