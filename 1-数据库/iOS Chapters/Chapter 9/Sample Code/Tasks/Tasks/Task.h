//
//  Task.h
//  Tasks
//
//  Created by Patrick Alessi on 11/12/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define TASKS_ERROR_DOMAIN                      @"com.Wrox.Tasks"
#define DUEDATE_VALIDATION_ERROR_CODE           1001
#define PRIORITY_DUEDATE_VALIDATION_ERROR_CODE  1002

@class Location;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isOverdue;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Location *location;

@property (nonatomic,retain) NSArray* highPriTasks;
@property (nonatomic, retain) NSDate * primitiveDueDate;

- (BOOL)validateAllData:(NSError **)error;


@end
