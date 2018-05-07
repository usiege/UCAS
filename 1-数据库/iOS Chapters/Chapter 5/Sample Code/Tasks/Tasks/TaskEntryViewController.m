//
//  TaskEntryViewController.m
//  Tasks
//
//  Created by Patrick Alessi on 10/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "TaskEntryViewController.h"

@interface TaskEntryViewController ()

@end

@implementation TaskEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    
    self.tf = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 20)];
    [self.tf setBackgroundColor:[UIColor lightGrayColor]];
    [self.tf setDelegate:self];
    [self.view addSubview:self.tf];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 60, 20)];
    
    [lbl setText:@"Task:"];
    
    [self.view addSubview:lbl];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Create a new instance of the entity managed by the fetched results
    // controller.
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Task"
                                   inManagedObjectContext:context];
    
    NSManagedObject *newManagedObject =
    [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                  inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:[self.tf text] forKey:@"taskText"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error
         appropriately.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}


@end
