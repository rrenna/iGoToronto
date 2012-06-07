//
//  HelpVewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-05.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController
@synthesize helpTextLabel;
@synthesize helpText;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	if(helpText)
	{
		helpTextLabel.text = helpText;
		[helpTextLabel sizeToFit];
	}
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[helpTextLabel release];
	[helpText release];
    [super dealloc];
}
/* IBActions */
-(IBAction)close:(id)sender
{
	//Fade out window & shroud
	CABasicAnimation *alphaAnimation = nil;
	alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[alphaAnimation setToValue:[NSNumber numberWithDouble:0.0]];
	[alphaAnimation setFromValue:[NSNumber numberWithDouble:1.0]];
	[alphaAnimation setDuration:0.2f];
	[self.view.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
	[self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.15];
}
@end
