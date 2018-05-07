//
//  ViewController.h
//  Umpire
//
//  Created by Patrick Alessi on 11/28/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Counter.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ballLabel;
@property (weak, nonatomic) IBOutlet UILabel *strikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (nonatomic, retain) Counter* umpireCounter;

- (IBAction)buttonTapped:(id)sender;

@end
