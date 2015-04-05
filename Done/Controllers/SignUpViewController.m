//
//  SignUpViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "SignUpViewController.h"

// Managers
#import "DataManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.nameTextField setDelegate:self];
    
    [self.lastNameTextField setDelegate:self];
    
    [self.emailTextField setDelegate:self];
    
    [self.passwordTextField setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAction:) name:@"LoginSuccess" object:nil];
    
}

#pragma mark - Text Field Protocol

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        
        [self.lastNameTextField becomeFirstResponder];
        
    } else if (textField == self.lastNameTextField) {
        
        [self.emailTextField becomeFirstResponder];
        
    } else if (textField == self.emailTextField) {
        
        [self.passwordTextField becomeFirstResponder];
        
    } else {
        
        [self.passwordTextField resignFirstResponder];
        
    }
    
    return YES;
    
}

- (IBAction)signUpAction:(UIButton *)sender {
    
    
    if (![self.nameTextField.text isEqualToString:@""] || ![self.lastNameTextField.text isEqualToString:@""] || ![self.emailTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:@""]) {
        
        PFUser *user = [PFUser user];
        user.username = self.emailTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        
        // other fields can be set just like with PFObject
        user[@"firstName"] = self.nameTextField.text;
        user[@"lastName"] = self.lastNameTextField.text;
        
        [[DataManager sharedManager] signUpUser:user];
        
    }

    
}

- (IBAction)backAction:(UIButton *)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
