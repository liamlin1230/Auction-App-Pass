//
//  SigninViewController.m
//  Pass
//
//  Created by Edward Kim on 12/11/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "SigninViewController.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"sign in";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)signinAndClose:(id)sender {
    Firebase *root = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/"];
    
    [root authUser:self.emailTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            // an error occurred while attempting login
            NSString *errorMsg;
            
            if ([self.emailTextField.text length] == 0) {
                errorMsg = @"Your email field is empty.";
            } else if ([self.passwordTextField.text length] == 0) {
                errorMsg = @"Your password field is empty.";
            } else {
                errorMsg = @"Your email or password is invalid.";
            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error: Could not sign in"
                                                           message: errorMsg
                                                          delegate: self
                                                 cancelButtonTitle: nil
                                                 otherButtonTitles: @"OK", nil];
            
            [alert setTag:1];
            [alert show];
            
            NSLog(@"%@", error);
        } else {
            // user is logged in, check authData for data
            
            // Update sidebar title cell
            // TO DO: implement this
            
            // Dismiss this controller and the sign in controller underneath it
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

@end
