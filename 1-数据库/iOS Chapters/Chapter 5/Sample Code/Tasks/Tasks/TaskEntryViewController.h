//
//  TaskEntryViewController.h
//  Tasks
//
//  Created by Patrick Alessi on 10/16/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskEntryViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
