    //
//  IGoScreenController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-31.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "IGoScreenController.h"

@implementation IGoScreenController
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If iPad - support all orientations
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
		return YES;
	}
	//If iPhone - support only portrait/portrait upsidedown orientation
	else 
	{
		if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || toInterfaceOrientation == UIInterfaceOrientationPortrait)
		{
			return YES;
		}
		
	}
	return NO;
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self layoutControls];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//Template Methods */
-(void)layoutControls
{
    //Template Methods
}
@end
