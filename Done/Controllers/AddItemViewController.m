//
//  AddItemViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "AddItemViewController.h"


@interface AddItemViewController () {
    
    DataManager *dataManager;
    
}

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    [self.itemNameTextField setDelegate:self];

}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addItemAction:(UIButton *)sender {
    
    
    if (![self.itemNameTextField.text isEqualToString:@""]) {
        
        Item *item = [Item object];
    
        item.name = self.itemNameTextField.text;
        
        [dataManager saveItem:item forList:self.list];
         
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - Text Field Protocol

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.itemNameTextField resignFirstResponder];
    
    return YES;
    
}


@end
