//
//  DoneViewController.m
//  Done
//
//  Created by Franco Noack on 3/29/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "DoneViewController.h"

// Managers
#import "DataManager.h"

// Controllers
#import "LoginViewController.h"
#import "ListViewController.h"

// Resources
#import "ItemTableViewCell.h"
#import "Palette.h"


@interface DoneViewController () {
    
    DataManager *dataManager;
    
}

@end


@implementation DoneViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [self addObservers];
    
    [self automaticLogin];
    
    [self initializeTableView];

}

- (void) addObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeTableView) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateData" object:nil];
    
}

- (void) initializeTableView {
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.listTableView;
    
    [self.listTableView setDelegate:self];
    [self.listTableView setDataSource:self];
    [self.listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
}

- (void) reloadData {
    
    [dataManager loadUserData];
    
}

- (void) updateTable {
    
    [self updateRefreshControl];
    
    [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void) updateRefreshControl {
    
    [self.refreshControl beginRefreshing];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[Palette darkGrayColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
    
}

#pragma mark - Done Table View Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ItemTableViewCell";
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ItemTableViewCell alloc] init];
    }
    
    List *list = [dataManager.listArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = list.name;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataManager.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ListViewSegue" sender:indexPath];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ListViewSegue"]) {
        
        NSIndexPath * index = (NSIndexPath *)sender;
        
        ListViewController *listViewController = [segue destinationViewController];
        listViewController.list = [dataManager.listArray objectAtIndex:index.row];
        
    }
    

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void) presentLoginViewController {
    
    // TODO -  Implement for Logout Event
    
    LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self addChildViewController:loginController];
    
    [self.view insertSubview:loginController.view aboveSubview:self.view];
    [loginController didMoveToParentViewController:self];
    
}

#pragma mark - Login

- (void) automaticLogin {
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        
        NSLog(@"CURRENT USER");
        
        [dataManager loadUserData];
        
    } else {
        
        NSLog(@"NO USER");
        
        [self presentLoginViewController];

    }
    
}

@end
