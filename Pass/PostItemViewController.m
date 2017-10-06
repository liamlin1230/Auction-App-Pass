//
//  PostItemViewController.m
//  Pass
//
//  Created by Edward Kim on 11/28/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "PostItemViewController.h"
//#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface PostItemViewController ()

@end

@implementation PostItemViewController {
    UILabel *descriptionLabel;
    UILabel *tagLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"post new item";
    
    // Set minimum expiration date to 1 hour from now
    self.expirationDatePicker.date =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 3602 ];
    self.expirationDatePicker.minimumDate =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 3600 ];
    
    // Create fake placeholder for description text view and tags text view
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.descriptionTextView.frame.size.width - 10.0, 34.0)];
    tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.tagsTextView.frame.size.width - 10.0, 34.0)];
    
    [descriptionLabel setText:@"Add a description..."];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionLabel setTextColor:[UIColor lightGrayColor]];
    self.descriptionTextView.delegate = self;
    
    [self.descriptionTextView addSubview:descriptionLabel];
    
    [tagLabel setText:@"Painting, canvas, abstract"];
    [tagLabel setBackgroundColor:[UIColor clearColor]];
    [tagLabel setTextColor:[UIColor lightGrayColor]];
    self.tagsTextView.delegate = self;
    
    [self.tagsTextView addSubview:tagLabel];
}

// Hide fake placeholder when editing description/tags text
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![self.descriptionTextView hasText]) {
        descriptionLabel.hidden = NO;
    }
    if (![self.tagsTextView hasText]) {
        tagLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if (![self.descriptionTextView hasText]) {
        descriptionLabel.hidden = NO;
    } else {
        descriptionLabel.hidden = YES;
    }
    if (![self.tagsTextView hasText]) {
        tagLabel.hidden = NO;
    } else {
        tagLabel.hidden = YES;
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)choose {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)startingPriceChange:(id)sender {
    self.startingPriceLabel.text = [NSString stringWithFormat:@"$%.2f", self.startingPriceSlider.value * 1000];
}

- (IBAction)buyoutPriceChange:(id)sender {
    self.buyoutPriceLabel.text = [NSString stringWithFormat:@"$%.2f", self.buyoutPriceSlider.value * 1000];
}


- (IBAction)post:(id)sender {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/"];
    BOOL success = false;
    NSString *errorMsg;
    NSString *stringImage;
    NSString *expirationDateString;
    
    if (ref.authData) {
        // User is logged in
        
        // Resize primary image to newSize
        //            CGSize newSize = CGSizeMake(240.0f, 195.0f);
        //            UIGraphicsBeginImageContext(newSize);
        //            [image drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
        //            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        //            UIGraphicsEndImageContext();
        
        NSData *dataImage = [[NSData alloc] init];
        dataImage = UIImageJPEGRepresentation(image, 0.9f);
        
        if ([dataImage length] >= 10485760) {
            //success = false;
            errorMsg = @"Your image exceeds the max size of 10MB.";
        } else {
            // Image is large enough to be saved
            
            // Convert UIImage to NSString to store in JSON data
            stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            // Format the date in YYYY-MM-DD format
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
            expirationDateString = [dateFormat stringFromDate:self.expirationDatePicker.date];
            
            NSLog(@"Name field: %@", self.nameTextField.text);
            NSLog(@"Description field: %@", self.descriptionTextView.text);
            
            if ([self.nameTextField.text length] == 0) {
                errorMsg = @"Your name field is empty.";
            } else if ([self.descriptionTextView.text length] == 0) {
                errorMsg = @"Your description field is empty.";
            } else if ([self.tagsTextView.text length] == 0) {
                success = true;
            } else {
                success = true;
            }
        }
    } else {
        errorMsg = @"You must be logged in to post an item.";
    }
    
    if (success) {
        // Create a new user dictionary accessing the user's info
        // provided by the authData parameter
        NSDictionary *newItem = @{
                                  @"seller": ref.authData.uid,
                                  @"name": self.nameTextField.text,
                                  @"description": self.descriptionTextView.text,
                                  @"expirationDate": expirationDateString,
                                  @"startingPrice": self.startingPriceLabel.text,
                                  @"currentBid": self.startingPriceLabel.text,
                                  @"buyoutPrice": self.buyoutPriceLabel.text,
                                  @"primaryPhoto": stringImage,
                                  @"bidCount": @0
                                  };
        
        // Send data to the server
        Firebase *refItems = [ref childByAppendingPath: @"items"];
        Firebase *refPostedItem = [refItems childByAutoId];
        [refPostedItem setValue: newItem];
        NSLog(@"Post item success!");
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error: Could not post item"
                                                       message: errorMsg
                                                      delegate: self
                                             cancelButtonTitle: nil
                                             otherButtonTitles: @"OK", nil];
        
        [alert setTag:1];
        [alert show];
    }
    
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