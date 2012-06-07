    //
//  iGoMenuViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-09.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "iGoMenuViewController.h"

@implementation iGoMenuViewController
@synthesize shroudButton;
@synthesize scheduleLabel;
@synthesize versionLabel;
@synthesize OffblastView;
@synthesize LegaleseView;
//@synthesize WhatsNextView;
//@synthesize whatsNextWebview;
@synthesize infoPopupController;
@synthesize picker;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.scheduleLabel.text = [self.scheduleLabel.text stringByAppendingString:[[Constants sharedConstants] lastUpdatedSchedules]];
		self.versionLabel.text = [self.versionLabel.text stringByAppendingString:[[Constants sharedConstants] versionName]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.shroudButton = nil;
    self.scheduleLabel = nil;
    self.versionLabel = nil;
    self.OffblastView = nil;
    self.LegaleseView = nil;
}

- (void)dealloc 
{
	[shroudButton release];
	[scheduleLabel release];
	[versionLabel release];
	[OffblastView release];
	[LegaleseView release];
	//[WhatsNextView release];
	//[whatsNextWebview release];
	[infoPopupController release];
	[picker release];
    [super dealloc];
}

/* IBActions */
-(IBAction) viewAboutUs : (id) sender
{
	[infoPopupController release];
    infoPopupController = [[InfoPopupViewController alloc] initWithView:self.OffblastView andTitle:@"About Us"];
	[infoPopupController slideIn];
}
/*
-(IBAction) viewWhatsNext : (id) sender
{
	//Check if there's an active internet connection
	Reachability * reachability = [Reachability reachabilityForInternetConnection];
	if(![reachability isReachable])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[Constants sharedConstants] ErrorMessage_NoInternetConnection] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];
		[alert release];
	}
	//If user has an active internet connection, display what's next? screen
	else 
	{
		[infoPopupController release];
		NSURL* url = [NSURL URLWithString:[[Constants sharedConstants] whatsNextWebpageUrl]];
		[whatsNextWebview loadRequest:[NSURLRequest requestWithURL:url]];
		
		//Hack to remove the WebView's shadow
		self.whatsNextWebview.backgroundColor = [UIColor clearColor];
		for(UIView *wview in [[[self.whatsNextWebview subviews] objectAtIndex:0] subviews]) { 
			if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; } 
		}  
		
		infoPopupController = [[InfoPopupViewController alloc] initWithView:self.WhatsNextView andTitle:@"What's Next?"];
		[infoPopupController slideIn];
	}
}
*/
-(IBAction) viewLegalese : (id) sender
{
	[infoPopupController release];

    infoPopupController = [[InfoPopupViewController alloc] initWithView:self.LegaleseView andTitle:@"Legalese" shouldScroll:YES];
	[infoPopupController slideIn];
}
-(IBAction) viewTellAFriend : (id) sender
{
    if([MFMailComposeViewController canSendMail])
    {
        self.picker = [[[MFMailComposeViewController alloc] init] autorelease];
        NSString* emailSubject = @"Check out this App";
        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
     
        [picker setSubject:emailSubject];
        [picker setMessageBody:[[Constants sharedConstants] tellAFriendMessage] isHTML:YES];   
        picker.navigationBar.barStyle = UIBarStyleBlack; 
        
        iGoTorontoAppDelegate* delegate = (iGoTorontoAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.tabBarController presentModalViewController:self.picker animated:YES];
    }
    else
    {
        UIAlertView* patchAlertView = [[UIAlertView alloc] initWithTitle:@"Can't send email" message:@"You don't have an email address set up." delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [patchAlertView show];
        [patchAlertView release];
    }
}
-(IBAction) viewContactUs : (id) sender
{
    if([MFMailComposeViewController canSendMail])
    {
        self.picker = [[[MFMailComposeViewController alloc] init] autorelease];
    
        #ifdef LITE_VERSION
        NSString* emailSubject = [NSString stringWithFormat:@"iGo Toronto Lite %@ Feedback",[[Constants sharedConstants] versionName] ];
        #else
        NSString* emailSubject = [NSString stringWithFormat:@"iGo Toronto %@ Feedback",[[Constants sharedConstants] versionName] ];
        #endif

        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
        
        [picker setToRecipients:[NSArray arrayWithObject:@"OffblastSoftworks@gmail.com"]];
        [picker setSubject:emailSubject];
        [picker setMessageBody:@"" isHTML:YES];     
        picker.navigationBar.barStyle = UIBarStyleBlack; 

        iGoTorontoAppDelegate* delegate = (iGoTorontoAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.tabBarController presentModalViewController:self.picker animated:YES];
    }
    else
    {
        UIAlertView* patchAlertView = [[UIAlertView alloc] initWithTitle:@"Can't send email" message:@"You don't have an email address set up." delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [patchAlertView show];
        [patchAlertView release];
    }
}
-(IBAction) visitOffblastWebsite : (id) sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [Constants sharedConstants].companyWebpageUrl]];
}
-(IBAction)hide:(id)sender
{
	//Fade out window & shroud
	CABasicAnimation *alphaAnimation = nil;
	alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[alphaAnimation setToValue:[NSNumber numberWithDouble:0.0]];
	[alphaAnimation setFromValue:[NSNumber numberWithDouble:1.0]];
	[alphaAnimation setDuration:0.2f];
	[self.view.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
	[self.shroudButton.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
	
	
	[self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.15];
	[Constants sharedConstants].iGoMenuDisplayed = NO;
}
/* MFMailComposeViewControllerDelegate */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Email us about this... on another device :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
            
            break;
    }

	iGoTorontoAppDelegate* delegate = (iGoTorontoAppDelegate*)[UIApplication sharedApplication].delegate;
	[delegate.tabBarController dismissModalViewControllerAnimated:YES];
}
@end
