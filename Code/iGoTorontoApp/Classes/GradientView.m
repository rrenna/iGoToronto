//
//  GradientView.m
//  LifeStylerClient
//
//  Created by Ryan Renna on 10-11-30.
//  Copyright 2010 None. All rights reserved.
//

#import "GradientView.h"
#import "iGoTorontoAppDelegate.h"

@implementation GradientView
@synthesize color;

-(id)initWithFrame:(CGRect)frame andBeginningColour:(UIColor*) beginningColour andEndingColour:(UIColor*) endingColour
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		if(beginningColour && endingColour)
		{
            self.color = beginningColour;
            
			const CGFloat* beginningComponents = CGColorGetComponents(beginningColour.CGColor);
			const CGFloat* endingComponents = CGColorGetComponents(endingColour.CGColor);

			CGColorSpaceRef beginningSpace = CGColorGetColorSpace(beginningColour.CGColor);
			CGColorSpaceModel beginningSpaceModel = CGColorSpaceGetModel(beginningSpace);
			//If monochrome colour, will only return a grey and alpha value
		   if(beginningSpaceModel == kCGColorSpaceModelMonochrome)
		   {
			   gradientColourComponents[0] = beginningComponents[0];
			   gradientColourComponents[1] = beginningComponents[0];
			   gradientColourComponents[2] = beginningComponents[0];
			   gradientColourComponents[3] = beginningComponents[1];
		   }
		   else 
		   {
			   gradientColourComponents[0] = beginningComponents[0];
			   gradientColourComponents[1] = beginningComponents[1];
			   gradientColourComponents[2] = beginningComponents[2];
			   gradientColourComponents[3] = beginningComponents[3];
		   }
			
			CGColorSpaceRef endingSpace = CGColorGetColorSpace(endingColour.CGColor);
			CGColorSpaceModel endingSpaceModel = CGColorSpaceGetModel(endingSpace);
			if(endingSpaceModel == kCGColorSpaceModelMonochrome)
			{
				gradientColourComponents[4] = endingComponents[0];
				gradientColourComponents[5] = endingComponents[0];
				gradientColourComponents[6] = endingComponents[0];
				gradientColourComponents[7] = endingComponents[1];
			}
			else 
			{
				gradientColourComponents[4] = endingComponents[0];
				gradientColourComponents[5] = endingComponents[1];
				gradientColourComponents[6] = endingComponents[2];
				gradientColourComponents[7] = endingComponents[3];
			}
	   }
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame 
{
    return [self initWithFrame:frame andBeginningColour:[UIColor redColor] andEndingColour:[UIColor blueColor]];
}

- (void)drawRect:(CGRect)rect 
{
    iGoTorontoAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.QualityMode == QUALITY_LOW)
    {
        //beginningColor
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(currentContext, self.color.CGColor);
        CGContextFillRect(currentContext, self.bounds);
    }
    else
    {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGGradientRef glossGradient;
        CGColorSpaceRef rgbColorspace;
        size_t num_locations = 2;
        CGFloat locations[2] = { 0.0, 1.0 };
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, gradientColourComponents, locations, num_locations);
        CGRect currentBounds = self.bounds;
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0);
        CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
        CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
        CGGradientRelease(glossGradient);
        CGColorSpaceRelease(rgbColorspace); 
    }
    
	
	[super drawRect:rect];
}

- (void)dealloc 
{
    [color release];
    [super dealloc];
}


@end
