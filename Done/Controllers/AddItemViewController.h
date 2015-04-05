//
//  AddItemViewController.h
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

// Managers

#import "DataManager.h"

@interface AddItemViewController : UIViewController <UITextFieldDelegate>

// List

@property (strong, nonatomic) List *list;

@property (strong, nonatomic) NSMutableArray *itemsInList;

// Views

@property (weak, nonatomic) IBOutlet UIView *topBarView;

// Text Field

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *addItemButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Action

- (IBAction)closeAction:(UIButton *)sender;

- (IBAction)addItemAction:(UIButton *)sender;

@end
