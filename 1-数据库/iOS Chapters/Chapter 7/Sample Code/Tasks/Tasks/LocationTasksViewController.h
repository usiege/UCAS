//
//  LocationTasksViewController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/19/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTasksViewController :
    UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain)
    NSFetchedResultsController *fetchedResultsController;

@end
