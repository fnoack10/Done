//
//  ShareViewController.m
//  Done
//
//  Created by Franco Noack on 4/12/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "ShareViewController.h"

// Table View Cell
#import "FriendTableViewCell.h"

// Resources
#import "Palette.h"

@interface ShareViewController (){
    
    DataManager *dataManager;
    
    NSArray *friendsArray;
    
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [dataManager loadFriends];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateData" object:nil];
    
    [self initializeTableView];
    
    // Do any additional setup after loading the view.
}

- (void) updateTable {
    
    friendsArray = dataManager.friendsArray;
    
    NSLog(@"update tabel");
    
    [self updateRefreshControl];
    
    [self.shareTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
    tableViewController.tableView = self.shareTableView;
    
    [self.shareTableView setDelegate:self];
    [self.shareTableView setDataSource:self];
    [self.shareTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
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
    
    [cell.iconView.layer setCornerRadius:20.0];
    
    PFUser *user = [friendsArray objectAtIndex:indexPath.row];
    
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.iconLabel.text = [NSString stringWithFormat:@"%@%@", [[firstName substringToIndex:1] uppercaseString], [[lastName substringToIndex:1] uppercaseString]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [friendsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //[dataManager addFriend:[friendsArray objectAtIndex:indexPath.row] ToList:list];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
