//
//  MasterViewController.h
//  Catalog_Model
//
//  Created by Patrick Alessi on 10/17/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
