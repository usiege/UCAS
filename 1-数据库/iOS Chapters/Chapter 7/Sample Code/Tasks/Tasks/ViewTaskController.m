//
//  ViewTaskController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/14/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "ViewTaskController.h"
#import "EditTextViewController.h"
#import "EditPriorityViewController.h"
#import "EditLocationViewController.h"
#import "EditDateViewController.h"
#import "AppDelegate.h"

@interface ViewTaskController ()

@end

@implementation ViewTaskController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Task Detail";

    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Reload the data for the table to refresh from the context
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    if (self.managedTaskObject) {
        // Set Task Text
        self.taskText.text = self.managedTaskObject.text;
        
        // Set Priority Text
        // Get the priority number and convert it to a string
        NSString* priorityString=nil;
        
        switch ([self.managedTaskObject.priority intValue]) {
            case 0:
                priorityString = @"None";
                break;
            case 1:
                priorityString = @"Low";
                break;
            case 2:
                priorityString = @"Medium";
                break;
            case 3:
                priorityString = @"High";
                break;
            default:
                break;
        }
        self.taskPriority.text = priorityString;
        
        // Set Due Date text
        //  Create a date formatter to format the date from the picker
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterLongStyle];
        self.taskDueDate.text = [df stringFromDate:self.managedTaskObject.dueDate ];

        // Set Location text
        Location* locationObject = self.managedTaskObject.location;
        if (locationObject!=nil)
        {
            self.taskLocation.text = locationObject.name;
        }
        else {
            self.taskLocation.text = @"Not Set";
            
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEditTextViewController"]) {
        EditTextViewController* EditTextViewController = [segue destinationViewController];
        EditTextViewController.managedObjectContext = self.managedObjectContext;
        EditTextViewController.managedObject=self.managedTaskObject;
        EditTextViewController.keyString=@"text";
    }
    else if ([[segue identifier] isEqualToString:@"showEditPriorityViewController"]) {
        EditPriorityViewController* editPriorityViewController = [segue destinationViewController];
        editPriorityViewController.managedObjectContext = self.managedObjectContext;
        editPriorityViewController.managedTaskObject=self.managedTaskObject;
    }
    else if ([[segue identifier] isEqualToString:@"showEditLocationViewController"]) {
        EditLocationViewController* editLocationViewController = [segue destinationViewController];
        editLocationViewController.managedObjectContext = self.managedObjectContext;
        editLocationViewController.managedTaskObject=self.managedTaskObject;
    }
    else if ([[segue identifier] isEqualToString:@"showEditDateViewController"]) {
        EditDateViewController* editDateViewController = [segue destinationViewController];
        editDateViewController.managedObjectContext = self.managedObjectContext;
        editDateViewController.managedTaskObject=self.managedTaskObject;
    }
    
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  Deselect the currently selected row according to the HIG
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //  Based on the selected row take some action
    if (indexPath.row==4)
    {
        
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle:@"Hi-Pri Tasks"
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil  ];
        
        // Use Fetched property to get a list of high-pri tasks
        NSArray* highPriTasks = self.managedTaskObject.highPriTasks;
        NSMutableString* alertMessage =
        [[NSMutableString alloc] init];
        
        // Loop through each hi-pri task to create the string for
        // the message
        for (Task * theTask in highPriTasks)
        {
            [alertMessage appendString:theTask.text];
            [alertMessage appendString:@"\n"];
        }
        
        alert.message = alertMessage;
        [alert show];
    }
    else if (indexPath.row==5)
    {
        
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle:@"Tasks due sooner"
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil  ];
        NSMutableString* alertMessage =
        [[NSMutableString alloc] init];
        
        // need to get a handle to the managedObjectModel to use the stored
        // fetch request
        AppDelegate* appDelegate =
        [UIApplication sharedApplication].delegate;
        NSManagedObjectModel* model = appDelegate.managedObjectModel;
        
        // Get the stored fetch request
        NSDictionary* dict =
        [[NSDictionary alloc]
         initWithObjectsAndKeys:self.managedTaskObject.dueDate,
         @"DUE_DATE",nil];
        
        NSFetchRequest* request =
        [model fetchRequestFromTemplateWithName:@"tasksDueSooner"
                          substitutionVariables:dict];
        
        NSError* error;
        NSArray* results =
        [self.managedObjectContext executeFetchRequest:request error:&error];
        
        // Loop through eachtask to create the string for the message
        for (Task * theTask in results)
        {
            [alertMessage appendString:theTask.text];
            [alertMessage appendString:@"\n"];
        }
        
        alert.message = alertMessage;
        [alert show];
        
    }
    
}


@end
