//
//  ViewController.m
//  Umpire
//
//  Created by Patrick Alessi on 11/28/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    Counter *theCounter = [[Counter alloc] init];
    
    self.umpireCounter = theCounter;
    
    // Set up KVO for the umpire counter
    [self.umpireCounter addObserver:self
                         forKeyPath:@"balls"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    [self.umpireCounter addObserver:self
                         forKeyPath:@"strikes"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    [self.umpireCounter addObserver:self
                         forKeyPath:@"outs"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    //  change gives back an NSDictionary of changes
    NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
    
    // update the appropriate label
    if (keyPath == @"balls") {
        self.ballLabel.text = [newValue stringValue];
    }
    else if (keyPath == @"strikes") {
        self.strikeLabel.text = [newValue stringValue];
    }
    else if (keyPath == @"outs") {
        self.outLabel.text = [newValue stringValue];
    }
}

- (void)dealloc {
    // Tear down KVO for the umpire counter
    [self.umpireCounter removeObserver:self
                            forKeyPath:@"balls"];
    
    [self.umpireCounter removeObserver:self
                            forKeyPath:@"strikes" ];
    
    [self.umpireCounter removeObserver:self
                            forKeyPath:@"outs" ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonTapped:(id)sender {
    
    UIButton *theButton = sender;
    NSNumber *value = [self.umpireCounter valueForKey:theButton.currentTitle];
    
    NSNumber* newValue;
    
    // Depending on the button and the value, set the new value accordingly
    if ([theButton.currentTitle compare:@"balls"] == NSOrderedSame &&
        [value intValue] == 3) {
        
        newValue = [NSNumber numberWithInt:0];
    }
    else if (([theButton.currentTitle compare:@"strikes"] == NSOrderedSame ||
              [theButton.currentTitle compare:@"outs"] == NSOrderedSame )&&
             [value intValue] == 2) {
        
        newValue = [NSNumber numberWithInt:0];
    }
    else
    {
        newValue = [NSNumber numberWithInt:[value intValue]+1];
    }
    
    [self.umpireCounter setValue:newValue forKey:theButton.currentTitle];
}

@end
