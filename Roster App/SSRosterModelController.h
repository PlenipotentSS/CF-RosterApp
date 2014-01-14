//
//  SSRosterModelController.h
//  Roster App
//
//  Created by Stevenson on 1/14/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSStudentObject.h"


@interface SSRosterModelController : NSObject <UITableViewDataSource>

-(SSStudentObject*) getStudentAtIndex: (NSInteger) index;
-(void) sortByName;
-(void) sortByGitHub;

@end
