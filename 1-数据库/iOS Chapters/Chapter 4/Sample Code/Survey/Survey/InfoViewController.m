//
//  InfoViewController.m
//  Survey
//
//  Created by Patrick Alessi on 9/26/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
	
    CGSize size;
    size.width=420;
    size.height = 175;
    self.contentSizeForViewInPopover = size;
    
    self.infoLabel.text=self.displayText;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.infoLabel = nil;
    self.displayText = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
