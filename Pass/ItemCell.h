//
//  ItemCell.h
//  Pass
//
//  Created by Zhegeng Wang on 12/1/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAuthor;
@property (strong, nonatomic) IBOutlet UILabel *myPrice;



@end
