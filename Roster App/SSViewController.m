//
//  SSViewController.m
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSViewController.h"
#import "SSDetailViewController.h"

@interface SSViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (nonatomic, retain) NSAttributedString *attributedTitle;
@property (nonatomic, retain) UIRefreshControl *refreshControl;


@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *instructorArray = [[NSArray alloc] initWithObjects:@"Brad", @"Clem", nil];
    NSArray *studentArray = [[NSArray alloc] initWithObjects:@"Nicholas Bardnard",
                             @"Zuri Biringer",
                             @"Chad Colby",
                             @"Spencer Fornaciari",
                             @"Raghav Haren",
                             @"Timothy Hise",
                             @"Ivan Lesko",
                             @"Richard Lichkus",
                             @"Bennet Lin",
                             @"Christopher Meehan",
                             @"Matt Remick",
                             @"Andrew Rodgers",
                             @"Jeff Schwab",
                             @"Steven Stevenson",
                             @"Yair Szarf",
                             nil];
    
    self.dataDict = [[NSMutableDictionary alloc] init];
    for (NSInteger j=0; j<[instructorArray count];j++ ) {
        
        NSMutableArray *studentsForInstructor = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[studentArray count];i++ ) {
            if ( i < [studentArray count]/2 && j == 0) {
                [studentsForInstructor addObject:[studentArray objectAtIndex:i]];
            } else if ( j == 1) {
                if (i >= [studentArray count]/2) {
                    [studentsForInstructor addObject:[studentArray objectAtIndex:i]];
                }
            } else {
                break;
            }
        }
        [self.dataDict setObject:studentsForInstructor forKey:[instructorArray objectAtIndex:j]];
    }
    
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.theTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void) refreshTable {
    [self performSelector:@selector(disableRefreshControl) withObject:Nil afterDelay:1];
}

-(void) disableRefreshControl {
    [self.refreshControl endRefreshing];
}

#pragma mark UITableViewDelegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.theTableView indexPathForSelectedRow];
        NSString *thisSectionName = [[self.dataDict allKeys] objectAtIndex:indexPath.section];
        NSString *name = [[self.dataDict objectForKey:thisSectionName] objectAtIndex:indexPath.row];
        [(SSDetailViewController*)segue.destinationViewController setName:name];
        [(SSDetailViewController*)segue.destinationViewController setInstructor:thisSectionName];
        [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.dataDict allKeys] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataDict allKeys] objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *thisSectionName =[[self.dataDict allKeys] objectAtIndex:section];
    return [[self.dataDict objectForKey:thisSectionName] count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"theCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *thisSectionName = [[self.dataDict allKeys] objectAtIndex:indexPath.section];
    cell.textLabel.text = [[self.dataDict objectForKey:thisSectionName] objectAtIndex:indexPath.row];
    return cell;
}

@end
