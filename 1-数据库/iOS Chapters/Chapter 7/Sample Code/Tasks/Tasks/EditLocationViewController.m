//
//  EditLocationViewController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "EditLocationViewController.h"
#import "EditTextViewController.h"

@interface EditLocationViewController ()

@end

@implementation EditLocationViewController

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
    
    // Set up the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                        target:self action:@selector(insertNewLocation)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSError* error;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // set the title to display in the nav bar
    self.title = @"Location";
    
}

- (void)insertNewLocation {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    Location *newLocation =
    [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                  inManagedObjectContext:context];
    
    UIStoryboard *sb = [UIStoryboard
                        storyboardWithName:@"MainStoryboard" bundle:nil];
    
    EditTextViewController* textController =
    [sb instantiateViewControllerWithIdentifier:@"EditTextViewController"];

    
    textController.managedObject=newLocation;
    textController.managedObjectContext = self.managedObjectContext;
    textController.keyString=@"name";
    
    [self.navigationController pushViewController:textController animated:YES];
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity =
    [NSEntityDescription
     entityForName:@"Location"
     inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc]
     initWithKey:@"name"
     ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:self.managedObjectContext
     sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
        
    return _fetchedResultsController;
}

// NSFetchedResultsControllerDelegate method to notify the delegate
// that all section and object changes have been processed.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
    }
    
    Location *managedLocationObject =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // If the location in the task object is the same as the location object
    // draw the checkmark
    if (self.managedTaskObject.location == managedLocationObject)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    
    cell.textLabel.text = managedLocationObject.name;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context =
        [self.fetchedResultsController managedObjectContext];
        
        [context deleteObject:[self.fetchedResultsController
                               objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  Deselect the currently selected row according to the HIG
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // set the Task's location to the chosen location
    Location *newLocationObject =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    self.managedTaskObject.location=newLocationObject;
    
    // Save the context.
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    else {
        
        // pop the view
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
