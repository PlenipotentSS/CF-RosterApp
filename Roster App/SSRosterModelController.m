//
//  SSRosterModelController.m
//  Roster App
//
//  Created by Stevenson on 1/14/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSRosterModelController.h"
#import "SSRosterTableViewCell.h"

@interface SSRosterModelController()

@property (nonatomic) BOOL isAsc;

@property (nonatomic) NSMutableArray *studentData;
@property (nonatomic) NSMutableArray *instructorData;

@end

@implementation SSRosterModelController

-(instancetype) init {
    self = [super self];
    if (self) {
        NSURL *archiveURL = [[self documentDir] URLByAppendingPathComponent:@"SavedStudents"];;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[archiveURL path] isDirectory:NO]) {
            [self loadPlist];
        } else {
            [self unarchiveBootCamp];
        }
    }
    return self;
}



#pragma mark - Sorting methods
-(void) sortByName {
    NSArray* sortedStudents;
    NSArray* sortedInstructors;
    if (!self.isAsc) {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
                return [[(SSStudent*)student1  name] compare: [(SSStudent*)student2  name]];
        }];
        sortedInstructors = [(NSArray*)self.instructorData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student1  name] compare: [(SSStudent*)student2  name]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  name] compare: [(SSStudent*)student1  name]];
        }];
        sortedInstructors = [(NSArray*)self.instructorData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  name] compare: [(SSStudent*)student1  name]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
    self.instructorData = [sortedInstructors mutableCopy];
}

-(void) sortByGitHub {
    NSArray* sortedStudents;
    NSArray* sortedInstructors;
    if (!self.isAsc) {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student1  gitHub] compare: [(SSStudent*)student2  gitHub]];
        }];
        sortedInstructors = [(NSArray*)self.instructorData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student1  name] compare: [(SSStudent*)student2  name]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  gitHub] compare: [(SSStudent*)student1  gitHub]];
        }];
        sortedInstructors = [(NSArray*)self.instructorData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  name] compare: [(SSStudent*)student1  name]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
    self.instructorData = [sortedInstructors mutableCopy];
    
}

#pragma mark - 
-(NSArray*) getStudentData {
    return (NSArray*)self.studentData;
}

-(NSArray*) getInstructorData {
    return (NSArray*)self.instructorData;
}

-(NSURL *)documentDir {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) loadPlist {
    //make plist in documents and only load if does not exist
    NSString *pListFilePath = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
    NSArray *pListArray = [[NSArray alloc] initWithContentsOfFile:pListFilePath];
    [self parseBootcamp:pListArray];
    [self archiveBootCamp];
}

-(void) parseBootcamp: (NSArray*) students {
    self.studentData = [[NSMutableArray alloc] init];
    self.instructorData = [[NSMutableArray alloc] init];
    for (NSDictionary *student in students) {
        SSStudent *thisStudent = [[SSStudent alloc] initWithName:[student objectForKey:@"name"]
                                                        andImage:[student objectForKey:@"image"]
                                                      andTwitter:[student objectForKey:@"twitter"]
                                                       andGitHub:[student objectForKey:@"github"]
                                                    isInstructor:[student objectForKey:@"instructor"]];
        if ([student objectForKey:@"instructor"] && ![[student objectForKey:@"instructor"] isEqualToString:@""]) {
            [self.instructorData addObject:thisStudent];
        } else {
            [self.studentData addObject:thisStudent];
        }

    }
}

-(void) archiveBootCamp {
    NSURL *archiveURL = [[self documentDir] URLByAppendingPathComponent:@"SavedStudents"];;
    [NSKeyedArchiver archiveRootObject:self.studentData toFile:[archiveURL path]];
    NSURL *archiveInstructorsURL = [[self documentDir] URLByAppendingPathComponent:@"SavedInstructors"];;
    [NSKeyedArchiver archiveRootObject:self.instructorData toFile:[archiveInstructorsURL path]];
}

-(void) unarchiveBootCamp {
    NSURL *archiveURL = [[self documentDir] URLByAppendingPathComponent:@"SavedStudents"];;
    self.studentData = [NSKeyedUnarchiver unarchiveObjectWithFile:[archiveURL path]];
    NSURL *archiveInstructorsURL = [[self documentDir] URLByAppendingPathComponent:@"SavedInstructors"];;
    self.instructorData = [NSKeyedUnarchiver unarchiveObjectWithFile:[archiveInstructorsURL path]];
}

-(SSStudent*) getStudentAtIndex: (NSInteger) index {
    return [self.studentData objectAtIndex:index];
}

-(SSStudent*) getInstructorAtIndex: (NSInteger) index {
    return [self.instructorData objectAtIndex:index];
}

#pragma mark UITableViewDataSource
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Instructors";
    } else if (section == 1) {
        return @"Students";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [self.instructorData count];
    else if (section == 1)
        return [self.studentData count];
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.instructorData && [self.instructorData count] > 0) {
        return 2;
    } else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"theCell";
    SSRosterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0 ) {
        SSStudent *thisStudent = [self.instructorData objectAtIndex:indexPath.row];
        [cell setStudent:thisStudent];
    } else if (indexPath.section == 1 ) {
        SSStudent *thisStudent = [self.studentData objectAtIndex:indexPath.row];
        [cell setStudent:thisStudent];
    }

    
    return cell;
}

@end
