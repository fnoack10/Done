//
//  FriendsViewController.m
//  Done
//
//  Created by Franco Noack on 4/5/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "FriendsViewController.h"

// Table View Cell
#import "FriendTableViewCell.h"

// Resources
#import "Palette.h"

@interface FriendsViewController () {
    
    DataManager *dataManager;
    
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [dataManager loadUsers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateData" object:nil];
    
    [self initializeTableView];
    
    // Do any additional setup after loading the view.
}

- (void) updateTable {
    
    
    
    NSLog(@"update tabel");
    
    [self updateRefreshControl];
    
    [self.friendsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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

- (void) initializeTableView {
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.friendsTableView;
    
    [self.friendsTableView setDelegate:self];
    [self.friendsTableView setDataSource:self];
    [self.friendsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateTable)
                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
}

#pragma mark - Done Table View Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"FriendTableViewCell";
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[FriendTableViewCell alloc] init];
    }
    
    [cell.iconView.layer setCornerRadius:25.0];
    
    PFUser *user = [dataManager.userArray objectAtIndex:indexPath.row];
    
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.iconLabel.text = [NSString stringWithFormat:@"%@%@", [[firstName substringToIndex:1] uppercaseString], [[lastName substringToIndex:1] uppercaseString]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataManager.userArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
