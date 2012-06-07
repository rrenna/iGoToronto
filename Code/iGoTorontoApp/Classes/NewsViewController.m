//
//  InfoViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-26.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "AdViewController.h"
#import "AdMobView.h"
#import "iGoGradientButton.h"
#import "GradientView.h"

@implementation NewsViewController
@synthesize NewsView;
@synthesize noFeedsLabel;
@synthesize feedButton;
@synthesize allFilterButton;
@synthesize newsFilterButton;
@synthesize weatherFilterButton;
@synthesize pinnedFilterButton;
@synthesize feedUpdateProgressView;
@synthesize feedsViewController;
@synthesize helpViewController;
@synthesize selectedFeed;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
        isRefreshing = NO;
        dirty = YES;
		//Sign up for Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedsChanged) name:NOTIFICATION_FEED_SETTINGS_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectsChanged) name:NOTIFICATION_OBJECT_PIN_CHANGED object:nil];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //If Lite version setup an Ad
    #ifdef LITE_VERSION
    CGRect newsViewFrame = NewsView.frame;
    newsViewFrame.size.height -= 49;
    NewsView.frame = newsViewFrame;
    
    self.adViewController = [[[AdViewController alloc] init] autorelease];
    self.adViewController.currentViewController = self;
    AdMobView* mobView = [AdMobView requestAdWithDelegate:self.adViewController];
    mobView.frame = CGRectMake(0, 0, 320, 48);
    [self.adSpaceView addSubview:mobView];
    self.adSpaceView.userInteractionEnabled = YES;
    #else
    #endif
    
	//Show help screen on first load
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL showHelpScreen = YES;
    if([prefs objectForKey:@"ShowHelpScreen-News"])
    {
        showHelpScreen = [prefs boolForKey:@"ShowHelpScreen-News"];
    }
    if(showHelpScreen)
    {
        [self displayHelp:@"To edit the information to be displayed in your home screen, press the Subscriptions button."];
        [prefs setBool:NO forKey:@"ShowHelpScreen-News"];
        [prefs synchronize];
    }
    
    //Make filter buttons unrounded
    allFilterButton.type = SQUARE_UNBORDERED;
    newsFilterButton.type = SQUARE_UNBORDERED;
    weatherFilterButton.type = SQUARE_UNBORDERED;
    pinnedFilterButton.type = SQUARE_UNBORDERED;
    
    //Sets the initial feed type filter, and calls for a refresh
    if([prefs integerForKey:@"Home_Filter"])
    {
        switch([prefs integerForKey:@"Home_Filter"])
        {
            case FEED_FILTER_NEWS:
                [self filterChanged:newsFilterButton];
                break;
            case FEED_FILTER_WEATHER:
                [self filterChanged:weatherFilterButton];
                break;
            case FEED_FILTER_PINNED:
                [self filterChanged:pinnedFilterButton];
                break;
            default:
                [self filterChanged:allFilterButton];
                break;
        }
    }
    else
    {
        [self filterChanged:allFilterButton];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    //Need to set the filter buttons to be redrawn - some combination of offscreen
    // reorientation may not have been reflected in the buttons
    [allFilterButton setNeedsDisplay];
    [newsFilterButton setNeedsDisplay];
    [weatherFilterButton setNeedsDisplay];
    [pinnedFilterButton setNeedsDisplay];

    //Ensures the dynamic feeds (Cameras, Stations) that have changed while away from the Home screen
    if(!isRefreshing && dirty)
    {
        [self.feedsViewController loadDynamicSettings];
        [self refresh:nil];
        dirty = NO;
    }
    //Flashes the scrollbar
    [NewsView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.5];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Need to set the filter buttons to be redrawn on orientation
    [allFilterButton setNeedsDisplay];
    [newsFilterButton setNeedsDisplay];
    [weatherFilterButton setNeedsDisplay];
    [pinnedFilterButton setNeedsDisplay];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.NewsView = nil;
    self.feedUpdateProgressView = nil;
    self.noFeedsLabel = nil;
    self.feedButton = nil;
    self.adSpaceView = nil;
    self.allFilterButton = nil;
    self.newsFilterButton = nil;
    self.weatherFilterButton = nil;
    self.pinnedFilterButton = nil;
}
- (void)dealloc 
{    
    [NewsView release];
    [noFeedsLabel release];
    [feedButton release];
    [allFilterButton release];
    [newsFilterButton release];
    [weatherFilterButton release];
    [pinnedFilterButton release];     
	[feedUpdateProgressView release];
    [feedsViewController release];
    [helpViewController release];
	[selectedFeed release];
    [super dealloc];
}
/* IBActions */
-(IBAction)switchToFeedsView:(id)sender
{    
    [self presentModalViewController:feedsViewController animated:YES];
}
-(IBAction)refresh:(id)sender
{
    //Performs all the feed updating in a secondary thread
    int feedNum = [feedsViewController getFilteredActiveFeedTypeNumber];
    if(feedNum == 0)
    {
        //We need to reload the data so the table clears
        [NewsView reloadData];
        self.noFeedsLabel.hidden = NO;
    }
    else
    {
        [self performSelectorInBackground:@selector(getFeedDataForType:) withObject:[NSNumber numberWithInt:feedNum]];
        self.noFeedsLabel.hidden = YES;
    }
}

