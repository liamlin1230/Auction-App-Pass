//
//  Signup2ViewController.m
//  Pass
//
//  Created by Zhegeng Wang on 12/16/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "Signup2ViewController.h"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    NSLog(@"Signup2ViewController loaded");
    //self.profileImage.layer.borderWidth = 3.0f;
    //self.profileImage.layer.borderColor = [UIColor redColor].CGColor;

}

- (IBAction)takePhoto {
    picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    [picker1 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker1 animated:YES completion:NULL];
}

- (IBAction)chooseExisting {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker2 animated:YES completion:NULL];
    //[picker2 release];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.profileImage setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)signupAndClose:(id)sender{
    /*
    Firebase *refUser = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://incandescent-inferno-3342.firebaseio.com/users/%@", self.userID]];
    BOOL success = false;
    NSString *stringImage;
    NSString *errorMsg;
    
    NSData *dataImage = [[NSData alloc] init];
    dataImage = UIImageJPEGRepresentation(image, 0.9f);
    
    if ([dataImage length] >= 10485760) {
        //success = false;
        errorMsg = @"Your image exceeds the max size of 10MB.";
    } else {
        // Image is small enough to be saved
        
        // Convert UIImage to NSString to store in JSON data
        stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary *profilePic = @{
                                     @"profileImage": stringImage,
                                     };
        [refUser updateChildValues: profilePic];
        success = true;
    }
    
    if (success) {
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error: Could not save profile"
                                                       message: errorMsg
                                                      delegate: self
                                             cancelButtonTitle: nil
                                             otherButtonTitles: @"OK", nil];
        
        [alert setTag:1];
        [alert show];
    }*/
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
