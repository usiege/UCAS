//
//  DetailViewController.m
//  Survey
//
//  Created by Patrick Alessi on 9/25/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        // Update the user interface for the detail item.
        self.firstNameTextField.text = [self.detailItem
                                        objectForKey:@"firstName"];
        self.lastNameTextField.text = [self.detailItem
                                       objectForKey:@"lastName"];
        self.addressTextField.text = [self.detailItem
                                      objectForKey:@"address"];
        self.phoneTextField.text = [self.detailItem
                                    objectForKey:@"phone"];
        self.ageTextField.text = [[self.detailItem
                                   objectForKey:@"age"] stringValue];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.firstNameTextField = nil;
    self.lastNameTextField = nil;
    self.addressTextField = nil;
    self.phoneTextField = nil;
    self.ageTextField = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Action Methods
-(IBAction)clearSurvey:(id)sender
{
    NSLog (@"clearSurvey");
    // Update the user interface for the detail item.
    self.firstNameTextField.text = @"";
    self.lastNameTextField.text = @"";
    self.addressTextField.text = @"";
    self.phoneTextField.text = @"";
    self.ageTextField.text = @"";
}


-(IBAction)addSurvey:(id)sender
{
    NSLog (@"addSurvey");
    
    // Create a new NSDictionary object to add to the results array of the root
    // View Controller
    
    // Set the values for the fields in the new object from the text fields of
    // the form
    
    NSArray *keys = [NSArray arrayWithObjects:@"firstName", @"lastName",
                     @"address", @"phone", @"age", nil];
    NSArray *objects = [NSArray arrayWithObjects:self.firstNameTextField.text,
                        self.lastNameTextField.text,
                        self.addressTextField.text,
                        self.phoneTextField.text,
                        [NSNumber
                         numberWithInteger:[ self.ageTextField.text intValue]],
                        nil];
    
    NSDictionary* sData = [[NSDictionary alloc]
                           initWithObjects:objects forKeys:keys];
    
    // Get a reference to the first navigation controller in the split view
    UINavigationController* nav = [self.splitViewController.viewControllers
                                   objectAtIndex:0];
    
    // Use this to get a reference to the MasterViewController
    MasterViewController* rvc = (MasterViewController*) nav.topViewController ;
    
    // Call the addSurveyToDataArray method on the MasterViewController to
    // add the survey data to the list
    [rvc addSurveyToDataArray:sData];
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"InfoViewControllerSegue"])
    {
        InfoViewController *ivc = segue.destinationViewController;
        ivc.displayText= [NSString stringWithFormat:@"It is now: %@",[NSDate date]];

    }
}


- (IBAction)handleSwipeRight:(id)sender
{
    NSLog (@"handleSwipeRight");

    // Get a reference to the first navigation controller in the split view
    UINavigationController* nav = [self.splitViewController.viewControllers
                                   objectAtIndex:0];
    
    // Use this to get a reference to the MasterViewController
    MasterViewController* rvc = (MasterViewController*) nav.topViewController ;

    
    // Call the movePrevious method on the MasterViewController to move to the
    // previous survey in the list
    [rvc moveNext];
}

- (IBAction)handleSwipeLeft:(id)sender
{
    NSLog (@"handleSwipeLeft");

    // Get a reference to the first navigation controller in the split view
    UINavigationController* nav = [self.splitViewController.viewControllers
                                   objectAtIndex:0];
    
    // Use this to get a reference to the MasterViewController
    MasterViewController* rvc = (MasterViewController*) nav.topViewController ;

    
    // Call the moveNext method on the MasterViewController to move to the
    // next survey in the list
    [rvc movePrevious];
}


@end
