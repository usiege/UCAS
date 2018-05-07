//
//  EditDateViewController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditDateViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) Task* managedTaskObject;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, retain) IBOutlet UITableView* tv;

-(IBAction)dateChanged:(id)sender;

@end
