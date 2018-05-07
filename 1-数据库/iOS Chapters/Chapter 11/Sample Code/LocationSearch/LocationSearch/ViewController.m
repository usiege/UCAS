//
//  ViewController.m
//  LocationSearch
//
//  Created by Patrick Alessi on 1/23/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Create the results array
    self.results = [[NSMutableArray alloc] init];
    
    
    // Create the Core Location CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    // Set the delegate to self
    [self.locationManager setDelegate:self];
    // Tell the location manager to start updating the location
    [self.locationManager startUpdatingLocation];
    
    // Set the delegate for the searchbar
    [self.searchBar setDelegate:self];
    
    // Set the delegate for the mapView
    [self.mapView setDelegate:self];
    
    // Use Core Location to find the user's location and display it on the map
    // Be careful when using this because it causes the mapview to continue to
    // use Core Location to keep the user's position on the map up to date
    self.mapView.showsUserLocation = YES;
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"didUpdateLocations");
    NSLog(@"Count: %i",locations.count);
    
    self.currentLocation = [locations objectAtIndex:0];
    
    // Create a mapkit region based on the location
    // Span defines the area covered by the map in degrees
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    // Region struct defines the map to show based on center coordinate and span
    MKCoordinateRegion region;
    region.center = self.currentLocation.coordinate;
    region.span = span;
    
    // Update the map to display the current location
    [self.mapView setRegion:region animated:YES];
    
    // Stop core location services to conserve battery
    [manager stopUpdatingLocation];
    
}


// Called when an error occurs
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog (@"locationManager:didFailWithError");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)localSearchBar {
    NSLog (@"searchBarSearchButtonClicked");
    
    // Construct the URL to call
    // Note that you have to add percent escapes to the string to pass it
    // via a URL
    NSString *urlString = [NSString
                           stringWithFormat:
                           @"http://local.yahooapis.com/LocalSearchService/V3/localSearch?"
                           "appid=bQmVtAzV34HcazY4HD6sdRKysT0AG5XrdP.MrIIsrEWNLzqzQUBqSeo4cZGtPg4FLgLTUiU0KwCHJ4bw7ShrI7mLSYmq4Uc-"
                           "&query=%@&latitude=%f&longitude=%f",
                           [localSearchBar.text
                            stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                           self.currentLocation.coordinate.latitude,
                           self.currentLocation.coordinate.longitude];
    
    // Log the string that we plan to send
    NSLog (@"sending: %@",urlString);
    
    NSURL *serviceURL = [NSURL
                         URLWithString:urlString];
    
    // Create the Request.
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:serviceURL
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval: 30.0];
    
    // Create the connection and send the request
    NSURLConnection *connection =
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Make sure that the connection is good
    if (connection) {
        // Instantiate the responseData data structure to store to response
        self.responseData = [NSMutableData data];
        
    }
    else {
        NSLog (@"The connection failed");
    }
    
    [localSearchBar resignFirstResponder];
}

