//
//  MapViewController.m
//  Visits
//
//  Created by ishida on 2014/11/04.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.mapType = MKMapTypeStandard;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(35.697223, 139.769239);
    //MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 150., 150.);
    
    //[self.mapView setShowsPointsOfInterest:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setRegion:region];
    [self.mapView setDelegate:self];
    
    MKCircle * circle = [MKCircle circleWithCenterCoordinate:coord radius:150.];
    [self.mapView addOverlay:circle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    // ※2 今回はサンプルなので可視化します
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 1.0;
        renderer.strokeColor = [UIColor redColor];
        renderer.fillColor = [UIColor redColor];
        renderer.alpha = 0.1;
        return renderer;
    }
    return overlay;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
