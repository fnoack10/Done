//
//  AddListViewController.h
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddListViewController : UIViewController <UITextFieldDelegate>

// Views

@property (weak, nonatomic) IBOutlet UIView *topBarView;

// Text Fields

@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *addListButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *colorButton;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Constraint

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addListButtonConstraint;

// Action

- (IBAction)closeAction:(UIButton *)sender;

- (IBAction)addListAction:(UIButton *)sender;

- (IBAction)colorAction:(UIButton *)sender;

@end
