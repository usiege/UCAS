//
//  MasterViewController.h
//  Survey
//
//  Created by Patrick Alessi on 9/25/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    int currentIndex;

}
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray* surveyDataArray;

-(void) addSurveyToDataArray: (NSDictionary*) sd;

-(void) moveNext;
-(void) movePrevious;

@end
