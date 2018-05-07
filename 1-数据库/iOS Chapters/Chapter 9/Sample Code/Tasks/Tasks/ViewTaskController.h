//
//  ViewTaskController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/14/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Location.h"

@interface ViewTaskController : UITableViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Task* managedTaskObject;

@property (weak, nonatomic) IBOutlet UILabel *taskText;
@property (weak, nonatomic) IBOutlet UILabel *taskPriority;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDate;
@property (weak, nonatomic) IBOutlet UILabel *taskLocation;

@end
