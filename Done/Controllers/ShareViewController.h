//
//  ShareViewController.h
//  Done
//
//  Created by Franco Noack on 4/12/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

// Managers

#import "DataManager.h"

@interface ShareViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// Views

@property (weak, nonatomic) IBOutlet UIView *topBarView;

// Table View

@property (weak, nonatomic) IBOutlet UITableView *shareTableView;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Refresh Control

@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Action

- (IBAction)closeAction:(UIButton *)sender;

@end
