//
//  InfoViewController.h
//  Survey
//
//  Created by Patrick Alessi on 9/26/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel* infoLabel;
@property (nonatomic, strong) NSString* displayText;

@end
