//
//  FeedsViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-28.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedsViewController.h"
#import "CameraFeedInterpreter.h"
#import "GoStationFeedInterpreter.h"

@implementation FeedsViewController
@synthesize feedLists;
@synthesize feedTable;

-(void)awakeFromNib
{
	self->dirty = YES; 
    //Default filter
    self->filter = FEED_FILTER_ALL;
    feedLists = [NSMutableDictionary new];
    activeFeedTypes = [NSMutableArray new];

    [feedLists setObject:[Constants sharedConstants].weatherFeedType forKey:[Constants sharedConstants].weatherFeedType.Name];
    [feedLists setObject:[Constants sharedConstants].trafficFeedType forKey:[Constants sharedConstants].trafficFeedType.Name];
    [feedLists setObject:[Constants sharedConstants].newsFeedType forKey:[Constants sharedConstants].newsFeedType.Name];
    [feedLists setObject:[Constants sharedConstants].appFeedType forKey:[Constants sharedConstants].appFeedType.Name];
    
	if([[Constants sharedConstants].weatherFeedType.Feeds count] == 0)
	{
		//Weather feeds
        //If Lite version - no weather feeds
        #ifdef LITE_VERSION
        #else
        Feed* wxtoFeed = [[Feed alloc] initWithName:@"Environment Canada - Toronto Weather" Url:@"wxto" andSource:FEED_SOURCE_TWITTER];
		Feed* uvTorontoFeed = [[Feed alloc] initWithName:@"Environment Canada - Toronto UV Index" Url:@"uv_toronto" andSource:FEED_SOURCE_TWITTER];
		Feed* wxhamiltonFeed = [[Feed alloc] initWithName:@"Environment Canada - Hamilton Weather" Url:@"wxhamilton" andSource:FEED_SOURCE_TWITTER];	
		[[Constants sharedConstants].weatherFeedType.Feeds addObject:wxtoFeed];
		[[Constants sharedConstants].weatherFeedType.Feeds addObject:uvTorontoFeed];
		[[Constants sharedConstants].weatherFeedType.Feeds addObject:wxhamiltonFeed];
		[wxtoFeed release];
		[uvTorontoFeed release];
		[wxhamiltonFeed release];
        //News Feeds
        //If Lite version - no news feeds
		Feed* breakingNewsFeed = [[Feed alloc] initWithName:@"Breaking News Update" Url:@"bnu" andSource:FEED_SOURCE_TWITTER];
        Feed* CP24Feed = [[Feed alloc] initWithName:@"City Pulse 24" Url:@"CP24" andSource:FEED_SOURCE_TWITTER];
        Feed* CTVTorontoFeed = [[Feed alloc] initWithName:@"CTV Toronto News" Url:@"CTVtoronto" andSource:FEED_SOURCE_TWITTER];
        Feed* ReutersFeed = [[Feed alloc] initWithName:@"Reuters Top News" Url:@"Reuters" andSource:FEED_SOURCE_TWITTER];
        [[Constants sharedConstants].newsFeedType.Feeds addObject:CP24Feed];
		[[Constants sharedConstants].newsFeedType.Feeds addObject:breakingNewsFeed];
        [[Constants sharedConstants].newsFeedType.Feeds addObject:CTVTorontoFeed];
        [[Constants sharedConstants].newsFeedType.Feeds addObject:ReutersFeed];
		[CP24Feed release];
        [breakingNewsFeed release];
        [CTVTorontoFeed release];
        [ReutersFeed release];
        #endif
		//Traffic Feeds
		//GTAA
        Feed* gtaaFeed = [[Feed alloc] initWithName:@"GTAA - Airport News" Url:@"TorontoPearson" andSource:FEED_SOURCE_TWITTER];
		//MTO
        Feed* mtoFeed = [[Feed alloc] initWithName:@"MTO - Road Conditions" Url:@"_mto" andSource:FEED_SOURCE_TWITTER];
        Feed* mtoAlertsFeed = [[Feed alloc] initWithName:@"MTO - Alerts" Url:@"MTOAlerts" andSource:FEED_SOURCE_TWITTER];
        Feed* mtoQEWTBFeed = [[Feed alloc] initWithName:@"MTO - QEW Toronto to Burlington" Url:@"qew1" andSource:FEED_SOURCE_TWITTER];
        Feed* mtoQEWBTFeed = [[Feed alloc] initWithName:@"MTO - QEW Burlington to Toronto" Url:@"qew2" andSource:FEED_SOURCE_TWITTER];
        //Feed* mto400Feed = [[Feed alloc] initWithName:@"MTO - Highway 400" Url:@"hwy400" andSource:FEED_SOURCE_TWITTER];
        Feed* mto401Feed = [[Feed alloc] initWithName:@"MTO - Highway 401" Url:@"hwy401" andSource:FEED_SOURCE_TWITTER];
        //Feed* mto403Feed = [[Feed alloc] initWithName:@"MTO - Highway 403" Url:@"hwy403" andSource:FEED_SOURCE_TWITTER];
        //Feed* mto404Feed = [[Feed alloc] initWithName:@"MTO - Highway 404" Url:@"hwy404" andSource:FEED_SOURCE_TWITTER];
        Feed* mto410Feed = [[Feed alloc] initWithName:@"MTO - Highway 410" Url:@"hwy410" andSource:FEED_SOURCE_TWITTER];
        //Feed* mto427Feed = [[Feed alloc] initWithName:@"MTO - Highway 427" Url:@"hwy427" andSource:FEED_SOURCE_TWITTER];
        //TTC
		Feed* ttcFeed = [[Feed alloc] initWithName:@"TTC - Toronto Transit" Url:@"ttcupdate" andSource:FEED_SOURCE_TWITTER];
        Feed* ttcNoticesFeed = [[Feed alloc] initWithName:@"TTC - Notices" Url:@"TTCNotices" andSource:FEED_SOURCE_TWITTER];
        //GO
		Feed* unofficialGoFeed = [[Feed alloc] initWithName:@"GO - Unofficial GO Transit Updates" Url:@"GO_Updates" andSource:FEED_SOURCE_TWITTER];
		Feed* goFeed = [[Feed alloc] initWithName:@"GO - Official GO Transit News" Url:@"GetontheGO" andSource:FEED_SOURCE_TWITTER];
		Feed* prestoFeed = [[Feed alloc] initWithName:@"GO - Presto Card Updates" Url:@"PRESTOcard" andSource:FEED_SOURCE_TWITTER];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:mtoFeed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:mtoAlertsFeed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:mtoQEWTBFeed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:mtoQEWBTFeed];
        //TODO : Re-add when updating constantly
        //[[Constants sharedConstants].trafficFeedType.Feeds addObject:mto400Feed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:mto401Feed];
        //TODO : Re-add when updating constantly
        //[[Constants sharedConstants].trafficFeedType.Feeds addObject:mto403Feed];
        //TODO : Re-add when updating constantly
        //[[Constants sharedConstants].trafficFeedType.Feeds addObject:mto404Feed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:mto410Feed];
        //TODO : Re-add when updating constantly
        //[[Constants sharedConstants].trafficFeedType.Feeds addObject:mto427Feed];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:ttcFeed];
        [[Constants sharedConstants].trafficFeedType.Feeds addObject:ttcNoticesFeed];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:unofficialGoFeed];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:goFeed];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:prestoFeed];
		[[Constants sharedConstants].trafficFeedType.Feeds addObject:gtaaFeed];
		[mtoFeed release];
		[ttcFeed release];
		[goFeed release];
		[gtaaFeed release];
		//App Feeds
		Feed* offblastFeed = [[Feed alloc] initWithName:@"Offblast Softworks" Url:@"OffblastSW" andSource:FEED_SOURCE_TWITTER];
		Feed* appstoreFeed = [[Feed alloc] initWithName:@"Official App Store News" Url:@"AppStore" andSource:FEED_SOURCE_TWITTER];
        Feed* freeGuruFeed = [[Feed alloc] initWithName:@"Free App Alerts" Url:@"FreeGuru" andSource:FEED_SOURCE_TWITTER];
		[[Constants sharedConstants].appFeedType.Feeds addObject:offblastFeed];
		[[Constants sharedConstants].appFeedType.Feeds addObject:appstoreFeed];
        [[Constants sharedConstants].appFeedType.Feeds addObject:freeGuruFeed];
		[offblastFeed release];
        [appstoreFeed release];
        [freeGuruFeed release];
	}
    //Used to load which feeds are enabled from the NSUserDefaults class
    [self loadStaticSettings];
    [self loadDynamicSettings];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}
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
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.feedTable = nil;
}
- (void)dealloc 
{
    [feedLists release];
    [feedTable release];
    [super dealloc];
}
/* IBActions */
-(IBAction)close:(id)sender
{
    if(self->dirty)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FEED_SETTINGS_CHANGED object: nil];
    }
    [self dismissModalViewControllerAnimated:YES];
}
/* Custom Methods */
-(int)getActiveFeedTypeNumber
{
    if(self->dirty)
    {
        [activeFeedTypes removeAllObjects];
        //If any feed in a feed type array is enabled
        // then the feed type is active
        for(NSString* feedTypeKey in feedLists)
        {
            FeedType* feedType = [feedLists objectForKey:feedTypeKey];
            for(Feed* feed in feedType.Feeds)
            {
                if(feed.Enabled)
                {
                    [activeFeedTypes addObject:feedType];
                    break;
                }
            }
        }
        self->dirty = NO;
    }
    return [activeFeedTypes count];
}
-(int)getFilteredActiveFeedTypeNumber
{
    if(self->dirty)
    {
        [activeFeedTypes removeAllObjects];
        //If any feed in a feed type array is enabled & conforms to the filter
        // then the feed type is active
        for(NSString* feedTypeKey in feedLists)
        {
            FeedType* feedType = [feedLists objectForKey:feedTypeKey];
            if(self->filter == FEED_FILTER_ALL || self->filter == feedType.associatedFilter)
            {
                for(Feed* feed in feedType.Feeds)
                {
                    if(feed.Enabled)
                    {
                        [activeFeedTypes addObject:feedType];
                        break;
                    }
                }
            }
        }
        self->dirty = NO;
    }
    return [activeFeedTypes count];
}
-(FeedType*)getFeedTypeAtRelativeIndex:(int)index
{
    int counter = 0;
    for(FeedType* feedType in activeFeedTypes)
    {
        if(counter == index)
        {
            return feedType;
        }
        counter++;
    }
    
    return nil;
}
-(void)setFilter : (FEED_FILTER) f
{
    self->filter = f;
    self->dirty = YES;
}
-(void)loadStaticSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Handle Twitter Feeds
    
    for(FeedType* feedType in [feedLists allValues])
    {
        for(Feed* feed in feedType.Feeds)
        {
            if([prefs objectForKey:feed.Url])
            {
                BOOL feedEnabledPref = [prefs boolForKey:feed.Url];
                feed.Enabled = feedEnabledPref;
            }
        }
    }
}
-(void)loadDynamicSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Handle Pinned Cameras
    //Check for Pinned Cameras
    NSDictionary* pinnedCameras = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_cameras"];
    FeedType* pinnedCamerasFeedType = [feedLists objectForKey:@"Traffic Cameras"];
    pinnedCamerasFeedType.associatedFilter = FEED_FILTER_PINNED;
    
    //If not in dictionary, add type
    if(!pinnedCamerasFeedType)
    {
        pinnedCamerasFeedType = [[[FeedType alloc] initWithName:@"Traffic Cameras"] autorelease];
        [feedLists setObject:pinnedCamerasFeedType forKey:@"Traffic Cameras"];
    }
    else
    {
        [pinnedCamerasFeedType.Feeds removeAllObjects];
    }
    //Iterate over pinned cameras
    for(NSString* cameraName in [pinnedCameras allKeys])
    {
        
        CameraFeedInterpreter* interpreter = [[[CameraFeedInterpreter alloc] init] autorelease];
        Feed* feed = [[Feed alloc] initWithName:cameraName Url:[pinnedCameras objectForKey:cameraName] Interpreter:interpreter andSource:OBJECT_CAMERA];
        
        if([prefs objectForKey:feed.Url])
        {
            BOOL feedEnabledPref = [prefs boolForKey:feed.Url];
            feed.Enabled = feedEnabledPref;
        }
        
        [pinnedCamerasFeedType.Feeds addObject:feed];
    }
    
    //Handle Pinned GO Stations
    //Check for Pinned Stations
    NSDictionary* pinnedStations = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_go_stations"];
    FeedType* pinnedStationsFeedType = [feedLists objectForKey:@"GO Train Stations"];
    pinnedStationsFeedType.associatedFilter = FEED_FILTER_PINNED;
    
    //If not in dictionary, add type
    if(!pinnedStationsFeedType)
    {
        pinnedStationsFeedType = [[[FeedType alloc] initWithName:@"GO Train Stations"] autorelease];
        [feedLists setObject:pinnedStationsFeedType forKey:@"GO Train Stations"];
    }
    else
    {
        [pinnedStationsFeedType.Feeds removeAllObjects];
    }
    //Iterate over pinned cameras
    for(NSString* stationName in [pinnedStations allKeys])
    {
        GoStationFeedInterpreter* interpreter = [[[GoStationFeedInterpreter alloc] init] autorelease];
        Feed* feed = [[Feed alloc] initWithName:stationName Url:[pinnedStations objectForKey:stationName] Interpreter:interpreter andSource:OBJECT_GO_STATION];
        
        if([prefs objectForKey:feed.Url])
        {
            BOOL feedEnabledPref = [prefs boolForKey:feed.Url];
            feed.Enabled = feedEnabledPref;
        }
        
        [pinnedStationsFeedType.Feeds addObject:feed];
    }
    
    //Flag that the list is dirty
    self->dirty = YES;
    //Refresh table
    [self.feedTable reloadData];
}
/* UITableView Delegate & Datasource methods */
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    FeedType* feedType = [[feedLists allValues] objectAtIndex:section];
    return [feedType.Feeds count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    FeedType* feedType = [[feedLists allValues] objectAtIndex:indexPath.section];
    Feed* feed = [feedType.Feeds  objectAtIndex:indexPath.row];
    
	UITableViewCell *newCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
 
	[newCell.textLabel setText:[feed Name]];
    [newCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [newCell.textLabel setTextColor:[UIColor whiteColor]];
	[newCell.textLabel setFont:[Constants sharedConstants].cellTextFontSmall];
    
    //Picks the preview image of the feed
    if(feed.Source == FEED_SOURCE_TWITTER)
    {
        newCell.image = [Constants sharedConstants].twitterBirdImage;
        [newCell.detailTextLabel setText:[NSString stringWithFormat:@"Twitter account \"%@\"",[feed Url]]];
    }
    else if(feed.Source == OBJECT_CAMERA)
    {
        [newCell.detailTextLabel setText:@"MTO/City of Toronto traffic camera"];
    }
        
    if(feed.Enabled)
    {
		//Custom accessory isn't working on pre 4.0 devices
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (version >= 4.0)
		{
			// iPhone 4.0 code here
			UIImageView* checkmarkImageView = [[UIImageView alloc] initWithImage:[[Constants sharedConstants] checkmarkImage]]; 
			newCell.accessoryView = checkmarkImageView;
			[checkmarkImageView release];
		}
		else 
		{
			// code to compile for pre-4.0
			newCell.accessoryType = UITableViewCellAccessoryCheckmark;	
		}
    }
    else
    {
        newCell.accessoryType = UITableViewCellAccessoryNone;	
    }

	return newCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FeedType* feedType = [[feedLists allValues] objectAtIndex:indexPath.section];
    Feed* feed = [feedType.Feeds objectAtIndex:indexPath.row];

	//Custom accessory isn't working on pre 4.0 devices
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0)
	{
		if (!cell.accessoryView) 
		{
			//Check Row
			feed.Enabled = YES;
			UIImageView* checkmarkImageView = [[UIImageView alloc] initWithImage:[[Constants sharedConstants] checkmarkImage]]; 
			cell.accessoryView = checkmarkImageView;   
			[checkmarkImageView release];
		}
		else 
			//Uncheck Row
		{
			feed.Enabled = NO;
			cell.accessoryType = UITableViewCellAccessoryNone;
			[cell.accessoryView removeFromSuperview];
			cell.accessoryView = nil;
		}
	}
	else 
	{
		// code to compile for pre-4.0
		if (cell.accessoryType == UITableViewCellAccessoryNone) 
		{
			//Check Row
			feed.Enabled = YES;
			cell.accessoryType = UITableViewCellAccessoryCheckmark;  
		}
		else 
			//Uncheck Row
		{
			feed.Enabled = NO;
			cell.accessoryType = UITableViewCellAccessoryNone;  
		}
	}
	
    //Save setting in NSUserDefaults
    [prefs setBool:feed.Enabled forKey:feed.Url];
    [prefs synchronize];
    //Signals a change has been made
    self->dirty = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return  [feedLists count];
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)] autorelease];
    [headerView setBackgroundColor:[Constants sharedConstants].headerBackgroundColour];
    
	UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, tableView.bounds.size.width, 15)];  
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[Constants sharedConstants].headerTextFont];
    
    //If lite version, compare feedtype to the two disabled feed types, if found, gray
    #ifdef LITE_VERSION
    FeedType* feedType = [[feedLists allValues] objectAtIndex:section];
    if([feedType.Name isEqualToString:@"Traffic Cameras"] || [feedType.Name isEqualToString:@"GO Train Stations"] || [feedType.Name isEqualToString:@"Weather"] || [feedType.Name isEqualToString:@"News"])
    {
        [headerLabel setTextColor:[UIColor darkGrayColor]];
    }
    else
    {
        [headerLabel setTextColor:[UIColor whiteColor]];
    }
    [headerLabel setText:feedType.Name];
    #else
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setText:[[feedLists allKeys] objectAtIndex:section]];
    #endif
    [headerView addSubview:headerLabel];
	[headerLabel release];
    return headerView;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    return [[feedLists allKeys] objectAtIndex:section];
}
@end
