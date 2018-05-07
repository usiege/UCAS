//
//  Result.h
//  LocationSearch
//
//  Created by Patrick Alessi on 1/23/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Result : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic) double latitude;

@property (nonatomic) double longitude;
@property (nonatomic) float rating;

@end

