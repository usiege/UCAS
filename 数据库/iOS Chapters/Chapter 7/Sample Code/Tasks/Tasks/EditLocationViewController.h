//
//  EditLocationViewController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Location.h"

@interface EditLocationViewController : UITableViewController
    <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController
    *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Task* managedTaskObject;



@end
