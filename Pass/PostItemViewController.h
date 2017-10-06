//
//  PostItemViewController.h
//  Pass
//
//  Created by Edward Kim on 11/28/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface PostItemViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {
    UIImagePickerController *picker;
    UIImage *image;
    IBOutlet UIImageView *imageView;
    
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;
@property (strong, nonatomic) IBOutlet UISlider *startingPriceSlider;
@property (strong, nonatomic) IBOutlet UISlider *buyoutPriceSlider;
@property (strong, nonatomic) IBOutlet UILabel *startingPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *buyoutPriceLabel;
@property (strong, nonatomic) IBOutlet UITextView *tagsTextView;


@property (weak, nonatomic) IBOutlet UINavigationItem *close;

-(IBAction)close:(id)sender;
-(IBAction)post:(id)sender;
-(IBAction)choose;

@end