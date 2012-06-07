//
//  Constants.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-19.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//
#import "Constants.h"

@implementation Constants
static Constants* _sharedConstants = nil;

@synthesize twelveHourDateFormatter;
@synthesize deviceProfile;
@synthesize orientation;
@synthesize goStopListingWidthPerStop;
@synthesize screenContentSize;
@synthesize portraitOrientationSupport;
@synthesize landscapeOrientationSupport;
@synthesize headerTextFont;
@synthesize cellTextFont;
@synthesize cellTextFontSmall;
@synthesize cellTextFontMedium;
@synthesize stopTextFont;
@synthesize stopTextFontSmall;
@synthesize headerBackgroundColour;
@synthesize checkmarkImage;
@synthesize twitterBirdImage;
@synthesize ErrorMessage_NoInternetConnection;
@synthesize iGoMenuDisplayed;
@synthesize igoMenuViewController;
@synthesize weatherFeedType;
@synthesize newsFeedType;
@synthesize trafficFeedType;
@synthesize appFeedType;
@synthesize versionName;
@synthesize updateReleaseNotes;
@synthesize tellAFriendMessage;
@synthesize whatsNextWebpageUrl;
@synthesize companyWebpageUrl;
@synthesize iTunesAppUrl;
@synthesize lastUpdatedSchedules;

