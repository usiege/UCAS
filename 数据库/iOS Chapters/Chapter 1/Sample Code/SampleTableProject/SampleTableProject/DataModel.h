//
//  DataModel.h
//  SampleTableProject
//
//  Created by Patrick Alessi on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
-(NSString*) getNameAtIndex:(int) index;
-(int) getRowCount;

@end
