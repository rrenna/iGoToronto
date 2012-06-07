//
//  GoViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-24.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "GoViewController.h"
#import "AdViewController.h"
#import "GradientView.h"
#import "CircleView.h"
#import "AdMobView.h"

@implementation GoViewController
@synthesize lines;
@synthesize stationsSortedByDistance;
@synthesize mapViewController;
@synthesize activityIndicatorView;
@synthesize contentScrollView;
@synthesize viewSelectorLeft;
@synthesize viewSelectorCenter;
@synthesize viewSelectorRight;
@synthesize loadingDirectionListCell;
@synthesize goListView;
@synthesize compassImageView;
@synthesize unionBoardViewController;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		//Listen for notifications of a go station view request
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewStationNotificationRecieved:) name:NOTIFICATION_GO_STATION_VIEW object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBoardNotificationRecieved:) name:NOTIFICATION_GO_UNION_BOARD_VIEW object:nil];
	}
	return self;
}
- (void)viewDidLoad 
{    
    //If lite version, disable Distance tab & setup ad
    #ifdef LITE_VERSION
    CGRect leftSelectorFrame = viewSelectorLeft.frame;
    CGRect centerSelectorFrame = viewSelectorCenter.frame;
    
    leftSelectorFrame.origin.x += 75;
    centerSelectorFrame.origin.x += 75;
    
    viewSelectorLeft.frame = leftSelectorFrame;
    viewSelectorCenter.frame = centerSelectorFrame;
    viewSelectorRight.hidden = YES;

    self.adViewController = [[[AdViewController alloc] init] autorelease];
    self.adViewController.currentViewController = self;
    #else
    #endif
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//Show help screen on first load
    BOOL showHelpScreen = YES;
    if([prefs objectForKey:@"ShowHelpScreen-GoTrain"])
    {
        showHelpScreen = [prefs boolForKey:@"ShowHelpScreen-GoTrain"];
    }
    if(showHelpScreen)
    {
        //If Lite version, show a modified help message.
        #ifdef LITE_VERSION
        [self displayHelp:@"To sort GO Trains stations, select Map or List view."];
        #else
        [self displayHelp:@"To sort GO Trains stations, select Map, List, or Distance views accordingly."];
        #endif
        [prefs setBool:NO forKey:@"ShowHelpScreen-GoTrain"];
        [prefs synchronize];
    }

	[self performSelectorInBackground:@selector(loadGoMapController) withObject:nil];
	[super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    //Once user interaction is enabled (the opening animation has been played), flash the scroll indicator every time the view becomes visible
    if([self.view isUserInteractionEnabled])
    {
        [contentScrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.5];
    }
    [self layoutControls];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.activityIndicatorView = nil;
    self.contentScrollView = nil;
    self.goListView = nil;
    self.loadingDirectionListCell = nil;
    self.viewSelectorLeft = nil;
    self.viewSelectorCenter = nil;
    self.viewSelectorRight = nil;
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [lines release];
	[stationsSortedByDistance release];
	[mapViewController release];
	[activityIndicatorView release];
    [goListView release];
	[contentScrollView release];
	[viewSelectorLeft release];
	[viewSelectorCenter release];
	[viewSelectorRight release];
	[loadingDirectionListCell release];
	[unionBoardViewController release];
	[compassImageView release];
    [super dealloc];
}
/* IBActions */
-(IBAction)viewUnionBoard:(id)sender
{	
	//Not yet implemented
}
-(IBAction)mapViewSelected:(id)sender
{
	//Change views - if the view isn't the same
	if(contentType != mapContentType)
	{
		contentType	= mapContentType;
		[self viewChanged];
	}
}
-(IBAction)listViewSelected:(id)sender
{
	//Change views - if the view isn't the same
	if(contentType != listContentType)
	{
		//Removes the distance header, if this button is pressed
		// while distances are loading
		[self hideLoadingCellInTableHeader];
		contentType = listContentType;
		[self viewChanged];
	}
}
-(IBAction)distanceViewSelected:(id)sender
{
	[[LocationCenter sharedCenter] updateLocation];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateStationDistancesWithNotification:) name:NOTIFICATION_LOCATION_CHANGED object:nil];
	//Place a 'loading' cell in the table header
	[self showLoadingCellInTableHeader];
	[self.goListView reloadData];
	
	//Change views - if the view isn't the same
	if(contentType != distanceContentType)
	{
		contentType = distanceContentType;
		[self viewChanged];
	}
}
/* Template Methods */
-(void)layoutControls
{
    //If in map view, resize scrollview
    if(contentType == mapContentType)
    {
        int offset = 25;
        int goMapWidth = 965;
        
        CGRect frame = contentScrollView.frame;
        CGSize contentSize;
        contentSize.width = goMapWidth;
        contentSize.height = contentScrollView.frame.size.height;
        contentScrollView.contentSize = contentSize; 
        
        CGRect mapFrame = self.mapViewController.view.frame;
        mapFrame.size.height = 365;
        mapFrame.size.width = goMapWidth;
        self.mapViewController.view.frame = mapFrame;
        
        
        CGPoint mapCenter = CGPointMake(contentScrollView.contentSize.width / 2,CGRectGetMidY(contentScrollView.frame) - offset);
        self.mapViewController.view.center = mapCenter;
    }
}
/* Custom Methods */
-(void)loadGoMapController
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	//Load the Go Station map
	self.mapViewController = [[[GoTrainMapViewController alloc] initWithNibName:@"GoTrainMapView" bundle:nil] autorelease];
	contentType = mapContentType;
	[self performSelectorOnMainThread:@selector(viewChanged) withObject:nil waitUntilDone:NO];
	[pool drain];
}
-(void)viewBoardNotificationRecieved:(NSNotification*)notification
{
	[self viewUnionBoard:nil];
}
-(void)viewStationNotificationRecieved:(NSNotification*)notification
{
	NSString* stationName = [notification object];
	[self spawnStationPopup:stationName];
}
-(void)spawnStationPopup:(NSString*)stationName
{
	StationPopupViewController* stationPopupView = [[StationPopupViewController alloc] initWithStationName:stationName];
	self.infoPopupViewController = [[InfoPopupViewController alloc] initWithViewController:stationPopupView andTitle:stationName];
    [stationPopupView release];
	[self.infoPopupViewController slideIn];
}
-(void)populateStationDistancesWithNotification:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOCATION_CHANGED object:nil];
	CLLocation* currentLocation = [[LocationCenter sharedCenter] currentLocation];
	NSMutableArray * sortedStations = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	
	//Check if a location was definately returned
	if(currentLocation)
	{
		[self sortStationsByDistanceFromLocation:currentLocation intoArray:sortedStations];
		self.stationsSortedByDistance = sortedStations;
	}
	[self hideLoadingCellInTableHeader];
	[self.goListView reloadData];
}
- (void)showLoadingCellInTableHeader
{
	goListView.tableHeaderView = loadingDirectionListCell;
}
-(void)hideLoadingCellInTableHeader
{
	goListView.tableHeaderView = nil;
}
-(void)sortStationsByDistanceFromLocation:(CLLocation*)location intoArray:(NSMutableArray*)sortedStations
{
	for(CDLine* line in lines)
	{
		for(CDStation* station in [line Stations])
		{
			//Skip non-train stations
			if([station.isDescriptor boolValue])
			{
				continue;
			}
			for(int i = 0; i < [sortedStations count] + 1; i++)
			{
				CDStation* compareStation = nil;
				if([sortedStations count] > i)
				{
					compareStation = [sortedStations objectAtIndex:i];
				}
				
				//if no station exists at this position
				if(!compareStation)
				{
					[sortedStations insertObject:station atIndex:i];
					break;
				}
				//This condition can happen if a station is in 2 lines (Union)
				else if(station == compareStation)
				{
					break;
				}
				// compare distances, if station is closer ,insert at position
				else 
				{
					//If station distance hasn't been calculated
					if([station.Distance doubleValue] == 0)
					{
						CLLocation * stationLocation = [[CLLocation alloc] initWithLatitude:[station.Latitude doubleValue] longitude:[station.Longitude doubleValue]];
						
						if([location respondsToSelector:@selector(distanceFromLocation:)])
						{
							station.Distance = [NSNumber numberWithDouble:[location distanceFromLocation:stationLocation]];
						}
						
						
						[stationLocation release];
					}
					//If compared station distance hasn't been calculated
					if([compareStation.Distance doubleValue] == 0)
					{
						CLLocation * stationLocation = [[CLLocation alloc] initWithLatitude:[compareStation.Latitude doubleValue] longitude:[compareStation.Longitude doubleValue]];
						compareStation.Distance = [NSNumber numberWithDouble:[location distanceFromLocation:stationLocation]];
						[stationLocation release];
					}
					
					if([station.Distance doubleValue] < [compareStation.Distance doubleValue])
					{
						[sortedStations insertObject:station atIndex:i];
						break;
					}
				}
			}
		}
	}
	
}

