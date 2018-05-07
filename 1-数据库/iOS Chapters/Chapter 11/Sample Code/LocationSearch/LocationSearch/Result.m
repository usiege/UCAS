//
//  Result.m
//  LocationSearch
//
//  Created by Patrick Alessi on 1/23/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import "Result.h"

@implementation Result

-(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D retVal;
    retVal.latitude = self.latitude;
    retVal.longitude = self.longitude;
    
    return retVal;
}

- (NSString *)subtitle {
    NSString *retVal = [[NSString alloc] initWithFormat:@"%@",self.phone];
    
    return retVal;
    
}

@end
