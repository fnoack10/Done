//
//  AddItemViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "AddItemViewController.h"


@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.itemNameTextField setDelegate:self];

}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addItemAction:(UIButton *)sender {
    
    
    if (![self.itemNameTextField.text isEqualToString:@""]) {
        
        Item *item = [Item object];
        
        item[@"list"] = self.list;
        item.name = self.itemNameTextField.text;
        
        [[[DataManager sharedManager] itemsInListArray] addObject:item];
        
        [[DataManager sharedManager] saveItem:item];
        
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