-(IBAction) filterChanged : (id) sender
{
    allFilterButton.backgroundColor = [UIColor clearColor];
    newsFilterButton.backgroundColor = [UIColor clearColor];
    weatherFilterButton.backgroundColor = [UIColor clearColor];
    pinnedFilterButton.backgroundColor = [UIColor clearColor];
    
    iGoGradientButton* button = (iGoGradientButton*)sender;
    button.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    int filter = -1;
    
    if(sender == allFilterButton)
    {
        filter = FEED_FILTER_ALL;
    }
    else if(sender == newsFilterButton)
    {
        filter = FEED_FILTER_NEWS;
    }
    else if(sender == weatherFilterButton)
    {
        filter = FEED_FILTER_WEATHER;
    }
    else if(sender == pinnedFilterButton)
    {
        filter = FEED_FILTER_PINNED;
    }
    
    [self.feedsViewController setFilter:filter];
    
    //Set in NSUserDefaults as last selected filter
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:filter forKey:@"Home_Filter"];
    [prefs synchronize];

    [self refresh:nil];
}
/* Custom Methods */
-(void)setIsRefreshingYES
{
    isRefreshing = YES;
    //Disable Feeds button
    self.feedButton.enabled = NO;
}
-(void)setIsRefreshingNO
{
    isRefreshing = NO;
    //Enable Feeds button
    self.feedButton.enabled = YES;
}
-(void)haveFeedUpdateProgressFadeIn
{
	[feedUpdateProgressView setProgress:0.0];
	CABasicAnimation* fadeInOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeInOpacityAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
	[fadeInOpacityAnimation setToValue:[NSNumber numberWithFloat:1.0]];
	[fadeInOpacityAnimation setDuration:0.5];
	[feedUpdateProgressView.layer addAnimation:fadeInOpacityAnimation forKey:@"fadeInOpacityAnimation"];
		feedUpdateProgressView.alpha = 1.0;
}
-(void)haveFeedUpdateProgressFadeOut
{
	CABasicAnimation* fadeOutOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeOutOpacityAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
	[fadeOutOpacityAnimation setToValue:[NSNumber numberWithFloat:0.0]];
	[fadeOutOpacityAnimation setDuration:0.5];
	[feedUpdateProgressView.layer addAnimation:fadeOutOpacityAnimation forKey:@"fadeOutOpacityAnimation"];
	feedUpdateProgressView.alpha = 0.0;
}
-(void)setFeedUpdateProgressWithNSNumber:(NSNumber*)progress
{
	[feedUpdateProgressView setProgress:[progress floatValue]];
}
-(void)getFeedDataForType:(NSNumber*)typeIndex
{
    //Alerts the main thread that the home screen is refreshing, and not to attempt anything that will change the datasource
    [self performSelectorOnMainThread:@selector(setIsRefreshingYES) withObject:nil waitUntilDone:YES];
    
	//Don't do anything if there are no feed type's to update
	if([typeIndex intValue] > 0)
	{
		NSAutoreleasePool* pool = [NSAutoreleasePool new];
		
		//Check if there's an active internet connection
		Reachability * reachability = [Reachability reachabilityForInternetConnection];
		if(![reachability isReachable])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"It doesn't appear that you have an active internet connection. Please try again."
														   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			[alert show];
			[alert release];
		}
			
		TwitterParser* newsTwitterParser = [TwitterParser new];
		//UI Updates must be performed on the main thread
		float currentProgress = 0.0;
		float sectionProgressWeight = 1.0 / [typeIndex intValue];
		//Fade in progress view
		[self performSelectorOnMainThread:@selector(haveFeedUpdateProgressFadeIn) withObject:nil waitUntilDone:NO];
		 
		for(int i =0; i< [typeIndex intValue];i++)
		{
			FeedType* feedType = [feedsViewController getFeedTypeAtRelativeIndex:i];
			float feedProgressWeight = sectionProgressWeight / [feedType.Feeds count];
			
			for(Feed* feed in feedType.Feeds)
			{
				currentProgress += feedProgressWeight;
				//UI Updates must be performed on the main thread
				[self performSelectorOnMainThread:@selector(setFeedUpdateProgressWithNSNumber:) withObject:[NSNumber numberWithFloat:currentProgress] waitUntilDone:NO];
				
				if(feed.Enabled)
				{
					//If the feed has a last updated date recorded...
					if(feed.LastUpdated)
					{
						NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate: feed.LastUpdated];
						// ... and the last update was less than a minute ago
						if(interval <= 60)
						{
							// ... skip
							continue;
						}
					}
                    //Logic for declaring the last updated time
					if(feed.Source == FEED_SOURCE_TWITTER)
                    {
                        feed.latestUpdates = [newsTwitterParser getLast:1 TweetsForUser:feed.Url];
                        if([feed.latestUpdates count] == 0)
                        {
                            feed.LastUpdated = [NSDate distantPast];
                        }
                        else
                        {
                            feed.LastUpdated = [NSDate date];
                            
                        }
                    }
                    else
                    {
                        feed.LastUpdated = [NSDate date];
                    }
                    
                    feed.Dirty = YES;
				}
			}
			feedType.isDataLoaded = YES;
            [NewsView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		}
		//Fade out progress view
		[self performSelectorOnMainThread:@selector(haveFeedUpdateProgressFadeOut) withObject:nil waitUntilDone:NO];
	
    [newsTwitterParser release];
	[NewsView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [pool drain];
	}
    
    //Let's the main thread know the page is done refreshing
    [self performSelectorOnMainThread:@selector(setIsRefreshingNO) withObject:nil waitUntilDone:YES];
}
-(void)objectsChanged
{
    dirty = YES;
}
-(void)feedsChanged
{
    [NewsView reloadData]; 
	[self refresh:nil];
 }
