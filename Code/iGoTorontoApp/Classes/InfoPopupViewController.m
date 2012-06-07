    //
//  InfoPopupViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoPopupViewController.h"

@implementation InfoPopupViewController
@synthesize bodyView;
@synthesize titleView;
@synthesize refreshButton;
@synthesize content;
@synthesize contentViewController;

 // The designated initializer.
-(id)initWithViewController:(UIViewController*)viewController andTitle:(NSString*)title shouldScroll:(BOOL)shouldScroll
{
    self.contentViewController = viewController;
	return [self initWithView:viewController.view andTitle:title shouldScroll:shouldScroll];
}
-(id)initWithViewController:(UIViewController*)viewController andTitle:(NSString*)title
{
    return [self initWithViewController:viewController andTitle:title shouldScroll:NO];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    return [self initWithView:nil andTitle:nil];
}
-(id)initWithView:(UIView*)view andTitle:(NSString*)title
{
	NSMutableString *infoPopupViewControllerNibName = [NSMutableString stringWithString:@"InfoPopupView"];
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
		[infoPopupViewControllerNibName appendString:@"-iPad"];
	}	
    
	if ((self = [super initWithNibName:infoPopupViewControllerNibName bundle:[NSBundle mainBundle]])) 
    {
        self.content = view;
        self.title = title;
    }
	return self;
}
-(id)initWithView:(UIView*)view andTitle:(NSString*)title shouldScroll:(BOOL)shouldScroll
{
	// Create scrollview, with content of view
    if(shouldScroll)
    {
        //If shouldScroll is set to true, checks if the content view is larger than it's containment area
        // if so, embed in a scrollview
        if(view.frame.size.height > self.bodyView.frame.size.height)
        {
            UIScrollView* scrollview = [[[UIScrollView alloc] initWithFrame:view.frame] autorelease];
            scrollview.autoresizesSubviews = YES;
			
			scrollview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
			[scrollview addSubview:view];
            [scrollview setContentSize:view.frame.size];
			return [self initWithView:scrollview andTitle:title];
        }
    }
	//catch all
	return [self initWithView:view andTitle:title];
}
- (void)dealloc 
{
	[bodyView release];
    [titleView release];
	[content release];
    [refreshButton release];
	[contentViewController release];
    [super dealloc];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [titleView setText:self.title];
	[content setFrame:bodyView.bounds];
	[content setBounds:bodyView.bounds];
	[bodyView addSubview:content];
	//If the info popup view contains a scrollview, flash it's scrollbars
	if([content respondsToSelector:@selector(flashScrollIndicators)])
	{
		[content performSelector:@selector(flashScrollIndicators)];
	}
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.bodyView = nil;
    self.titleView = nil;
    self.refreshButton = nil;
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [contentViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
/* IBActions */
-(IBAction)refresh : (id) sender
{
    
}
/* Overriden Methods */
-(void)slideOutWithDuration:(double)duration
{
    self.bodyView.hidden = YES;
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    //Stops all scrolling
    for(UIView* subview in self.bodyView.subviews)
    {        
        for(UIView* subsubview in subview.subviews)
        {
            if([subsubview respondsToSelector:@selector(scrollToRowAtIndexPath:atScrollPosition:animated:)])
            {
                //Ensures there are elements in this table
                if([subsubview numberOfSections] > 0 && [subsubview numberOfRowsInSection:0])
                {
                    [subsubview  scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
                
        }
    }
    
    [super slideOutWithDuration:duration];
}
@end