// Called when the searchbar text changes
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog (@"textDidChange");
    
    // If the text was cleared, clear the map annotations
    if ([searchText isEqualToString:@""])
    {
        // Clear the annotations
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        // Clear the results array
        [self.results removeAllObjects];
    }
    
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    NSLog (@"connection:didReceiveResponse:");
    
    [self.responseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog (@"connection:didReceiveData:");
    
    // Append the received data to our responseData property
    [self.responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog (@"connectionDidFinishLoading:");
    
    // Convert the data to a string and log the response string
    NSString *responseString = [[NSString alloc]
                                initWithData:self.responseData
                                encoding:NSUTF8StringEncoding];
    NSLog(@"Response String: \n%@", responseString);

    
    [self parseXML];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog (@"connection:didFailWithError:");
    NSLog (@"%@",[error localizedDescription]);
}

- (void) parseXML {
    NSLog (@"parseXML");
    
    // Initialize the parser with our NSData from the RSS feed
    NSXMLParser *xmlParser = [[NSXMLParser alloc]
                              initWithData:self.responseData];
    
    // Set the delegate to self
    [xmlParser setDelegate:self];
    
    // Start the parser
    if (![xmlParser parse])
    {
        NSLog (@"An error occurred in the parsing");
    }
        
    
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict {
    NSLog (@"didStartElement");
    
    // Check to see which element we have found
    if ([elementName isEqualToString:@"Result"]) {
        // Create a new Result object
        self.aResult = [[Result alloc] init];
        
        
    }
    else if ([elementName isEqualToString:@"Title"]||
             [elementName isEqualToString:@"Address"]||
             [elementName isEqualToString:@"City"]||
             [elementName isEqualToString:@"State"]||
             [elementName isEqualToString:@"Phone"]||
             [elementName isEqualToString:@"Latitude"]||
             [elementName isEqualToString:@"Longitude"]||
             [elementName isEqualToString:@"AverageRating"])
        
    {
        // Initialize the capturedCharacters instance variable
        self.capturedCharacters = [[NSMutableString alloc] initWithCapacity:100];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.capturedCharacters != nil) {
        [self.capturedCharacters appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog (@"didEndElement");
    
    // Check to see which element we have ended
    if ([elementName isEqualToString:@"Result"]) {
        
        // Add the result to the array
        [self.results addObject:self.aResult];
        
    }
    else if ([elementName isEqualToString:@"Title"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.title = self.capturedCharacters;
        
    }
    else if ([elementName isEqualToString:@"Address"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.address = self.capturedCharacters;
        
    }
    else if ([elementName isEqualToString:@"City"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.city = self.capturedCharacters;
        
    }
    else if ([elementName isEqualToString:@"State"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.state = self.capturedCharacters;
        
    }
    else if ([elementName isEqualToString:@"Phone"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.phone = self.capturedCharacters;
        
    }
    else if ([elementName isEqualToString:@"Latitude"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.latitude = [self.capturedCharacters doubleValue];
        
    }
    else if ([elementName isEqualToString:@"Longitude"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.longitude = [self.capturedCharacters doubleValue];
        
    }
    else if ([elementName isEqualToString:@"AverageRating"] && self.aResult!=nil) {
        // Set the appropriate property
        self.aResult.rating = [self.capturedCharacters floatValue];
    }
    
    
    // So we don't have to release capturedCharacters in every else if block
    if ([elementName isEqualToString:@"Title"]||
        [elementName isEqualToString:@"Address"]||
        [elementName isEqualToString:@"City"]||
        [elementName isEqualToString:@"State"]||
        [elementName isEqualToString:@"Phone"]||
        [elementName isEqualToString:@"Latitude"]||
        [elementName isEqualToString:@"Longitude"]||
        [elementName isEqualToString:@"AverageRating"])
    {
        // clear the capturedCharacters property
        self.capturedCharacters = nil;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog (@"parserDidEndDocument");
    
    
    // Plot the results on the map
    [self plotResults];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    // If we are displaying the user's location, return nil
    //  to use the default view
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Try to dequeue an existing pin
    MKPinAnnotationView *pinAnnotationView =
    (MKPinAnnotationView *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"location"];
    
    if (!pinAnnotationView) {
        // We could not get a pin from the queue
        pinAnnotationView=[[MKPinAnnotationView alloc]
                            initWithAnnotation:annotation
                            reuseIdentifier:@"location"] ;
        
        pinAnnotationView.animatesDrop=TRUE;
        pinAnnotationView.canShowCallout = YES;
        
    }
    
    // We need to get the rating from the annotation object
    //  to color the pin based on rating
    Result *resultAnnotation = (Result*) annotation;
    
    if (resultAnnotation.rating > 4.5) {
        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    }
    else if (resultAnnotation.rating > 3.5) {
        pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    else {
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    
    return pinAnnotationView;
    
}

- (void) plotResults {
    
    // Annotate the result
    [self.mapView addAnnotations:self.results];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
