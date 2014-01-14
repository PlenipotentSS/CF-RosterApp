//
//  SSRosterModelController.m
//  Roster App
//
//  Created by Stevenson on 1/14/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSRosterModelController.h"

@interface SSRosterModelController()

@property (nonatomic) BOOL isAsc;

@property (nonatomic) NSMutableArray *studentData;

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
    if (!self.isAsc) {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
                return [[(SSStudentObject*)student1  name] compare: [(SSStudentObject*)student2  name]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudentObject*)student2  name] compare: [(SSStudentObject*)student1  name]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
}

-(void) sortByGitHub {
    NSArray* sortedStudents;
    if (!self.isAsc) {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudentObject*)student1  gitHub] compare: [(SSStudentObject*)student2  gitHub]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudentObject*)student2  gitHub] compare: [(SSStudentObject*)student1  gitHub]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
}

#pragma mark - 
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
    for (NSDictionary *student in students) {
        SSStudentObject *thisStudent = [[SSStudentObject alloc] initWithName:[student objectForKey:@"name"]
                                                                    andImage:[student objectForKey:@"image"]
                                                                  andTwitter:[student objectForKey:@"twitter"]
                                                                   andGitHub:[student objectForKey:@"github"]];
        [self.studentData addObject:thisStudent];
    }
}

-(void) archiveBootCamp {
    NSURL *archiveURL = [[self documentDir] URLByAppendingPathComponent:@"SavedStudents"];;
    [NSKeyedArchiver archiveRootObject:self.studentData toFile:[archiveURL path]];
}

-(void) unarchiveBootCamp {
    NSURL *archiveURL = [[self documentDir] URLByAppendingPathComponent:@"SavedStudents"];;
    self.studentData = [[NSKeyedUnarchiver unarchiveObjectWithFile:[archiveURL path]] mutableCopy];
}

-(SSStudentObject*) getStudentAtIndex: (NSInteger) index {
    return [self.studentData objectAtIndex:index];
}

#pragma mark UITableViewDataSource
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Students";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.studentData count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"theCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    SSStudentObject *thisStudent = [self.studentData objectAtIndex:indexPath.row];
    cell.textLabel.text = [thisStudent name];
    cell.detailTextLabel.text = [thisStudent gitHub];
    return cell;
}


@end
