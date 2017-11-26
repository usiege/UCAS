//
//  RandomOperation.m
//  RandomNumbers
//
//  Created by Patrick Alessi on 12/12/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "RandomOperation.h"

@implementation RandomOperation

-(id) initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)coord
{
    if (self == [super init]) {
        self.coordinator = coord;
    }
    
    return self;
    
}

-(void) main {
    
    // Create a context using the persistent store coordinator
    NSManagedObjectContext *managedObjectContext;
    
    if (self.coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: self.coordinator];
    }
    else {
        return;
    }
    
    // Generate 5 random numbers waiting 1 second between them.
    for (int i=0; i<5; i++){
        NSManagedObject *newManagedObject =
        [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                      inManagedObjectContext:managedObjectContext];
        
        [newManagedObject
         setValue:[NSNumber numberWithInt:1 + arc4random() % 10000]
         
         forKey:@"randomNumber"];
        
        //  Simulate long synchronous blocking call
        sleep(1);
    }
    
    // Save the context.
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

@end
