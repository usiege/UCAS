//
//  EditDateViewController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "EditDateViewController.h"

@interface EditDateViewController ()

@end

@implementation EditDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the save button
    UIBarButtonItem* saveButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
     target:self
     action:@selector (saveButtonPressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Set the date to the one in the managed object, if it is set
    // else, set it to today
    NSDate* objectDate = self.managedTaskObject.dueDate;
    if (objectDate!=nil)
    {
        self.datePicker.date = objectDate;
    }
    else {
        self.datePicker.date = [NSDate date];
    }

}

-(void) saveButtonPressed: (id) sender
{
    
    // Configure the managed object
    self.managedTaskObject.dueDate=[self.datePicker date];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // There was an error validating the date
        // Display error information
        UIAlertView* alert =
        [[UIAlertView alloc]
         initWithTitle:@"Invalid Due Date"
         message:[[error userInfo] valueForKey:@"ErrorString"]
         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        
        // Roll back the context to
        // revert back to the original date
        [self.managedObjectContext rollback];
        
    }
    else{
        // pop the view
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)dateChanged:(id)sender{
    //  Refresh the date display
    [self.tv reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =
        [[UITableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
          reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    if (indexPath.row == 0)
    {
        //  Create a date formatter to format the date from the picker
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterLongStyle];
        cell.textLabel.text = [df stringFromDate:self.datePicker.date ];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