+(void)load
{
	iPhoneLandscapeContentSize = CGSizeMake(480, 320);
	iPhonePortraitContentSize = CGSizeMake(320,480);
	iPadLanscapeContentSize = CGSizeMake(1024,768);
	iPadPortraitContentSize = CGSizeMake(768, 1024);
}
+(Constants*)sharedConstants
{
	@synchronized([Constants class])
	{
		if (!_sharedConstants)
			[[self alloc] init];
		return _sharedConstants;
	}
	return nil;
}
+(id)alloc
{
	@synchronized([Constants class])
	{
		NSAssert(_sharedConstants == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedConstants = [super alloc];
		return _sharedConstants;
	}
	return nil;
}
-(void)orientationChanged:(NSNotification*)notification
{
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	BOOL validOrientation = NO;
	
	//portraitOrientationSupport
	if(deviceOrientation)
	{
		if(
			(deviceOrientation == UIDeviceOrientationPortrait || deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
		   &&
		   self.portraitOrientationSupport
		   )
		{
			validOrientation = YES;
			self.orientation = deviceOrientation;
		}
		else if(
		   (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)
		   &&
		   self.landscapeOrientationSupport
		   )
		{
			validOrientation = YES;
			self.orientation = deviceOrientation;
		}
	
	}
	
	if(!validOrientation)
	{
		self.orientation = [UIApplication sharedApplication].statusBarOrientation;
	}

	[self calculateScreenArea];
}
-(void)calculateScreenArea
{
	if(self.deviceProfile == IPHONE_PROFILE)
	{
		if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			self.screenContentSize = iPhonePortraitContentSize;
		}
		else
		{
			self.screenContentSize = iPhoneLandscapeContentSize;
		}
	}
	else if(self.deviceProfile == IPAD_PROFILE)
	{
		if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			self.screenContentSize = iPadPortraitContentSize;
		}
		else
		{
			self.screenContentSize = iPadLanscapeContentSize;
		}
	}
}
-(id)init {
	self = [super init];
	if (self != nil) 
	{
		NSAutoreleasePool* pool = [NSAutoreleasePool new];
		//Helper Objects
		self.twelveHourDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[twelveHourDateFormatter setDateFormat:@"hh:mm a"];
		[twelveHourDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
		//UI Constants
		//Choose a device profile
		self.deviceProfile = IPHONE_PROFILE;
		if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)]) {
			if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
				self.deviceProfile = IPAD_PROFILE;
			}
		}
		//The device profile decides the font size constants
		int verySmallFontSize, smallFontSize,mediumFontSize,largeFontSize,veryLargeFontSize;
		if(self.deviceProfile == IPHONE_PROFILE)
		{
			self.portraitOrientationSupport = YES;
            self.goStopListingWidthPerStop = 120;
			verySmallFontSize = 10; 
			smallFontSize = 12;
			mediumFontSize = 13;
			largeFontSize = 16;
			veryLargeFontSize = 18;
		}
		else 
		{
			self.portraitOrientationSupport = YES;
			self.landscapeOrientationSupport = YES;
            self.goStopListingWidthPerStop = 190;
			verySmallFontSize = 14; 
			smallFontSize = 18;
			mediumFontSize = 18;
			largeFontSize = 20;
			veryLargeFontSize = 22;
		}
		//Sign up for rotation change updates
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
		//Set initial orientation & screen content size
		[self orientationChanged:nil];
		
		self.headerTextFont = [UIFont fontWithName:@"Helvetica" size:largeFontSize];
		self.cellTextFont = [UIFont fontWithName:@"Helvetica" size:largeFontSize];
		self.cellTextFontSmall = [UIFont fontWithName:@"Helvetica" size:smallFontSize];
		self.cellTextFontMedium  = [UIFont fontWithName:@"Helvetica" size:mediumFontSize];
		self.stopTextFont = [UIFont fontWithName:@"Helvetica" size:smallFontSize];
		self.stopTextFontSmall = [UIFont fontWithName:@"Helvetica" size:verySmallFontSize];
		self.headerBackgroundColour = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
		self.checkmarkImage = [UIImage imageNamed:@"CheckmarkButton"];
		self.twitterBirdImage = [UIImage imageNamed:@"twitterBird"];
		//Text Constants
		ErrorMessage_NoInternetConnection = @"It doesn't appear that you have an active internet connection. Please try again.";
		// Application Information constants
		self.versionName = @"1.3.5";
		self.lastUpdatedSchedules = @"June 2012";

        //IGO PRO RELEASE NOTES
        self.updateReleaseNotes = @"\n -Updated GO schedule \n - Updated Kitchener Line (formally Georgetown) \n - Assorted tweaks";
       
        //IGO PRO ITUNES LINK
        self.iTunesAppUrl = @"http://itunes.apple.com/ca/app/igo-toronto/id409407157?mt=8";
    
		self.companyWebpageUrl = @"http://www.offblastsoftworks.com";
		self.tellAFriendMessage = [NSString stringWithFormat:@"Check out this App, iGo Toronto.<br/><br/><a href=\"%@\">iTunes Link</a> <br/> <a href=\"http://www.offblastsoftworks.com\\iGoToronto\\\">App's Site</a>",self.iTunesAppUrl];
		self.whatsNextWebpageUrl = @"http://www.offblastsoftworks.com/iGoToronto/iPhone-next";
		//Application State
		self.iGoMenuDisplayed = NO;
		//Feed Types
		self.weatherFeedType = [[[FeedType alloc] initWithName:@"Weather"] autorelease];
        self.weatherFeedType.associatedFilter = FEED_FILTER_WEATHER;
        
        self.newsFeedType = [[[FeedType alloc] initWithName:@"News"] autorelease];
        self.newsFeedType.associatedFilter = FEED_FILTER_NEWS;
        
		self.trafficFeedType = [[[FeedType alloc] initWithName:@"Transit"] autorelease];
        self.trafficFeedType.associatedFilter = FEED_FILTER_NEWS;
        
		self.appFeedType = [[[FeedType alloc] initWithName:@"Apps"] autorelease];	
        self.appFeedType.associatedFilter = FEED_FILTER_NEWS;
		//Shared Interface Elements
		
		//iGoMenuViewController
		NSMutableString *iGoMenuViewNibName = [NSMutableString stringWithString:@"iGoMenuView"];
		if(self.deviceProfile == IPAD_PROFILE)
		{
			[iGoMenuViewNibName appendString:@"-iPad"];
		}
		self.igoMenuViewController = [[[iGoMenuViewController alloc] initWithNibName:iGoMenuViewNibName bundle:nil] autorelease];
		
		[pool drain];
	}
	return self;
}

@end