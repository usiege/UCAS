//
//  EditPriorityViewController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/15/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "EditPriorityViewController.h"

@interface EditPriorityViewController ()

@end

@implementation EditPriorityViewController

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

        switch ([self.managedTaskObject.priority intValue]) {
            case 0:
                self.priNone.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            case 1:
                self.priLow.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            case 2:
                self.priMedium.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            case 3:
                self.priHigh.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            default:
                break;
 
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Deselect the currently selected row according to the HIG
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Configure the managed object
    self.managedTaskObject.priority=[NSNumber numberWithInt:indexPath.row];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // There was an error validating the date
        // Display error information
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"Invalid Due Date"
                message:[[error userInfo] valueForKey:@"ErrorString"]
                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        
        // Roll back the context to
        // revert back to the old priority
        [self.managedObjectContext rollback];
        
        
    }
    else {
        // pop the view
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
@end
