//
//  RoundOrangeButton.m
//  Pass
//
//  Created by Edward Kim on 12/16/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "RoundOrangeButton.h"

@implementation RoundOrangeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        //self.opaque = NO;
        
        // Padding
        // self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        
        // Title
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
        
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.5059 blue:0.0 alpha:1.0];
        self.layer.cornerRadius = 15.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    UIColor * color = [UIColor colorWithRed:0.93 green:0.80 blue:0.80 alpha:1.0];
////    CGContextSetFillColorWithColor(context, color.CGColor);
////    CGContextFillRect(context, self.bounds);
////    self.layer.cornerRadius = 10;
////    self.clipsToBounds = YES;
//    
//    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.backgroundColor = [UIColor colorWithRed:0.93 green:0.80 blue:0.80 alpha:1.0];
//    self.layer.cornerRadius = 10.0f;
//    self.clipsToBounds = YES;
//}

@end
