//
//  SigninViewController.h
//  Pass
//
//  Created by Edward Kim on 12/11/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SigninViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)close:(id)sender;
- (IBAction)signinAndClose:(id)sender;

@end
