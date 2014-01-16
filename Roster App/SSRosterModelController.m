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
                return [[(SSStudent*)student1  name] compare: [(SSStudent*)student2  name]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  name] compare: [(SSStudent*)student1  name]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
}

-(void) sortByGitHub {
    NSArray* sortedStudents;
    if (!self.isAsc) {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student1  gitHub] compare: [(SSStudent*)student2  gitHub]];
        }];
        self.isAsc = YES;
    } else {
        sortedStudents = [(NSArray*)self.studentData sortedArrayUsingComparator:^(id student1, id student2) {
            return [[(SSStudent*)student2  gitHub] compare: [(SSStudent*)student1  gitHub]];
        }];
        self.isAsc = NO;
    }
    self.studentData = [sortedStudents mutableCopy];
    
}

#pragma mark - 
-(NSArray*) getStudentData {
    return (NSArray*)self.studentData;
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
    for (NSDictionary *student in students) {
        SSStudent *thisStudent = [[SSStudent alloc] initWithName:[student objectForKey:@"name"]
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

-(SSStudent*) getStudentAtIndex: (NSInteger) index {
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
    SSStudent *thisStudent = [self.studentData objectAtIndex:indexPath.row];
    
    if (![[thisStudent image] isEqualToString:@""]) {
        NSString *studentImagePath = [thisStudent image];
        UIImage *studentImage = [UIImage imageWithContentsOfFile:studentImagePath];
        cell.imageView.image = studentImage;
        
        
        cell.imageView.layer.cornerRadius = cell.imageView.layer.bounds.size.height/2;
        cell.imageView.layer.masksToBounds = YES;
    } else {
        cell.imageView.image = nil;
    }
    UIView *topPaddingView = [[UIView alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.x, cell.bounds.size.width, 5)];
    topPaddingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomPaddingView = [[UIView alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.frame.size.height-5, cell.bounds.size.width, 5)];
    bottomPaddingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell insertSubview:topPaddingView belowSubview:cell.imageView];
    [cell insertSubview:bottomPaddingView belowSubview:cell.imageView];

    cell.backgroundColor = [UIColor colorWithRed:([[[thisStudent RGB] objectAtIndex:0] floatValue])
                                           green:([[[thisStudent RGB] objectAtIndex:1] floatValue])
                                            blue:([[[thisStudent RGB] objectAtIndex:2] floatValue])
                                           alpha:1];
    
    cell.textLabel.text = [thisStudent name];
    cell.detailTextLabel.text = [thisStudent gitHub];
    UIColor *textColor = [UIColor colorWithRed:(1-[[[thisStudent RGB] objectAtIndex:0] floatValue])
                                         green:(1-[[[thisStudent RGB] objectAtIndex:1] floatValue])
                                          blue:(1-[[[thisStudent RGB] objectAtIndex:2] floatValue])
                                         alpha:1];
    cell.textLabel.textColor = textColor;
    cell.detailTextLabel.textColor = textColor;
    return cell;
}

@end
