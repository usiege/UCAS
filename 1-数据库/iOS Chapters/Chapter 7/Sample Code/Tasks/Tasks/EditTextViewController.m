//
//  EditTextViewController.m
//  Tasks
//
//  Created by Patrick Alessi on 11/14/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "EditTextViewController.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController

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
    
    // Add the save button
    UIBarButtonItem* saveButton =[[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector (saveButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
        
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    if (self.managedObject) {
        self.textField.text = [self.managedObject valueForKey:self.keyString];
        self.textField.clearsOnBeginEditing=YES;
    }
}

-(void) saveButtonPressed: (id) sender
{
    
    // Configure the managed object
    // Notice how you use KVC here because you might get a <ic>Task</ic> or a Location
    // in this generic text editor
    [self.managedObject setValue:self.textField.text forKey:self.keyString];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // pop the view
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
