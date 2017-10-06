//
//  SignupViewController.m
//  Pass
//
//  Created by Edward Kim on 12/10/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"sign up";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)signupAndClose:(id)sender {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/"];
    
    NSLog(@"Email: %@ | Password: %@", self.emailTextField.text, self.passwordTextField.text);
    
    BOOL passedFirstCheck = false;
    NSString *errorMsg;
    
    if ([self.firstNameTextField.text length] == 0) {
        errorMsg = @"Enter your first name.";
    } else if ([self.lastNameTextField.text length] == 0) {
        errorMsg = @"Enter your last name.";
    } else {
        passedFirstCheck = true;
    }
    
    if (!passedFirstCheck) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error: Could not sign up"
                                                       message: errorMsg
                                                      delegate: self
                                             cancelButtonTitle: nil
                                             otherButtonTitles: @"OK", nil];
        
        [alert setTag:1];
        [alert show];
    } else {
        // Everything's fine so far...
        [ref createUser:self.emailTextField.text password:self.passwordTextField.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
                NSString *errorMsg;
                // There was an error creating the account
                NSLog(@"%@", error);
                if ([self.emailTextField.text length] == 0) {
                    errorMsg = @"Enter your email address.";
                } else if ([self.passwordTextField.text length] == 0) {
                    errorMsg = @"Enter a password.";
                } else {
                    errorMsg = @"The specified email address is invalid.";
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error: Could not sign up"
                                                               message: errorMsg
                                                              delegate: self
                                                     cancelButtonTitle: nil
                                                     otherButtonTitles: @"OK", nil];
                
                [alert setTag:1];
                [alert show];
            } else {
                // Successfully created account. Authenticate user...
                NSString *uid = [result objectForKey:@"uid"];
                NSLog(@"Successfully created user account with uid: %@", uid);
                
                // Save first and last name to user data
                
                
                // Create a new user dictionary accessing the user's info
                // provided by the authData parameter
                NSDictionary *newUser = @{
                                          @"firstName": self.firstNameTextField.text,
                                          @"lastName": self.lastNameTextField.text
                                          };
                // Create a child path with a key set to the uid underneath the "users" node
                // This creates a URL path like the following:
                //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                [[[ref childByAppendingPath:@"users"]
                  childByAppendingPath:uid] setValue:newUser];
                
                
                [ref authUser:self.emailTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    if (error) {
                        // an error occurred while attempting login
                        NSLog(@"%@", error);
                    } else {
                        // user is logged in, check authData for data
                        
                        NSLog(@"Authentication successful for uid: %@", uid);
                        
                        // Dismiss this controller and the sign in controller underneath it
                        //[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