//Indicates the user is switching between one of the three views
-(void)viewChanged
{
    [[contentScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(contentType == mapContentType)
    {
        //Remove any ads placed in the Ad Space
        #ifdef LITE_VERSION
        [self.adSpaceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.adSpaceView.userInteractionEnabled = NO;
        #else
        #endif
        
		//show compass image
		compassImageView.hidden = NO;
		
        //map view
        contentScrollView.contentSize = mapViewController.view.frame.size; 
		int offset = 25;

        [self.mapViewController performSelector:@selector(cascadeEnableLines) withObject:nil afterDelay:0.25];
		[self performSelector:@selector(scrollToMiddle) withObject:nil afterDelay:0.75];
		[self performSelector:@selector(enabledSelectorControls) withObject:nil afterDelay:1.25];
		//Add Map as scrollview subview
		[contentScrollView addSubview:self.mapViewController.view];
		
		CGPoint mapCenter = CGPointMake(contentScrollView.contentSize.width / 2,contentScrollView.center.y - offset);
		self.mapViewController.view.center = mapCenter;
		
		//Fade map elements in
		CABasicAnimation *alphaAnimation = nil;
		alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[alphaAnimation setToValue:[NSNumber numberWithDouble:1.0]];
		[alphaAnimation setFromValue:[NSNumber numberWithDouble:0.0]];
		[alphaAnimation setDuration:0.2f];
		[self.mapViewController.view.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
		
		//Set state of buttons
		[viewSelectorLeft setSelected:YES];
		[viewSelectorRight setSelected:NO];
		[viewSelectorCenter setSelected:NO];
    }
	//List or Distance view
	else 
	{
        //If lite version, reserve space for, and place a adMob ad at the bottom of the screen
        #ifdef LITE_VERSION
        goListView.frame = CGRectMake(0, 0, contentScrollView.frame.size.width,contentScrollView.frame.size.height - 49);
        AdMobView* mobView = [AdMobView requestAdWithDelegate:self.adViewController];
        mobView.frame = CGRectMake(0, 0, 320, 48);
        [self.adSpaceView addSubview:mobView];
        self.adSpaceView.userInteractionEnabled = YES;
        #else
        goListView.frame = CGRectMake(0, 0, contentScrollView.frame.size.width,contentScrollView.frame.size.height);
        #endif
        
		contentScrollView.contentSize = self.contentScrollView.frame.size; 
		
		//Hide compass image
		compassImageView.hidden = YES;
		
		//Set the map button as unselected
		[viewSelectorLeft setSelected:NO];
		
		//Load a list of stations
		if(!self.lines)
		{
			iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext* context = delegate.managedObjectContext;
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDLine" inManagedObjectContext:context];
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			
			//Asks core data to prefetch the Stations relationship
			NSArray * fetchedRelationshipArray = [[NSArray alloc] initWithObjects:@"Stations",nil];
			[fetchRequest setRelationshipKeyPathsForPrefetching:fetchedRelationshipArray];
			
			[fetchRequest setEntity:entity];
			NSError *error = nil;
			NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
			self.lines = fetchedObjects;
			
			[fetchRequest release];
			[fetchedRelationshipArray release];
		}
		
		[contentScrollView addSubview:goListView]; 
		[self.goListView reloadData];
		
		//List view
		if(contentType == listContentType)
		{
			//Set state of buttons
			[viewSelectorCenter setSelected:YES];
			[viewSelectorRight setSelected:NO];
		}
		//Distance view
		else 
		{
			//Set state of buttons
			[viewSelectorCenter setSelected:NO];
			[viewSelectorRight setSelected:YES];
		}
	}
}
-(void)scrollToMiddle
{
    //Offset to modify where the middle of the map is, in relation to the middle of the mapView
    int middleOffset = -180;
    CGRect pos = CGRectMake((int)(contentScrollView.contentSize.width/2) + middleOffset, 0, 320, 480);
    [contentScrollView scrollRectToVisible:pos animated:YES];
}

//Used to enable the View type segmented control asyncronously
-(void)enabledSelectorControls
{
    viewSelectorLeft.enabled = YES;
	viewSelectorCenter.enabled = YES;
    viewSelectorRight.enabled = YES;
}
-(void)enabledUserInteraction
{
    [self.view setUserInteractionEnabled:YES];
}
/* UITableView Delegate & DataSource methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if(contentType == listContentType)
	{
		// Return the number of Lines stored in the database
		return [lines count] + 1;
	}
	else 
	{
		
		return 1;
	}

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if(contentType == listContentType)
	{
		// Return the number of rows in the section.
		if(section == 0)
		{
			return 1;
		}
		CDLine* line = [lines objectAtIndex:section - 1];
		NSArray* filteredStations = [line valueForKey:@"filteredStations"];
		return [filteredStations count];
	}
	else 
	{
		return [stationsSortedByDistance count];
	}

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(contentType == listContentType)
    {
        if(section == 0)
        {
            return 0;
        }
        //Header size
        return 27;
    }
    else
    {
        //Spacing
        return 10;
    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(contentType == listContentType)
	{
		if(section != 0)
		{
            CDLine* line = [self.lines objectAtIndex:section - 1];
                    
            GradientView* gradientView = [[[GradientView alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width, 27) andBeginningColour:[UIColor colorWithRed:0.306 green:0.494 blue:0.722 alpha:1.0] andEndingColour:[UIColor colorWithRed:0.051 green:0.298 blue:0.702 alpha:1.0]] autorelease];
            gradientView.layer.borderWidth = 1.0;
            
            CircleView* circleView = [[CircleView alloc] initWithFrame:CGRectMake(6, 6, 15, 15)];
            circleView.color = [line PrimaryColour];

            UILabel* headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 0, tableView.bounds.size.width - 25, 27)] autorelease];  
            		
			[headerLabel setBackgroundColor:[UIColor clearColor]];
			[headerLabel setFont:[Constants sharedConstants].cellTextFont];
			[headerLabel setTextColor:[UIColor whiteColor]];
			[headerLabel setText:[line Name]];
			[headerLabel setTextColor:[UIColor whiteColor]];
			
            [gradientView addSubview:circleView];
            [gradientView addSubview:headerLabel];
            return gradientView;
		}
	}
	//Return if error, or if not list content type
	return [[UIView new] autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell;
	NSString *CellIdentifier;
	
	if(contentType == listContentType)
	{	
		CellIdentifier = [[NSString alloc] initWithFormat:@"list-%i~%i",indexPath.section,indexPath.row];
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
			//Union Station
			if(indexPath.section == 0)
			{
				cell.textLabel.text = @"Union Station";
			}
			else 
			{
				CDLine* line = [lines objectAtIndex:indexPath.section - 1];
				NSArray* filteredStations = [line sortedFilteredStations];
				CDStation* station = [filteredStations objectAtIndex:indexPath.row];
				cell.textLabel.text = station.Name;
			}
			
			// Configure the cell...        
			cell.textLabel.textColor = [UIColor whiteColor];
			cell.textLabel.font = [Constants sharedConstants].cellTextFont;
			//Custom Accessory 
			UIImage* forwardButtonUnclickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton" ofType:@"png"]];
			UIImage* forwardButtonClickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton_Clicked" ofType:@"png"]];
			UIImageView* customAccessoryView = [[UIImageView alloc] initWithImage:forwardButtonUnclickedImage highlightedImage:forwardButtonClickedImage];
			cell.accessoryView = customAccessoryView;
			[customAccessoryView release];
		}
	
	}
	else 
	{
		CellIdentifier = [[NSString alloc] initWithFormat:@"distance-%i~%i",indexPath.section,indexPath.row];
		//cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		cell = nil;
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			CDStation* station = [self.stationsSortedByDistance objectAtIndex:indexPath.row];
			cell.textLabel.text = station.Name;
		
			int km = (int)([station.Distance doubleValue]/1000.0);
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Approximately %i km",km ];
			// Configure the cell...        
			cell.textLabel.textColor = [UIColor whiteColor];
			cell.textLabel.font = [Constants sharedConstants].cellTextFont;
			//Custom Accessory 
			UIImage* forwardButtonUnclickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton" ofType:@"png"]];
			UIImage* forwardButtonClickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton_Clicked" ofType:@"png"]];
			UIImageView* customAccessoryView = [[UIImageView alloc] initWithImage:forwardButtonUnclickedImage highlightedImage:forwardButtonClickedImage];
			cell.accessoryView = customAccessoryView;
			[customAccessoryView release];
		}
	}
	
	[CellIdentifier release];
	return cell;
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath :(NSIndexPath *)indexPath 
{
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if(contentType == listContentType)
	{
		//Union Station
		if(indexPath.section == 0)
		{
			[self spawnStationPopup:@"Union Station"];
		}
		//All other stations
		else 
		{
			CDLine* line = [lines objectAtIndex:indexPath.section - 1];
			NSArray* filteredStations = [line sortedFilteredStations];
			CDStation* station = [filteredStations objectAtIndex:indexPath.row];
			[self spawnStationPopup:station.Name];
		}
	}
	else 
	{
		CDStation* station = [stationsSortedByDistance objectAtIndex:indexPath.row];
		[self spawnStationPopup:station.Name];
	}

}
@end


