//
//  CustomButton.m
//  GlossyButtonTest
//
//  Created by Dmitry Suhorukov on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "iGoTorontoAppDelegate.h"
#import "iGoGradientButton.h"

@implementation iGoGradientButton

@synthesize type;
@synthesize gradientStartColor = _gradientStartColor;
@synthesize gradientEndColor = _gradientEndColor;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib;
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //The gradient layer was corrupting on pre 4.2 devices
    if (version >= 4.190000)
    {
        _gradientLayer = [[CAGradientLayer alloc] init];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
        
	_glossyLayer = [[CAGradientLayer alloc] init];
    [self.layer addSublayer:_glossyLayer];
	
	self.clipsToBounds = NO;
	self.layer.masksToBounds = YES;
    
}
- (void)drawRect:(CGRect)rect;
{
    iGoTorontoAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    if([Constants sharedConstants].deviceProfile == IPAD_PROFILE)
    {   
        if(type == ROUNDED_BORDERED || type == SQUARE_BORDERED)
        {
            self.layer.borderWidth = 2.0f; 
        }
        if(type == ROUNDED_BORDERED || type == ROUNDED_UNBORDERED)
        {
            if(delegate.QualityMode != QUALITY_LOW)
            {
                self.layer.cornerRadius = 9.0f;
            }
        }
    }
    else
    {
        if(type == ROUNDED_BORDERED || type == SQUARE_BORDERED)
        {
            self.layer.borderWidth = 1.0f;
        }
        if(type == ROUNDED_BORDERED || type == ROUNDED_UNBORDERED)
        {
            if(delegate.QualityMode != QUALITY_LOW)
            {
                self.layer.cornerRadius = 5.0f;
            }
        }
    }
    
    if (_gradientStartColor && _gradientEndColor)
    {
        [_gradientLayer setColors:
         [NSArray arrayWithObjects: (id)[_gradientStartColor CGColor]
          , (id)[_gradientEndColor CGColor], nil]];
    }
    else
    {
        [_gradientLayer setColors:nil];
    }
    
    //The gradient layer was corrupting on pre 4.2 devices
    if (_gradientLayer)
    {
        _gradientLayer.bounds = self.bounds;
        _gradientLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    _glossyLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2);
    _glossyLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/4);
    
    [_glossyLayer setColors:
     [NSArray arrayWithObjects: 
      (id)[[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.25f] CGColor]
      , (id)[[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.15f] CGColor], nil]];
    
    [super drawRect:rect];
}
- (void)dealloc 
{
    //type - do not release
	[_glossyLayer release];
	[_gradientEndColor release];
	[_gradientStartColor release];
	[_gradientLayer release];
    [super dealloc];
}
@end
