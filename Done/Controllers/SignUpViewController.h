//
//  SignUpViewController.h
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

// Text Field

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

// Actions

- (IBAction)signUpAction:(UIButton *)sender;

- (IBAction)backAction:(UIButton *)sender;

@end
