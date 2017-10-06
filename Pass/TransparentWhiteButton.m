//
//  TransparentWhiteButton.m
//  Pass
//
//  Created by Edward Kim on 12/16/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "TransparentWhiteButton.h"

@implementation TransparentWhiteButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.15];
        self.layer.cornerRadius = 15.0f;
        self.clipsToBounds = YES;
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        // Shadow
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    }
    return self;
}

@end
