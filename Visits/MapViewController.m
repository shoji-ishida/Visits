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
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    //MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, [self.accuracy doubleValue], [self.accuracy doubleValue]);
        
    //[self.mapView setShowsPointsOfInterest:YES];
    [self.mapView setShowsUserLocation:YES];
    //[self.mapView setRegion:region];
    [self.mapView setDelegate:self];
    
    MKCircle * circle = [MKCircle circleWithCenterCoordinate:coord radius:[self.accuracy doubleValue]];
    [self.mapView addOverlay:circle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ViewDidAppear");
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    //MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    double accuracy = [self.accuracy doubleValue] * 1.5f;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, accuracy, accuracy);

    [self.mapView setRegion:region animated:YES];

    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = coord;
    [MapViewController reverseGeocodeLocation:location annotation:pin];

    [self.mapView addAnnotation:pin];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 2.0;
        renderer.strokeColor = [UIColor redColor];
        renderer.fillColor = [UIColor redColor];
        renderer.alpha = 0.1;
        return renderer;
    }
    return overlay;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id )annotation
{
    MKPinAnnotationView* pinView = nil;
    static NSString* Identifier = @"PinAnnotationIdentifier";
    
    // ignore if annotation is for user current location
    if(annotation != mapView.userLocation) {
        pinView = (MKPinAnnotationView *)[mapView
                  dequeueReusableAnnotationViewWithIdentifier:Identifier];
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:Identifier];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            return pinView;
        }
        pinView.annotation = annotation;
    }
    return pinView;
}

/*
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"disSelectAnnotationView");
}
*/

+ (void)reverseGeocodeLocation:(CLLocation *)location annotation:(MKPointAnnotation *)pin
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         if ([placemarks count] > 0) {
             
             CLPlacemark *placemark = (CLPlacemark *)[placemarks lastObject];
             [pin setTitle:placemark.name];
             NSLog(@"%@", placemark.name);
             NSLog(@"%@", placemark.country);
             NSLog(@"%@", placemark.administrativeArea);
             NSLog(@"%@", placemark.subAdministrativeArea);
             NSLog(@"%@", placemark.locality);
             NSLog(@"%@", placemark.subLocality);
             NSLog(@"%@", placemark.thoroughfare);
             NSLog(@"%@", placemark.subThoroughfare);
             NSLog(@"%@", placemark.region);
        }
     }];
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
