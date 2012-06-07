    //
//  SubwayViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-22.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "SubwayViewController.h"

@implementation SubwayViewController
@synthesize locationManager;
@synthesize subwayMapScrollView;
@synthesize subwayListView;
@synthesize subwayLabelView;
@synthesize compassImageView;
@synthesize subwayMapViewController;
@synthesize labelButton;
@synthesize viewSelectorLeft;
@synthesize viewSelectorRight;
@synthesize labelsView;
@synthesize enabledLabelsArray;
@synthesize stations;
@synthesize stationsSortedByDistance;
@synthesize loadingDirectionListCell;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		//Listen for notifications of a go station view request
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewStationNotificationRecieved:) name:NOTIFICATION_SUBWAY_STATION_VIEW object:nil];
	}
	return self;
}
- (void)viewDidLoad 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Don't show the help tag if this is the lite version
    // and hide distance tab
    #ifdef LITE_VERSION
    CGRect leftSelectorFrame = viewSelectorLeft.frame;
    leftSelectorFrame.origin.x += 77;
    viewSelectorLeft.frame = leftSelectorFrame;
    
    viewSelectorRight.hidden = YES;
    #else
	//Show help screen on first load
    BOOL showHelpScreen = YES;
    if([prefs objectForKey:@"ShowHelpScreen-Subway"])
    {
        showHelpScreen = [prefs boolForKey:@"ShowHelpScreen-Subway"];
    }
    if(showHelpScreen)
    {
        [self displayHelp:@"To list all subway stations by distance select the Distance button."];
        [prefs setBool:NO forKey:@"ShowHelpScreen-Subway"];
        [prefs synchronize];
    }
    #endif
    
	enabledLabelsArray = [[NSMutableArray alloc] initWithCapacity:4];
	//Loads last enabled labels from NSDefaults
	for(int i =0; i < 4; i++)
	{
		NSString* NSDefaultsKeyForLine = [[NSString alloc] initWithFormat:@"SubwayLineLabelEnabled-%i",i];
		BOOL lineEnabled = [prefs boolForKey:NSDefaultsKeyForLine];
		[NSDefaultsKeyForLine release];
		[enabledLabelsArray addObject:[NSNumber numberWithBool:lineEnabled]];
	}

	[self performSelectorInBackground:@selector(loadSubwayMapController) withObject:nil];
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.subwayMapScrollView = nil;
    self.subwayListView = nil;
    self.subwayLabelView = nil;
    self.labelsView = nil;
    self.compassImageView = nil;
    self.labelButton = nil;
    self.viewSelectorLeft = nil;
    self.viewSelectorRight = nil;
    self.loadingDirectionListCell = nil;
}
- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[locationManager release];
	[subwayMapScrollView release];
	[labelButton release];
	[viewSelectorLeft release];
	[viewSelectorRight release];
	[subwayListView release];
	[subwayLabelView release];
	[compassImageView release];
	[subwayMapViewController release];
	[labelsView release];
	[enabledLabelsArray release];
	[stations release];
	[stationsSortedByDistance release];
	[loadingDirectionListCell release];
    [super dealloc];
}
/* IBActions */
-(IBAction)showLabels:(id)sender
{
	labelsView.hidden = NO;
	
	[UIView beginAnimations:nil context:nil];
	[self.labelsView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	
	[UIView setAnimationDuration:0.75f];
	[self.labelsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];
}
-(IBAction)hideLabels:(id)sender
{
	labelsView.hidden = YES;
	labelsView.hidden = NO;
	
	[UIView beginAnimations:nil context:nil];
	[self.labelsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	[UIView setAnimationDuration:0.75f];
	[self.labelsView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];
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
	//Initialize the core location controller
	if(!self.locationManager)
	{
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	}
	[self.locationManager startUpdatingLocation];
	
	//Generate distances in the background
	[self performSelectorInBackground:@selector(populateStationDistances) withObject:nil];
	
	
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
    //Useless code - remove if orientation on SubwayViewController isn't causing problems
    // the next time you see this
    /*
    int offset = 25;
     
    int subwayMapWidth = 1062;
    
    CGRect frame = subwayMapScrollView.frame;
    CGSize contentSize;
    contentSize.width = subwayMapWidth;
    contentSize.height = subwayMapScrollView.frame.size.height;
    //subwayMapScrollView.contentSize = contentSize; 
    
    CGRect mapFrame = self.subwayMapViewController.view.frame;
    mapFrame.size.height = 375;
    mapFrame.size.width = subwayMapWidth;
    //self.subwayMapViewController.view.frame = mapFrame;
    
    CGPoint mapCenter = CGPointMake(subwayMapScrollView.contentSize.width / 2,CGRectGetMidY(subwayMapScrollView.frame) - offset);
    self.subwayMapViewController.view.center = mapCenter;
    */
}
/* Custom Methods */
//Used to enable the View type segmented control asyncronously
-(void)enabledSelectorControls
{
    viewSelectorLeft.enabled = YES;
    viewSelectorRight.enabled = YES;
}
-(void)viewStationNotificationRecieved:(NSNotification*)notification
{
	NSString* stationName = [notification object];
	[self spawnStationPopup:stationName];
}
-(void)spawnStationPopup:(NSString*)stationName
{
	SubwayStationPopupViewController* stationPopupView = [[SubwayStationPopupViewController alloc] initWithStationName:stationName];
	self.infoPopupViewController = [[InfoPopupViewController alloc] initWithViewController:stationPopupView andTitle:stationName];
    [stationPopupView release];
	[self.infoPopupViewController slideIn];
}
- (void)showLoadingCellInTableHeader
{
	subwayListView.tableHeaderView = loadingDirectionListCell;
}
-(void)hideLoadingCellInTableHeader
{
	subwayListView.tableHeaderView = nil;
}
-(void)loadSubwayMapController
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	//Load the Subway Station map
	self.subwayMapViewController = [[[SubwayMapViewController alloc] initWithNibName:@"SubwayMapView" bundle:nil] autorelease];
	contentType = mapContentType;
	[self performSelectorOnMainThread:@selector(viewChanged) withObject:nil waitUntilDone:NO];
	[pool drain];
}
-(void)populateStationDistances 
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	CLLocation* currentLocation = [self.locationManager location];
	NSMutableArray * sortedStations = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	//Place a 'loading' cell in the table header
	[self performSelectorOnMainThread:@selector(showLoadingCellInTableHeader) withObject:nil waitUntilDone:YES];
	[self.subwayListView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	
	int count = 0;
	while(//If the current location was returned as nil, or both h and v accuracy is less than 100, wait
		  !currentLocation || 
		  ([currentLocation verticalAccuracy] < 100 && [currentLocation horizontalAccuracy] < 100)
		  )
	{
		//Prevent an endless loop
		if(count > 10) 
		{ 
			break; 
		}
		
		[NSThread sleepForTimeInterval:1];
		count++;
		
		//If the gps has not returned a location or it's location is not accurate, fetch another location
		currentLocation = [self.locationManager location];
	}
	//Check if a location was definately returned
	if(currentLocation)
	{
		[self sortStationsByDistanceFromLocation:currentLocation intoArray:sortedStations];
		self.stationsSortedByDistance = sortedStations;
	}
	[self performSelectorOnMainThread:@selector(hideLoadingCellInTableHeader) withObject:nil waitUntilDone:YES];
	[self.subwayListView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	[self.locationManager performSelectorOnMainThread:@selector(stopUpdatingLocation) withObject:nil waitUntilDone:NO];
	[pool drain];
}
-(void)sortStationsByDistanceFromLocation:(CLLocation*)location intoArray:(NSMutableArray*)sortedStations
{
	for(CDSubwayStation* station in self.stations)
	{
		for(int i = 0; i < [sortedStations count] + 1; i++)
		{
			CDSubwayStation* compareStation = nil;
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
					station.Distance = [NSNumber numberWithDouble:[location distanceFromLocation:stationLocation]];
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
-(void)viewChanged
{
[[subwayMapScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

if(contentType == mapContentType)
{
	//Show compass
	compassImageView.hidden = NO;
	
	//Enable Label button
	labelButton.enabled = YES;
	
	//map view
	int offset = 35;
	[subwayMapScrollView addSubview:subwayMapViewController.view];
	subwayMapScrollView.contentSize = subwayMapViewController.view.frame.size; 
	//Place map in the center of the scroll view
	CGPoint mapCenter = CGPointMake(CGRectGetMidX(subwayMapViewController.view.frame),CGRectGetMidY(subwayMapViewController.view.frame));
	self.subwayMapViewController.view.center = mapCenter;
	
	[self performSelector:@selector(scrollToMiddle) withObject:nil afterDelay:0.5];
	[self performSelector:@selector(enabledSelectorControls) withObject:nil afterDelay:1.25];
	//Fade map elements in
	CABasicAnimation *alphaAnimation = nil;
	alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[alphaAnimation setToValue:[NSNumber numberWithDouble:1.0]];
	[alphaAnimation setFromValue:[NSNumber numberWithDouble:0.0]];
	[alphaAnimation setDuration:0.2f];
	[self.subwayMapViewController.view.layer addAnimation: alphaAnimation forKey: @"opacityAnimationInt"];
		
	for(int i =0; i < 4; i++)
	{
		BOOL lineEnabled = [[enabledLabelsArray objectAtIndex:i] boolValue];
		//Fade in any enabled labels
		if(lineEnabled)
		{
			[self enableSubwayLineByIndex:i];
		}
	}
	
	//Set state of buttons
	[viewSelectorLeft setSelected:YES];
	[viewSelectorRight setSelected:NO];

    }
	//List or Distance view
	else 
	{
		subwayListView.frame = CGRectMake(0, 0, self.subwayMapScrollView.frame.size.width,self.subwayMapScrollView.frame.size.height);
		subwayMapScrollView.contentSize = self.subwayMapScrollView.frame.size; 
		
		
		//Hides compass
		compassImageView.hidden = YES;
		
		labelButton.enabled = NO;
		//Set the map button as unselected
		[viewSelectorLeft setSelected:NO];
		
		//Load a list of subway stations
		if(!self.stations)
		{
			iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext* context = delegate.managedObjectContext;
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDSubwayStation" inManagedObjectContext:context];
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			
			//Asks core data to prefetch the Stations relationship
			//NSArray * fetchedRelationshipArray = [[NSArray alloc] initWithObjects:@"Stations",nil];
			//[fetchRequest setRelationshipKeyPathsForPrefetching:fetchedRelationshipArray];
			
			[fetchRequest setEntity:entity];
			NSError *error = nil;
			self.stations = [context executeFetchRequest:fetchRequest error:&error];
			[fetchRequest release];
			//[fetchedRelationshipArray release];
		}

		[subwayMapScrollView addSubview:subwayListView];
		[self.subwayListView reloadData];
		//Sets the distance button to the selected state
		[viewSelectorRight setSelected:YES];
	}
}
-(void)scrollToMiddle
{
    //Offset to modify where the middle of the map is, in relation to the middle of the mapView
    int middleOffset = -50;
    CGRect startPos = CGRectMake(0 + middleOffset, 100, 320, 480);
    CGRect pos = CGRectMake((int)(subwayMapScrollView.contentSize.width/2) + middleOffset, 100, 320, 480);
    [subwayMapScrollView scrollRectToVisible:startPos animated:0];
    [subwayMapScrollView scrollRectToVisible:pos animated:YES];
}
-(void)enableSubwayLineByIndex:(int)index
{
	[UIView beginAnimations:@"rotateToViewableAngle" context:nil];
	[UIView setAnimationDuration:1.0];
	switch (index) 
	{
		case 0:
			subwayMapViewController.BloorDanforthLineView.alpha = 1.0;
			subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 1.0;
			subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 1.0;
			break;
		case 1:
			subwayMapViewController.SheppardLineView.alpha = 1.0;
			subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 1.0;
			break;
		case 2:
			subwayMapViewController.ScarboroughRTLineView.alpha = 1.0;
			subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 1.0;
			break;
		case 3:
			subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 1.0;
			subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 1.0;
			subwayMapViewController.YoungeUniversitySpadinaLineView.alpha = 1.0;
			break;
		default:
			break;
	}
	[UIView commitAnimations];
}
-(void)checkCell:(UITableViewCell*)cell andIndexPath:(NSIndexPath*)indexPath
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self enableSubwayLineByIndex:indexPath.row];
	
	//Save setting in NSUserDefaults
	NSString* NSDefaultsKeyForLine = [[NSString alloc] initWithFormat:@"SubwayLineLabelEnabled-%i",indexPath.row];
	[prefs setBool:YES forKey:NSDefaultsKeyForLine];
	[NSDefaultsKeyForLine release];
	
	[enabledLabelsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    [prefs synchronize];
}
-(void)uncheckCell:(UITableViewCell*)cell andIndexPath:(NSIndexPath*)indexPath
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[UIView beginAnimations:@"rotateToViewableAngle" context:nil];
	[UIView setAnimationDuration:1.0];
	switch (indexPath.row) {
		case 0:
			subwayMapViewController.BloorDanforthLineView.alpha = 0.0;
			if(![[enabledLabelsArray objectAtIndex:2] boolValue])
			{
				subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 0.0;
			}
			if(![[enabledLabelsArray objectAtIndex:3] boolValue])
			{
				subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 0.0;
			}
			break;
		case 1:
			subwayMapViewController.SheppardLineView.alpha = 0.0;
			if(![[enabledLabelsArray objectAtIndex:3] boolValue])
			{
				subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 0.0;
			}
			break;
		case 2:
			subwayMapViewController.ScarboroughRTLineView.alpha = 0.0;
			if(![[enabledLabelsArray objectAtIndex:0] boolValue])
			{
				subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 0.0;
			}
			break;
		case 3:
			if(![[enabledLabelsArray objectAtIndex:0] boolValue])
			{
				subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 0.0;
			}
			if(![[enabledLabelsArray objectAtIndex:1] boolValue])
			{
				subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 0.0;
			}
			subwayMapViewController.YoungeUniversitySpadinaLineView.alpha = 0.0;
			break;
		default:
			break;
	}
	[UIView commitAnimations];
	
	//Save setting in NSUserDefaults
	NSString* NSDefaultsKeyForLine = [[NSString alloc] initWithFormat:@"SubwayLineLabelEnabled-%i",indexPath.row];
	[prefs setBool:NO forKey:NSDefaultsKeyForLine];
	[NSDefaultsKeyForLine release];
	
	[enabledLabelsArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
	
    [prefs synchronize];
}
/* UITableView Delegate & Datasource methods */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return [[UIView new] autorelease];
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	//If label table
	if(table == subwayLabelView)
	{
		return 4;
	}
	//Distance view
	else
	{
		return [stationsSortedByDistance count];
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	UITableViewCell *cell;
	//If label table
	if(tableView == subwayLabelView)
	{
		NSNumber* labelGroupEnabled = [enabledLabelsArray objectAtIndex:indexPath.row];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
	
		switch (indexPath.row) 
		{
		case 0:
			[cell.textLabel setText:@"Bloor-Danforth"];
            UIColor* bloorDanforthLineColour = [UIColor colorWithRed:0.426 green:0.585 blue:0.414 alpha:1.0];
            [cell.textLabel setTextColor:bloorDanforthLineColour];
			break;
		case 1:
			[cell.textLabel setText:@"Sheppard"];
            UIColor* sheppardLineColour = [UIColor colorWithRed:0.488 green:0.335 blue:0.503 alpha:1.0];
            [cell.textLabel setTextColor:sheppardLineColour];

			break;
		case 2:
			[cell.textLabel setText:@"Scarborough RT"];
            UIColor* scarboroughRTLineColour = [UIColor colorWithRed:0.451 green:0.666 blue:0.76 alpha:1.0];
            [cell.textLabel setTextColor:scarboroughRTLineColour];
			break;
		case 3:
			[cell.textLabel setText:@"Yonge-University-Spadina"];
            [cell.textLabel setTextColor:[UIColor orangeColor]];
			break;
		default:
			break;
		}
	
	
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		[cell.textLabel setFont:[Constants sharedConstants].headerTextFont];
			
		if([labelGroupEnabled boolValue])
		{
			float version = [[[UIDevice currentDevice] systemVersion] floatValue];
			if (version >= 4.0)
			{
				// iPhone	 4.0 code here
				UIImageView* checkmarkImageView = [[UIImageView alloc] initWithImage:[[Constants sharedConstants] checkmarkImage]]; 
				cell.accessoryView = checkmarkImageView;
				[checkmarkImageView release];
			}
			else 
			{
				// code to compile for pre-4.0
				cell.accessoryType = UITableViewCellAccessoryCheckmark;	
			}
			//Make line visible without animation if enabled on first load (loaded from NSDefaults)
			switch (indexPath.row) 
			{
				case 0:
					subwayMapViewController.BloorDanforthLineView.alpha = 1.0;
					subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 1.0;
					subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 1.0;
					break;
				case 1:
					subwayMapViewController.SheppardLineView.alpha = 1.0;
					subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 1.0;
					break;
				case 2:
					subwayMapViewController.ScarboroughRTLineView.alpha = 1.0;
					subwayMapViewController.ScarboroughRTandBloorLineView.alpha = 1.0;
					break;
				case 3:
					subwayMapViewController.YoungeUniversitySpadinaandBloorDanforthLineView.alpha = 1.0;
					subwayMapViewController.YoungeUniversitySpadinaandSheppardLineView.alpha = 1.0;
					subwayMapViewController.YoungeUniversitySpadinaLineView.alpha = 1.0;
					break;
				default:
					break;
			}
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryNone;	
		}
			
		}
		//Distance view
		else
		{
			NSString * cellIdentifier = [NSString stringWithFormat:@"d%i",indexPath.row];
			cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if(!cell)
			{
				CDSubwayStation* station = [stationsSortedByDistance objectAtIndex:indexPath.row];
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
				cell.textLabel.text = station.Name;
				cell.textLabel.textColor = [UIColor whiteColor];
				cell.textLabel.font = [Constants sharedConstants].cellTextFont;

				int km = (int)([station.Distance doubleValue]/1000.0);
				cell.detailTextLabel.text = [NSString stringWithFormat:@"Approximately %i km",km ];
				//Custom Accessory 
				UIImage* forwardButtonUnclickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton" ofType:@"png"]];
				UIImage* forwardButtonClickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton_Clicked" ofType:@"png"]];
				UIImageView* customAccessoryView = [[UIImageView alloc] initWithImage:forwardButtonUnclickedImage highlightedImage:forwardButtonClickedImage];
				cell.accessoryView = customAccessoryView;
				[customAccessoryView release];
			}
		}
		return cell;
	}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//If label table
	if(tableView == subwayLabelView)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		
		//Custom accessory isn't working on pre 4.0 devices
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (version >= 4.0)
		{
			if (!cell.accessoryView) 
			{
				//Check Row
				[self checkCell:cell andIndexPath:indexPath];
				UIImageView* checkmarkImageView = [[UIImageView alloc] initWithImage:[[Constants sharedConstants] checkmarkImage]]; 
				cell.accessoryView = checkmarkImageView;    
				[checkmarkImageView release];
			}
			else 
			{
				//Uncheck Row
			[self uncheckCell:cell andIndexPath:indexPath];
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
				[self checkCell:cell andIndexPath:indexPath];
				cell.accessoryType = UITableViewCellAccessoryCheckmark;  
			}
			else 
			{
				//Uncheck Row
				[self uncheckCell:cell andIndexPath:indexPath];
				cell.accessoryType = UITableViewCellAccessoryNone; 
			}
		}
	}
	//Distance table
	else 
	{
		CDSubwayStation* station = [stationsSortedByDistance objectAtIndex:indexPath.row];
		[self spawnStationPopup:station.Name];
	}

}
@end
