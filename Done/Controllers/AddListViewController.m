//
//  AddListViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "AddListViewController.h"

// Managers

#import "DataManager.h"

// Resources

#import "Typography.h"

#import "Palette.h"

@interface AddListViewController () {
    
    DataManager *dataManager;
    
}

@end

@implementation AddListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [self initializeController];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.listNameTextField resignFirstResponder];
    
}

- (void) initializeController {
    
    [self.colorButton.layer setCornerRadius:17.5];
    
    [self.titleLabel setTextColor:[Palette titleGray]];
    
    [self.titleLabel setFont:[Typography lightOpenSans:@"title"]];
    
    [self.listNameTextField setDelegate:self];
    
    [self.listNameTextField becomeFirstResponder];
    
    [self.listNameTextField setTintColor:[Palette backgroundGray]];
    
    [self.listNameTextField setTextColor:[Palette textGray]];
    
}

#pragma mark - Button Action

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)addListAction:(UIButton *)sender {    
    
    if (![self.listNameTextField.text isEqualToString:@""]) {
        
        List *list = [List object];
        list.name = self.listNameTextField.text;
        
        [dataManager saveList:list];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)colorAction:(UIButton *)sender {
    
    
}

#pragma mark - Text Field Protocol

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.addListButton layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^(void) {
        
        self.addListButtonConstraint.constant = 216;
        
        [self.addListButton layoutIfNeeded];
        
    }];
    
    return YES;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.listNameTextField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self.addListButton layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        
        self.addListButtonConstraint.constant = 0;
        
        [self.addListButton layoutIfNeeded];
        
    }];
    
    return YES;
    
}

@end
