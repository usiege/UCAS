//
//  DataModel.m
//  SampleTableProject
//
//  Created by Patrick Alessi on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"
NSArray* myData;

@implementation DataModel

-(id)init
{
    if (self = [super init])
    {
        // Initialization code
        myData = [[NSArray alloc] initWithObjects:@"Albert", @"Bill", @"Chuck",
                  @"Dave", @"Ethan", @"Franny", @"George", @"Holly", @"Inez",
                  nil];
    }
    return self;
}

-(NSString*) getNameAtIndex:(int) index
{
    return (NSString*)[myData objectAtIndex:index];
}

-(int) getRowCount
{
    return [myData count];
}



@end
