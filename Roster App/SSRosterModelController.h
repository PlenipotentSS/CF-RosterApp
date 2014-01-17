//
//  SSRosterModelController.h
//  Roster App
//
//  Created by Stevenson on 1/14/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSStudent.h"


@interface SSRosterModelController : NSObject <UITableViewDataSource>



-(SSStudent*) getStudentAtIndex: (NSInteger) index;
-(NSArray*) getStudentData;
-(SSStudent*) getInstructorAtIndex: (NSInteger) index;
-(NSArray*) getInstructorData;

-(void) sortByName;
-(void) sortByGitHub;
-(void) archiveBootCamp;
@end
