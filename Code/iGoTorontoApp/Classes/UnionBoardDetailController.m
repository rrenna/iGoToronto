    //
//  GoTrainDetailView.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UnionBoardDetailController.h"


@implementation UnionBoardDetailController

@synthesize url;
@synthesize webView;
@synthesize activityView;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    CGRect frame; frame.origin.x = 0; frame.origin.y = 0;
	frame.size = [Constants sharedConstants].screenContentSize;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.center = self.view.center;
	[activityView startAnimating];
    [self.view addSubview:activityView];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self performSelectorInBackground:@selector(retrieveData) withObject:nil];
	[super viewDidLoad];
}
- (void)didReceiveMemoryWarning 
{
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
	[webView release];
    [activityView release];
	[url release];
    [super dealloc];
}
/* Custom Methods */
-(void)addWebviewWithHtml:(NSString*)html
{
    [html retain];
	CGRect parentFrame = self.view.frame;
	
    CGRect frame = CGRectMake((int)( parentFrame.size.width * 0.03 ), (int)( parentFrame.size.height * 0.03 ),parentFrame.size.width, (int)( parentFrame.size.height * 0.9 ));
    webView = [[UIWebView alloc] initWithFrame:frame];
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    webView.userInteractionEnabled = NO;
    [webView  loadHTMLString:html baseURL:nil];
    [self.view addSubview:webView];   
    [html release];
}
-(void)retrieveData
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	NSURL * uri = [[NSURL alloc] initWithString:url];
	ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:uri];
	[uri release];
	
	[request setNumberOfTimesToRetryOnTimeout:2];
	[request startSynchronous];
	
	NSString *response = [request responseString];
	[request release];

	UIFont* font = [Constants sharedConstants].cellTextFont;
	NSString* fontString = [NSString stringWithFormat:@"body { color:white; font-family:%@; font-size:%fpx; } #table1 { font-size:%fpx; }",font.familyName,font.pointSize,font.pointSize];
	
    response = [response stringByReplacingOccurrencesOfString:@"<font face=\"Verdana\" size=\"1\">" withString:@""];
    response = [response stringByReplacingOccurrencesOfString:@"<font face=\"Verdana\" size=\"2\">" withString:@""];
    response = [response stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    response = [response stringByReplacingOccurrencesOfString:@"row {font-family: Verdana; font: 2}" withString:fontString];
    response = [response stringByReplacingOccurrencesOfString:@"<body>" withString:@"<body style=\"background-color: transparent\">"];	
    response = [response stringByReplacingOccurrencesOfString:@"<img border=\"0\" src=\"gologo.gif\" width=\"125\" height=\"40\">" withString:@""];
    response = [response stringByReplacingOccurrencesOfString:@"<a href=\"default.aspx\"><br>Back</a>" withString:@""];
	
	//Remove 24 hour time embedded in html
	response = [response stringByReplacingOccurrencesOfRegex:@"\\b\\d{1,2}\\:\\b\\d{1,2}\\b" withString:@""];
	//Places each stop on a new line
	response = [response stringByReplacingOccurrencesOfString:@" - " withString:@"<br/>"];
	
	
    if(response)
    {
        [self performSelectorOnMainThread:@selector(addWebviewWithHtml:) withObject:response waitUntilDone:NO];        
    }  
    else
    {
        //TODO : Spit out error
    }
    [self.activityView stopAnimating];
    [pool drain];
}
@end
