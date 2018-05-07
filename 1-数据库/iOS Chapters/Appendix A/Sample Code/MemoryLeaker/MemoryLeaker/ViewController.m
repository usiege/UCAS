//
//  ViewController.m
//  MemoryLeaker
//
//  Created by Patrick Alessi on 2/21/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) goPressed:(id) sender
{
    
    NSMutableString *theString = [[NSMutableString alloc] init];
    
    [theString appendString:@"This"] ;
    [theString appendString:@" is"] ;
    [theString appendString:@" a"] ;
    [theString appendString:@" string"] ;
    
    NSLog(@"theString is: %@", theString);
    
    [theString release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
