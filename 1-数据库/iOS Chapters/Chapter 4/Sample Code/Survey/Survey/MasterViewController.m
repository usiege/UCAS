//
//  MasterViewController.m
//  Survey
//
//  Created by Patrick Alessi on 9/25/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)
        [[self.splitViewController.viewControllers lastObject]
         topViewController];
    
    
    // Get an array of paths. (This function is carried over from the desktop)
    NSArray *documentDirectoryPath =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *docDir = [NSString stringWithFormat:@"%@/serialized.xml",
                        [documentDirectoryPath objectAtIndex:0]];
    NSData* serializedData = [NSData dataWithContentsOfFile:docDir];
    
    // If serializedData is nil, the file doesn't exist yet
    if (serializedData == nil)
    {
        self.surveyDataArray = [[NSMutableArray alloc] init];

    }
    else
    {
        // Read data from the file
        NSString *error;
        
        self.surveyDataArray =
        (NSMutableArray *)[NSPropertyListSerialization
                           propertyListFromData:serializedData
                           mutabilityOption:kCFPropertyListMutableContainers
                           format:NULL errorDescription:&error];
    }

    // Initialize the current index
    currentIndex = 0;

}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or
    // on demand.
    // For example: self.myOutlet = nil;
    self.surveyDataArray = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.surveyDataArray count];
}
    

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                        forIndexPath:indexPath];

    // Configure the cell.
    NSDictionary* sd = [self.surveyDataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",
                           [sd objectForKey:@"lastName"],
                           [sd objectForKey:@"firstName"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     When a row is selected, set the detail View Controller's detail item to the
     item associated with the selected row.
     */
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* sd = [self.surveyDataArray objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = sd;
    
    // Set the currentIndex
    currentIndex = indexPath.row;

}

-(void) addSurveyToDataArray: (NSDictionary*) sd
{
    NSLog (@"addSurveyToDataArray");
    
    // Add the survey to the results array
    [self.surveyDataArray addObject:sd];
    
    // Refresh the tableview
    [self.tableView reloadData];
}

-(void) moveNext
{
    NSLog (@"moveNext");
    // Check to make sure that there is a next item to move to
    if (currentIndex < (int)[self.surveyDataArray count] -1)
    {
        NSDictionary* sd = [self.surveyDataArray objectAtIndex:++currentIndex];
        self.detailViewController.detailItem = sd;
    }
}

-(void) movePrevious
{
    NSLog (@"movePrevious");
    // Check to make sure that there is a previous item to move to
    if (currentIndex > 0)
    {
        
        NSDictionary* sd = [self.surveyDataArray objectAtIndex:--currentIndex];
        self.detailViewController.detailItem = sd;
    }
    
}


@end
