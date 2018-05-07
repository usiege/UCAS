//
//  ViewController.h
//  LocationSearch
//
//  Created by Patrick Alessi on 1/23/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Result.h"

@interface ViewController : UIViewController
    <CLLocationManagerDelegate,UISearchBarDelegate,
    NSXMLParserDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocation* currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) Result *aResult;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableString *capturedCharacters;
- (void) parseXML;
- (void) plotResults;

@end
