//
//  SSRosterViewController.m
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSRosterViewController.h"
#import "SSRosterModelController.h"
#import "SSDetailViewController.h"
#import "SSStudent.h"


@interface SSRosterViewController () <UITableViewDelegate, UIActionSheetDelegate,SSDetailViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSAttributedString *attributedTitle;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic) SSRosterModelController *rosterMC;


@end

@implementation SSRosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rosterMC = [[SSRosterModelController alloc] init];
    self.theTableView.dataSource = self.rosterMC;
    self.theTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.theTableView addSubview:self.refreshControl];

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(showActionSheet)];
    self.navigationItem.rightBarButtonItem = sortButton;
    
    [self.rosterMC archiveBootCamp];
    [self.theTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ActionSheet Sorting
-(void) showActionSheet {
    UIActionSheet *sortSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by" delegate:self cancelButtonTitle:@"Nevermind" destructiveButtonTitle:nil otherButtonTitles:@"Name", @"GitHub", nil];
    [sortSheet showInView:self.view];
}

#pragma mark UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self.rosterMC sortByName];
            [self.theTableView reloadData];
            break;
            
        case 1:
            [self.rosterMC sortByGitHub];
            [self.theTableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark -
-(void) refreshTable {
    [self.theTableView reloadData];
    [self performSelector:@selector(disableRefreshControl) withObject:Nil afterDelay:1];
}

-(void) disableRefreshControl {
    [self.refreshControl endRefreshing];
}

#pragma mark UITableViewDelegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.theTableView indexPathForSelectedRow];
        SSStudent *student = [self.rosterMC getStudentAtIndex: indexPath.row];
        SSDetailViewController *detailView = (SSDetailViewController*)segue.destinationViewController;
        [detailView setStudent:student];
        detailView.delegate = self;
        [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark SSDetailViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) sendStudentObject: (SSStudent*) student {
    NSIndexPath *pathToThisStudent = [NSIndexPath indexPathForRow:[[self.rosterMC getStudentData] indexOfObject:student] inSection:0];
    [self.theTableView reloadRowsAtIndexPaths:@[pathToThisStudent] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
