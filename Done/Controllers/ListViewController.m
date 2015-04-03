//
//  ListViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "ListViewController.h"

// Managers

#import "ErrorManager.h"

// Controllers
#import "LoginViewController.h"
#import "AddItemViewController.h"

// Resources
#import "ItemTableViewCell.h"
#import "Palette.h"

@interface ListViewController (){
    
    DataManager *dataManager;
    
    NSArray *itemsInList;
    
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getItemsInList) name:@"UpdateData" object:nil];
    
    [self initializeTableView];
    
    [self getItemsInList];
    
}

- (void) getItemsInList {
    

    // TODO - PFRelation DATA
    
    
//    NSPredicate *itemPredicate = [NSPredicate predicateWithFormat:@"(list == %@)", self.list.objectId];
//    itemsInList = [dataManager.itemArray filteredArrayUsingPredicate:itemPredicate];
//    
//    [self updateRefreshControl];
//
//    [self.itemTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    Item *item = [dataManager.itemArray firstObject];
//    
//    NSLog(@"DATAMANAGER ITEM %@", item.list);
//    
//    NSLog(@"DATAMANAGER ITEM %@", self.list.objectId);
//
//    
    PFQuery *query = [Item query];
    [query whereKey:@"list" equalTo:self.list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        
        if (!error) {
            
            itemsInList = items;
            

            [self updateRefreshControl];

            [self.itemTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
        }
    }];


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
    
    self.titleLabel.text = self.list.name;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.itemTableView;
    
    [self.itemTableView setDelegate:self];
    [self.itemTableView setDataSource:self];
    [self.itemTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Palette backgroundGray];
    self.refreshControl.tintColor = [Palette darkGrayColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(updateTable)
//                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
}

#pragma mark - Done Table View Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ItemTableViewCell";
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ItemTableViewCell alloc] init];
    }
    
    Item *item = [itemsInList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [itemsInList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"AddItemSegue"]) {
        
        AddItemViewController *addItemViewController = [segue destinationViewController];
        addItemViewController.list = self.list;
        
    }
    
}

- (IBAction)letfAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)rightAction:(UIButton *)sender {
}
@end
