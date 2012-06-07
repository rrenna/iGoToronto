//
//  IGoMainScreenController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-09.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "IGoMainScreenController.h"
#import "iGoGradientButton.h"
#import "AdViewController.h"

@implementation IGoMainScreenController
@synthesize iGoButton;
@synthesize adSpaceView;
@synthesize helpViewController;
@synthesize adViewController;
@synthesize infoPopupViewController;

-(void)viewWillAppear:(BOOL)animated
{
	iGoMenuViewController* igoMenuViewController = [Constants sharedConstants].igoMenuViewController;
	if([[Constants sharedConstants] iGoMenuDisplayed])
	{
		[Constants sharedConstants].iGoMenuDisplayed = YES;
		[self.view addSubview:igoMenuViewController.view];		
	}
	else 
	{
		[igoMenuViewController.view removeFromSuperview];	
	}
	
	[super viewWillAppear:animated];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [infoPopupViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.iGoButton = nil;
    self.adSpaceView = nil;
}
-(void)dealloc
{
	[iGoButton release];
    [adSpaceView release];
	[helpViewController release];
    [adViewController release];
	[infoPopupViewController release];
	[super dealloc];
}
/* IBActions */
-(IBAction)displayiGoMenu:(id)sender
{
	iGoMenuViewController* igoMenuViewController = [Constants sharedConstants].igoMenuViewController;
	//If the iGo Menu is displayed
	if([[Constants sharedConstants] iGoMenuDisplayed])
	{
		[Constants sharedConstants].iGoMenuDisplayed = NO;
		[igoMenuViewController.view removeFromSuperview];
	}
	//If the iGo Menu is not displayed
	else 
	{
		[Constants sharedConstants].iGoMenuDisplayed = YES;
		//Fade in the shroud 
		CABasicAnimation *alphaAnimation = nil;
		alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[alphaAnimation setToValue:[NSNumber numberWithDouble:1.0]];
		[alphaAnimation setFromValue:[NSNumber numberWithDouble:0.0]];
		[alphaAnimation setDuration:0.33f];
		[igoMenuViewController.shroudButton.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
		[self.view addSubview:igoMenuViewController.view];		
	}
}
/* Custom Methods */
-(void)displayHelp:(NSString*)text
{
    if(!helpViewController)
    {
		NSMutableString *helpViewControllerNibName = [NSMutableString stringWithString:@"HelpViewController"];
		if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
		{
			[helpViewControllerNibName appendString:@"-iPad"];
		}	
		
		
        helpViewController = [[HelpViewController alloc] initWithNibName:helpViewControllerNibName bundle:nil];
		helpViewController.helpText = text;
	}
    [self.view addSubview:helpViewController.view];
}
@end
