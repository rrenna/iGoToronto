    //
//  CameraViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "CameraViewController.h"
#import "iGoGradientButton.h"

@implementation CameraViewController
@synthesize cameraImageView;
@synthesize cameraNameLabel;
@synthesize cameraStatusLabel;
@synthesize showRouteButton;
@synthesize pinButton;
@synthesize cameraTable;
@synthesize descriptionCell;
@synthesize pinCell;
@synthesize mapCell;
@synthesize Camera;

-(id)initWithCameraName:(NSString*)cameraName
{
    CDCamera* camera = nil;
    
    iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = delegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCamera" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"Name = %@",cameraName]];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if([fetchedObjects count] > 0)
    {
        camera = [fetchedObjects objectAtIndex:0];
    }
    
    [fetchRequest release];

    return [self initWithCamera:camera];
}
-(id)initWithCamera:(CDCamera*)camera
{
	NSMutableString *infoPopupViewControllerNibName = [NSMutableString stringWithString:@"CameraViewController"];
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
			[infoPopupViewControllerNibName appendString:@"-iPad"];
	}
	
	self = [super initWithNibName:infoPopupViewControllerNibName bundle:nil];
	if(self)
	{
		self.Camera = camera;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
	self.cameraNameLabel.text = Camera.Name;
    //Set label on Pin button
    [self checkForPinnedStatus];
	
    //Set tableview background to be clear
    cameraTable.backgroundColor = [UIColor clearColor];
    cameraTable.separatorColor = [UIColor colorWithWhite:0.2 alpha:0.25];
    //cameraTable.separatorColor = [UIColor blackColor];
	//iOS 3.2 and above have a background view, checks for background view to maintain backwards compatibility
	if ([cameraTable respondsToSelector:@selector(backgroundView)])
	{
		cameraTable.backgroundView = nil;
	}
    
    
    NSString * urlString;
	//If the "relative" url contains a fully formed url string, ignore the base url to be appended
	if([self.Camera.RelativeUrl rangeOfString:@"http://"].location != NSNotFound)
	{
		urlString = self.Camera.RelativeUrl;
	}
	else 
	{
		urlString = [NSString stringWithFormat:@"%@%@",[self.Camera.Roadway BaseUrl],self.Camera.RelativeUrl];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloadedSuccessfully:) name:NOTIFICATION_FILE_DOWNLOADED_SUCCESSFULLY object:nil];
	[[DownloadCenter sharedCenter] requestFileWithUrlString:urlString];

}
-(void)viewDidAppear:(BOOL)animated
{
    
    
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

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[cameraImageView release];
	[cameraNameLabel release];
	[cameraStatusLabel release];
    [showRouteButton release];
    [pinButton release];
    [cameraTable release];
    [descriptionCell release];
    [pinCell release];
    [mapCell release];    
	[Camera release];
    [super dealloc];
}
/* IBActions */
- (IBAction)viewMap:(id)sender
{
    NSString* latLong = [NSString stringWithFormat:@"%f,%f",[self.Camera.Latitude doubleValue],[self.Camera.Longitude doubleValue]];
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",latLong];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apiUrlStr]];
}
- (IBAction)pinToHome:(id)sender
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    //If camera url is in user defaults, it's already pinned and must be unpinned
    if([prefs objectForKey:Camera.RelativeUrl])
    {
        //Removed key
        [prefs removeObjectForKey:Camera.RelativeUrl];
        //Now remove camera from dictionary
        
        NSDictionary* pinnedCameras = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_cameras"];
        NSMutableDictionary* newPinnedCameras = [[NSMutableDictionary alloc] initWithDictionary:pinnedCameras];
        [newPinnedCameras removeObjectForKey:self.Camera.Name];
        [[NSUserDefaults standardUserDefaults] setObject:newPinnedCameras forKey:@"pinned_cameras"];
    }
    //If camera url is not in user defaults, it must be pinned 
    else
    {
        
        NSDictionary* pinnedCameras = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_cameras"];
        if(!pinnedCameras)
        {
            pinnedCameras = [[[NSDictionary alloc] init] autorelease];
        }
   
        NSMutableDictionary* newPinnedCameras = [[NSMutableDictionary alloc] initWithDictionary:pinnedCameras];
        [newPinnedCameras setObject:self.Camera.RelativeUrl forKey:self.Camera.Name];
        [[NSUserDefaults standardUserDefaults] setObject:newPinnedCameras forKey:@"pinned_cameras"];
        //Also, enable this feed by default
        [prefs setBool:YES forKey:self.Camera.RelativeUrl];
    }
    [prefs synchronize];
    
    //Post pin notification
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OBJECT_PIN_CHANGED object:nil];
    
    //Refresh the Pinned status
    [self checkForPinnedStatus];
}
/* Template Methods */
-(void)layoutControls
{
    CGPoint currentShowRouteCenter = self.showRouteButton.center;
    CGPoint oldCenter = currentShowRouteCenter;
    
    currentShowRouteCenter.x = self.view.center.x;
    CGRect viewFrame = self.view.frame;
    CGPoint newCenter = currentShowRouteCenter;
    self.showRouteButton.center = currentShowRouteCenter;
}
/* Custom Methods */
-(void)presentCameraImage 
{
	NSString * urlString;
	//If the "relative" url contains a fully formed url string, ignore the base url to be appended
	if([self.Camera.RelativeUrl rangeOfString:@"http://"].location != NSNotFound)
	{
		urlString = self.Camera.RelativeUrl;
	}
	else 
	{
		urlString = [NSString stringWithFormat:@"%@%@",[self.Camera.Roadway BaseUrl],self.Camera.RelativeUrl];
	}

	UIImage* cameraImage = [[DownloadCenter sharedCenter] retrieveImageNamed:urlString];
	if(cameraImage)
	{
		self.cameraStatusLabel.hidden = YES;
		[self.cameraImageView setImage:cameraImage];
	}
	else 
	{
		self.cameraStatusLabel.text = @"Camera is down";
	}
}	
-(void)checkForPinnedStatus
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    //If camera url is in user defaults, it's already pinned and must be unpinned
    if([prefs objectForKey:Camera.RelativeUrl])
    {
        //Camera is pinned
        [pinButton setTitle:@"Unpin" forState:UIControlStateNormal];
        pinButton.gradientStartColor = [UIColor colorWithRed:0.306 green:0.494 blue:0.722 alpha:1.0];
        pinButton.gradientEndColor = [UIColor colorWithRed:0.051 green:0.298 blue:0.702 alpha:1.0];
    }
    //If camera url is not in user defaults, it can be pinned
    else
    {
        //Camera is pinned
        [pinButton setTitle:@"Pin" forState:UIControlStateNormal];
        pinButton.gradientStartColor = nil;
        pinButton.gradientEndColor = nil;

    }
    [self.pinButton setNeedsDisplay];
}
/* Download Methods */
-(void)imageDownloadedSuccessfully : (NSNotification*) notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self presentCameraImage];
}
@end
