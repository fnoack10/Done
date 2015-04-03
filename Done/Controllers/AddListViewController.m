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

@interface AddListViewController ()

@end

@implementation AddListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.listNameTextField setDelegate:self];
    
    // Do any additional setup after loading the view.
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)addListAction:(UIButton *)sender {    
    
    if (![self.listNameTextField.text isEqualToString:@""]) {
        
        List *list = [List object];
        list.name = self.listNameTextField.text;
        
        [[[DataManager sharedManager] listArray] addObject:list];
        
        [[DataManager sharedManager] saveList:list];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Text Field Protocol

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.listNameTextField resignFirstResponder];
    
    return YES;
    
}

@end
