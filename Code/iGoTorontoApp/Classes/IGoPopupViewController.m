    //
//  PopupViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-02-01.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "IGoPopupViewController.h"

@implementation IGoPopupViewController

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
- (void)dealloc {
    [super dealloc];
}
/* IBActions */
-(IBAction)close:(id)sender
{
	double slideOutDuration = 0.2;
	[self slideOutWithDuration:slideOutDuration];
	[self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:slideOutDuration * 0.75];
}
/* Custom Methods */
-(void)slideIn
{
	//Set view as interactable
	self.view.userInteractionEnabled = YES;
	
	iGoTorontoAppDelegate* delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	[delegate.tabBarController.view addSubview:self.view];
    
    //Send to the topmost layer of the screen
    self.view.layer.zPosition = 1;
    
	CGRect frame = self.view.frame;
	frame.size = [[Constants sharedConstants] screenContentSize];
	self.view.frame = frame;
	
	CGSize offSize = frame.size;
	CGRect contentArea; contentArea.size = offSize;
	contentArea.origin.x = 0; contentArea.origin.y = 0;

	CGPoint middleCenter = self.view.center;   
	
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);   
	self.view.center = offScreenCenter;    
	// Show it with a transition effect     
	[UIView beginAnimations:nil context:nil];   
	[UIView setAnimationDuration:0.5]; 
	// animation duration in seconds   
	self.view.center = middleCenter;
	[UIView commitAnimations];
}
-(void)slideOutWithDuration:(double)duration
{ 
	CAAnimationGroup *slideOutThenFadeOutGroup = [[[CAAnimationGroup alloc] init] autorelease];
	[slideOutThenFadeOutGroup setDuration:duration * 3];
	
	CABasicAnimation *slideOutAnimation = [[[CABasicAnimation alloc] init] autorelease];
	slideOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
	[slideOutAnimation setFromValue:[NSNumber numberWithFloat:self.view.frame.origin.y]];
	[slideOutAnimation setToValue:[NSNumber numberWithFloat:self.view.frame.size.height - self.view.frame.origin.y]];
	[slideOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[slideOutAnimation setDuration:duration];
	
	CABasicAnimation* opacityAnimation = [[[CABasicAnimation alloc] init] autorelease];
	opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[opacityAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
	[opacityAnimation setToValue:[NSNumber numberWithFloat:0.0]];
	opacityAnimation.removedOnCompletion = NO;
	[opacityAnimation setBeginTime:duration];
	[opacityAnimation setDuration:duration*2];
	
	slideOutThenFadeOutGroup.animations = [NSArray arrayWithObjects:slideOutAnimation,opacityAnimation,nil];
	[self.view.layer addAnimation:slideOutThenFadeOutGroup forKey:@"slideOutThenFadeOutGroup"];
}
@end