-(int) sizeForStringLength : (NSString*)s
{
	if(s)
	{
		int length = [s length];
		if(length > 100)
        {
            return 108;
        }
		return 98;
	}
	return 103;
}
/* Twitter Feed Delegate methods */
-(void)dataParsedForFeed:(Feed*)feed
{
}
/* UITableView Delegate & Datasource methods */
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    FeedType* feedType = [feedsViewController getFeedTypeAtRelativeIndex:section];
    if(feedType.isDataLoaded)
    {
        return [feedType getEnabledFeedNumber];
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedType* feedType = [feedsViewController getFeedTypeAtRelativeIndex:indexPath.section];
    Feed* feed = [feedType getFeedAtRelativeIndex:indexPath.row];
    
    if(feed.latestUpdates && [feed.latestUpdates count] > 0)
    {
        NSString* latestUpdate = [feed.latestUpdates objectAtIndex:0];
        return [self sizeForStringLength: latestUpdate];
    }
	return [self sizeForStringLength: nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    FeedType* feedType = [feedsViewController getFeedTypeAtRelativeIndex:indexPath.section];
    Feed* feed = [feedType getFeedAtRelativeIndex:indexPath.row];
    NSString* identifier = feed.Url;
	UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(!newCell)
    {
        newCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease]; 
    }
        
    //Check if valid
    BOOL valid = YES;
    if(feed.Source == FEED_SOURCE_TWITTER)
    {
        valid = (feedType.isDataLoaded && feed.latestUpdates);
    }
    else
    {
        valid = feedType.isDataLoaded;
    }
    
    if(valid)
    {
        if(feed.Dirty)
        {
        //Reset content
        [newCell.textLabel setText:nil];
        [newCell.detailTextLabel setText:nil];
        [newCell setAccessoryView:nil];
        [newCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //Figures out which image to display as a sidebar image
        [feed.interpreter interpret];
        
        //If the feed has updates or a custom content view has been generated, display
        if([feed.latestUpdates count] > 0 || feed.interpreter.content)
        {
            //Feed interpreted
            feed.Dirty = NO;
            const int padding = 5;
            const int headerHeight = 25;
                
            //Enable selection on selectable content
            if([feedType.Name isEqualToString:@"GO Train Stations"])
            {
                [newCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                [newCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            }
            else if([feedType.Name isEqualToString:@"Traffic Cameras"])
            {
                [newCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
            else
            {
                 [newCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            //If there is custom content assigned, display
            if(feed.interpreter.content)
            {
                    int imageWidth = 0;
                    int imageDimension = 90;
                    
                    //Set Image
                    UIImage* leftImage = feed.interpreter.image;
                    //Calculations for body text
                    int imageSize = (leftImage) ? imageDimension : 0;
                    
                    if(leftImage)
                    {
                        UIImageView* imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(padding,  padding, imageDimension, imageDimension)] autorelease];
                        [imageView setContentMode:UIViewContentModeScaleAspectFill];
                        [imageView setImage:leftImage];
                        
                        iGoTorontoAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
                        if(delegate.QualityMode != QUALITY_LOW)
                        {
                            imageView.layer.cornerRadius = 5.0;
                        }
                        //Give a 2px border if iPad
                        if([Constants sharedConstants].deviceProfile == IPAD_PROFILE)
                        {
                            imageView.layer.borderWidth = 2.0;
                        }
                        else
                        {
                             imageView.layer.borderWidth = 1.0;
                        }
                        
                        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                        imageView.clipsToBounds = YES;
                        [newCell.contentView addSubview:imageView];
                        imageWidth += imageDimension + padding;
                    }
                    
                    [newCell.contentView addSubview:feed.interpreter.content];
                    feed.interpreter.content.frame = CGRectMake(padding + imageWidth, 0, newCell.frame.size.width - padding - padding - padding - imageWidth, imageDimension);
                }
                //Otherwise construct a label out of the latest update
                else
                {
                    int imageDimension = 64;
                    NSString* latestUpdate = [feed.latestUpdates objectAtIndex:0];
                    int updateHeight = [self sizeForStringLength:latestUpdate];
                    UIImage* leftImage = feed.interpreter.image;
                    
                    //Calculations for body text
                    int imageSize = (leftImage) ? imageDimension : 0;
                    
                    if(leftImage)
                    {
                        UIImageView* imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(padding, headerHeight + padding, imageDimension, imageDimension)] autorelease];
                        [imageView setContentMode:UIViewContentModeScaleAspectFit];
                        [imageView setImage:leftImage];
                        [newCell.contentView addSubview:imageView];
                    }
                    
                    UILabel* feedNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, newCell.frame.size.width, headerHeight)] autorelease];
                    [feedNameLabel setText:feed.Name];
                    [feedNameLabel setTextColor:[UIColor whiteColor]];
                    [feedNameLabel setBackgroundColor:[UIColor clearColor]];					
                  
                    UILabel* updateBody;
                    //Supported on iOS 3.2 devices and above
                    Class NSMutableAttributedStringReference = NSClassFromString(@"NSMutableAttributedString");
                    if(NSMutableAttributedStringReference)
                    {
                        CGRect detailTextFrame = CGRectMake(imageSize + padding,
                                                            headerHeight,
                                                            newCell.contentView.frame.size.width - imageSize - ( padding * 2),
                                                            updateHeight);
                        
                        NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithString:latestUpdate] autorelease];
                        [attributedString setTextColor:[UIColor lightGrayColor]];
                        [attributedString setFontName:[Constants sharedConstants].cellTextFontSmall.familyName size:[Constants sharedConstants].cellTextFontSmall.pointSize + 2];
            
                        updateBody = [[[OHAttributedLabel alloc] initWithFrame:detailTextFrame] autorelease];
                        [updateBody setBackgroundColor:[UIColor clearColor]];
                        
                        if(feed.interpreter.rangeOfFirstURL.location != NSNotFound)
                        {
                            [attributedString setTextColor:[UIColor whiteColor] range:feed.interpreter.rangeOfFirstURL];
                            [attributedString setFontFamily:@"Helvetica Neue" size:[Constants sharedConstants].cellTextFontSmall.pointSize + 2 bold:YES italic:YES range:feed.interpreter.rangeOfFirstURL];
                        }
                        
                        [updateBody setAttributedText:attributedString];
                    }
                    else 
                    {

                        CGRect detailTextFrame = CGRectMake(imageSize + padding,
                                                            5,
                                                            newCell.contentView.frame.size.width - imageSize - ( padding * 2),
                                                            updateHeight);
                        
                
                        updateBody = [[[UILabel alloc] initWithFrame:detailTextFrame] autorelease];
                        [updateBody setFont:[Constants sharedConstants].cellTextFontMedium];
                        [updateBody setNumberOfLines:0];
                        [updateBody setTextColor:[UIColor lightGrayColor]];
                        [updateBody setBackgroundColor:[UIColor clearColor]];
                        [updateBody setText:latestUpdate];
                    }
                    //Set autoresize mask to updateBody, to support resizing on iPad reorientation
                    [newCell.contentView addSubview:feedNameLabel];
                    [newCell.contentView addSubview:updateBody];
                
                    updateBody.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                }
                
            }
            else 
            {
                [newCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [newCell.detailTextLabel setText:@"Could not retrieve this Feed at this time."];
            }
            }
        }
        else
        {
            [newCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [newCell.textLabel setFont:[Constants sharedConstants].cellTextFontSmall];
            [newCell.textLabel setTextColor:[UIColor whiteColor]];
            [newCell.textLabel setBackgroundColor:[UIColor clearColor]];
            [newCell.textLabel setText:@"Loading..."];
            UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]; 
            [activityView startAnimating];
            [newCell setAccessoryView:activityView];        
            [activityView release];
        }

        return newCell;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	FeedType* feedType = [feedsViewController getFeedTypeAtRelativeIndex:indexPath.section];
    if(feedType)
	{
		Feed* feed = [feedType getFeedAtRelativeIndex:indexPath.row];
        
        //Handle Pinned Go Train Stations
        if([feedType.Name isEqualToString:@"GO Train Stations"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_STATION_VIEW object:feed.Name];
        }
        else if([feedType.Name isEqualToString:@"Traffic Cameras"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAMERA_VIEW object:feed.Name];
        }
        
		//If there is a URL in this update, present an alert and store it
		if(feed.interpreter.firstURL)
		{
			self.selectedFeed = feed;
			UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Leaving iGo Toronto" message:@"Would you like to visit this url?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil] autorelease];
			[alert show];
		}
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString* buttonText = [alertView buttonTitleAtIndex:buttonIndex];
	if(![buttonText isEqualToString:@"No"])
	{
		if(self.selectedFeed)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.selectedFeed.interpreter.firstURL]];
		}
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    GradientView* gradientView = [[[GradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 27) andBeginningColour:[UIColor colorWithRed:0.306 green:0.494 blue:0.722 alpha:1.0] andEndingColour:[UIColor colorWithRed:0.051 green:0.298 blue:0.702 alpha:1.0]] autorelease];
    gradientView.layer.borderWidth = 1.0;
    
    UILabel* headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(4, 0, tableView.bounds.size.width, 27)] autorelease];  
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[Constants sharedConstants].headerTextFont];
    [headerLabel setTextColor:[UIColor whiteColor]];
    
    FeedType *feedType = [feedsViewController getFeedTypeAtRelativeIndex:section];
    
    [headerLabel setText:feedType.Name];
    [gradientView addSubview:headerLabel];
    return gradientView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [feedsViewController getFilteredActiveFeedTypeNumber];
}
@end
