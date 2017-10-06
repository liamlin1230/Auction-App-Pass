//
//  Signup2ViewController.h
//  Pass
//
//  Created by Zhegeng Wang on 12/16/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface Signup2ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *picker1;
    UIImagePickerController *picker2;
    UIImage *image;
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) NSString *userID;


- (IBAction)takePhoto;
- (IBAction)chooseExisting;
- (IBAction)signupAndClose:(id)sender;

@end
