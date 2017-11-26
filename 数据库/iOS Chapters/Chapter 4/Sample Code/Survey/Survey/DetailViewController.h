//
//  DetailViewController.h
//  Survey
//
//  Created by Patrick Alessi on 9/25/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "InfoViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSDictionary* detailItem;

@property (nonatomic, weak) IBOutlet UITextField* firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField* lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField* addressTextField;
@property (nonatomic, weak) IBOutlet UITextField* phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField* ageTextField;


-(IBAction)clearSurvey:(id)sender;
-(IBAction)addSurvey:(id)sender;

- (IBAction)handleSwipeRight:(id)sender;
- (IBAction)handleSwipeLeft:(id)sender;

@end
