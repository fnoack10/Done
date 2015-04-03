//
//  LoginViewController.h
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

// Text Fields

@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

// Actions

- (IBAction)loginAction:(UIButton *)sender;

@end
  