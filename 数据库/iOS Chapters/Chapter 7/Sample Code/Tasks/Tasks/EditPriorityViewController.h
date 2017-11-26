//
//  EditPriorityViewController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/15/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditPriorityViewController : UITableViewController

@property (nonatomic, retain) Task* managedTaskObject;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableViewCell *priNone;
@property (weak, nonatomic) IBOutlet UITableViewCell *priLow;
@property (weak, nonatomic) IBOutlet UITableViewCell *priMedium;
@property (weak, nonatomic) IBOutlet UITableViewCell *priHigh;

@end
