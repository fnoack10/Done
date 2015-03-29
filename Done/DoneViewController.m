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

// Resources
#import "ItemTableViewCell.h"
#import "Palette.h"


@interface DoneViewController () {
    
    DataManager *dataManager;
    
    NSArray *itemArray;
    
}

@end

@implementation DoneViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self automaticLogin];
    
    dataManager = [DataManager sharedManager];

    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.itemTableView;
    
    [self.itemTableView setDelegate:self];
    [self.itemTableView setDataSource:self];
    [self.itemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshItems)
                  forControlEvents:UIControlEventValueChanged];

    tableViewController.refreshControl = self.refreshControl;
    
    
    
    PFUser *user = [PFUser currentUser];    

    Item *item = [Item object];
    item.name = @"First Item";
    item[@"user"] = user;
    
    [dataManager saveItem:item];
    
    List *list = [List object];
    list.name = @"First List";
    list[@"user"] = user;
    
    [dataManager saveList:list];
    
    [self refreshItems];
    
}


- (void)refreshItems {
    
    [self.refreshControl beginRefreshing];
    
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [Item query];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            itemArray = objects;
            [self.itemTableView reloadData];
            
            if (self.refreshControl) {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, h:mm a"];
                NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[Palette darkGrayColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                self.refreshControl.attributedTitle = attributedTitle;
                
            }
            
        } else {
            
            NSLog(@"ERROR %@", error.description);
            
        }
        
        
        [self.refreshControl endRefreshing];
    }];
    
    
}


#pragma mark - Done Table View Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ItemTableViewCell";
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ItemTableViewCell alloc] init];
    }
    
    Item *item = [itemArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.name;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Login

- (void) automaticLogin {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"CURRENT USER");
    } else {
        
        NSLog(@"NO USER");
        // show the signup or login screen
    }
    
}

- (void) loginWithUser: (NSString *)user andPassword: (NSString *)password {
    
    [PFUser logInWithUsernameInBackground:user
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"LOGIN SUCCESS");
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            NSLog(@"ERROR IN LOGIN");
                                        }
                                    }];
}

- (void)signUp {
    
    PFUser *user = [PFUser user];
    user.username = @"fnoack10@gmail.com";
    user.password = @"123456";
    user.email = @"fnoack10@gmail.com";
    
    // other fields can be set just like with PFObject
    user[@"firstName"] = @"Franco";
    user[@"lastName"] = @"Noack";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
            // GO IN
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"ERROR %@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}


@end
