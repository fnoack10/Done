//
//  LoginViewController.m
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "LoginViewController.h"

// Managers

#import "DataManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.userTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoginController) name:@"LoginSuccess" object:nil];
}

#pragma mark - Button Actions

- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *email = self.userTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[DataManager sharedManager] loginWithUser:email andPassword:password];
    
}

#pragma mark - Text Field Protocol

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userTextField) {
        
        [self.passwordTextField becomeFirstResponder];
        
    } else {
        
        [self.passwordTextField resignFirstResponder];
        
        if (![self.userTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:@""]) {
            
            [self loginAction:nil];
            
        }
        
    }
    
    return YES;
    
}

#pragma mark - Dismiss Login Controller

- (void) dismissLoginController {
    
    [self willMoveToParentViewController:self.parentViewController];
    [self beginAppearanceTransition:NO animated:YES];
    
    [self endAppearanceTransition];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


@end
