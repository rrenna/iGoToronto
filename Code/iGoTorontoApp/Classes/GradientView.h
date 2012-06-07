//
//  GradientView.h
//  LifeStylerClient
//
//  Created by Ryan Renna on 10-11-30.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GradientView : UIView 
{
@private;
	CGFloat gradientColourComponents[8];
}
@property (retain) UIColor* color;

-(id)initWithFrame:(CGRect)frame andBeginningColour:(UIColor*) beginningColour andEndingColour:(UIColor*) endingColour;

@end
