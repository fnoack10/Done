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

#import "Typography.h"

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
    
    [self initializeTableView];
    
    [self automaticLogin];
    

}

- (void) addObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeTableView) name:@"LoginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateData" object:nil];
    
}

- (void) initializeTableView {
    
    [self.view setBackgroundColor:[Palette backgroundGray]];
    
    [self.titleLabel setFont:[Typography lightOpenSans:@"title"]];
    [self.titleLabel setTextColor:[Palette titleGray]];
    
    [self.addListView setBackgroundColor:[Palette backgroundGray]];
    [self.addListLabel setFont:[Typography lightOpenSans:@"button"]];
    [self.addListLabel setTintColor:[Palette whiteColor]];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.listTableView;
    
    [self.listTableView setDelegate:self];
    [self.listTableView setDataSource:self];
    [self.listTableView setSeparatorColor:[Palette backgroundGray]];
    [self.listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(addNewList)
                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
}

#pragma mark - Login

- (void) automaticLogin {
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        
        if (!dataManager.listArray) {
            
            [dataManager loadUserData];
            
        } else {
            
            [self updateTable];
            
        }
        
    } else {
        
        [self presentLoginViewController];
        
    }
    
}

- (void) addNewList {
    
    [self performSegueWithIdentifier:@"AddListSegue" sender:nil];
    
    [self.refreshControl endRefreshing];
    
    //[dataManager loadUserData];
    
}

- (void) updateTable {
    
    [self.refreshControl beginRefreshing];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
//    
//    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[Palette darkGrayColor] forKey:NSForegroundColorAttributeName];
//    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//    
//    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
    
    [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - Done Table View Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ItemTableViewCell";
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Create cell
    
    if (!cell) {
        
        cell = [[ItemTableViewCell alloc] init];
        
    }
    
    // Prepare cell
    
    [cell.titleLabel setFont:[Typography lightOpenSans:@"text"]];
    [cell.countLabel setFont:[Typography lightOpenSans:@"text"]];
    
    [cell.titleLabel setTextColor:[Palette titleGray]];
    [cell.countLabel setTextColor:[Palette textGray]];
    
    [cell.pin.layer setCornerRadius:7.5];
    
    // Set Values
    
    List *list = [dataManager.listArray objectAtIndex:indexPath.row];
    NSArray *itemsInList = [dataManager.itemsInListArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = list.name;
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[itemsInList count]];

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    List *list = [dataManager.listArray objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [dataManager deleteList:list];
        
    }
    
}

#pragma mark - Other Controllers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ListViewSegue"]) {
        
        NSIndexPath * index = (NSIndexPath *)sender;
        
        ListViewController *listViewController = [segue destinationViewController];
        listViewController.list = [dataManager.listArray objectAtIndex:index.row];
        
    }

    
}

- (void) presentLoginViewController {
    
    // TODO -  Implement for Logout Event
    
    LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self addChildViewController:loginController];
    
    [self.view insertSubview:loginController.view aboveSubview:self.view];
    [loginController didMoveToParentViewController:self];
    
}



@end
