//
//  EditTextController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/13/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "EditTextController.h"

@interface EditTextController ()

@end

@implementation EditTextController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Notice how you use KVC here because you might get a Task or a Location in
    // this generic text editor
    self.taskText.text = [self.managedObject valueForKey:self.keyString];
    self.taskText.clearsOnBeginEditing=YES;
    
    // Add the save button
    UIBarButtonItem* saveButton =[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                        target:self
                        action:@selector (saveButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewDidUnload {
    self.managedObjectContext=nil;
    self.managedObject = nil;
    self.keyString=nil;
    [super viewDidUnload];
}


-(void) saveButtonPressed: (id) sender
{
    
    // Configure the managed object
    // Notice how you use KVC here because you might get a <ic>Task</ic> or a Location
    // in this generic text editor
    [self.managedObject setValue:self.taskText.text forKey:self.keyString];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // pop the view
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Deselect the currently selected row according to the HIG
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
