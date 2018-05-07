//
//  RandomOperation.h
//  RandomNumbers
//
//  Created by Patrick Alessi on 12/12/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomOperation : NSOperation

@property (nonatomic,assign) NSPersistentStoreCoordinator *coordinator;


-(id) initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)coord;

@end
