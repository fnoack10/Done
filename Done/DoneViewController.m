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
    
    int contraintValue;
    
    
    
}

@end


@implementation DoneViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [self addObservers];
    
    [self initializeTableView];
    
    [self automaticLogin];
    
    
    // FIX RECOGNIZER
    
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [panRecognizer setMinimumNumberOfTouches:1];
//    [panRecognizer setMaximumNumberOfTouches:1];
//    [self.listTableView addGestureRecognizer:panRecognizer];
//    

    

}

- (void) addObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeTableView) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"UpdateData" object:nil];
    
}

- (void) initializeTableView {
    
    [self.view setBackgroundColor:[Palette backgroundGray]];

    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.listTableView;
    
    [self.addListButton setTitleColor:[Palette titleGray] forState:UIControlStateNormal];
    
    [self.listTableView setDelegate:self];
    [self.listTableView setDataSource:self];
    [self.listTableView setSeparatorColor:[Palette backgroundGray]];
    [self.listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
}


#pragma mark - Login

- (void) automaticLogin {
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        
        NSLog(@"CURRENT USER");
        
        if (!dataManager.listArray) {
            
            NSLog(@"Load data");
            
            [dataManager loadUserData];
            
        } else {
            
            NSLog(@"just update table");
            
            [self updateTable];
            
        }
        
        
        
    } else {
        
        NSLog(@"NO USER");
        
        [self presentLoginViewController];
        
    }
    
}

- (void) reloadData {
    
    [dataManager loadUserData];
    
}

- (void) updateTable {
    
    
    NSLog(@"update tabel");
    
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


- (NSInteger) countForList: (List *)list {
    
    PFQuery *query = [List query];
    [query fromLocalDatastore];
    [query whereKey:@"list" equalTo:list];
    return [[query findObjects] count];
    
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
    NSArray *itemsInList = [dataManager.itemsInListArray objectAtIndex:indexPath.row];
    
    [cell.pin.layer setCornerRadius:7.5];

    cell.titleLabel.text = list.name;
    [cell.titleLabel setTextColor:[Palette titleGray]];
    
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[itemsInList count]];
    [cell.countLabel setTextColor:[Palette textGray]];

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    List *list = [dataManager.listArray objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [dataManager deleteList:list];
    }
}






// TODO - FIX
//
//
//- (void)handlePan:(UIPanGestureRecognizer *)gesture {
//    
//    NSLog(@"constraint value %f", [gesture translationInView:self.view].y);
//    
//    
//    if ([gesture translationInView:self.view].y >= 0) { // Going Down
//        
//        if (contraintValue < 0) {
//            
//            contraintValue = [gesture translationInView:self.view].y;
//            
//        } else {
//            
//            contraintValue = 0;
//            
//        }
//        
//    } else { // Going Up
//        
//        if (contraintValue < -50) {
//            
//            contraintValue = [gesture translationInView:self.view].y;
//            
//        } else {
//            
//            contraintValue = -50;
//            
//        }
//        
//    }
//    
//    NSLog(@"constraint value %d", contraintValue);
//    
//    
//    [self.addListButton layoutIfNeeded];
//    
//    [UIView animateWithDuration:0.5 animations:^(void) {
//        
//        self.addListConstraint.constant = contraintValue;
//        [self.addListButton layoutIfNeeded];
//        
//    }];
//    
//    
//}





#pragma mark - Other COntrollers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ListViewSegue"]) {
        
        NSIndexPath * index = (NSIndexPath *)sender;
        
        ListViewController *listViewController = [segue destinationViewController];
        listViewController.list = [dataManager.listArray objectAtIndex:index.row];
        
        NSLog(@"list array %@", [dataManager.listArray objectAtIndex:index.row]);
        
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
