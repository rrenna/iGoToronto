    //
//  HighwayViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "HighwayViewController.h"
#import "GradientView.h"

@implementation HighwayViewController
@synthesize cameraListView;
@synthesize roadways;
@synthesize camerasSortedByDistance;
@synthesize viewSelectorLeft;
@synthesize viewSelectorRight;
@synthesize loadingDirectionListCell;

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
        //Listen for notifications of a camera view request
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewCameraNotificationRecieved:) name:NOTIFICATION_CAMERA_VIEW object:nil];
	}
	return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//Show help screen on first load
    BOOL showHelpScreen = YES;
    if([prefs objectForKey:@"ShowHelpScreen-Highway"])
    {
        showHelpScreen = [prefs boolForKey:@"ShowHelpScreen-Highway"];
    }
    if(showHelpScreen)
    {
        [self displayHelp:@"To list all cameras by distance, select the Distance button."];
        [prefs setBool:NO forKey:@"ShowHelpScreen-Highway"];
        [prefs synchronize];
    }
	
	//Sets the initial screen
	contentType = listContentType;
	[self viewChanged];
	[self enabledSelectorControls];
    [super viewDidLoad];
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
	[roadways release];
	[camerasSortedByDistance release];
	[cameraListView release];
	[viewSelectorLeft release];
	[viewSelectorRight release];
	[loadingDirectionListCell release];
    [super dealloc];
}
/* IBActions */
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
	//Generate distances in the background
	[[LocationCenter sharedCenter] updateLocation];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateCameraDistancesWithNotification:) name:NOTIFICATION_LOCATION_CHANGED object:nil];
	
	//Place a 'loading' cell in the table header
	[self showLoadingCellInTableHeader];
	[self.cameraListView reloadData];
	
	//Change views - if the view isn't the same
	if(contentType != distanceContentType)
	{
		contentType = distanceContentType;
		[self viewChanged];
	}
}
/* Custom Methods */
-(void)spawnCameraPopup:(id)cameraOrName
{
	//Check if there's an active internet connection
	Reachability * reachability = [Reachability reachabilityForInternetConnection];
	if(![reachability isReachable])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[Constants sharedConstants] ErrorMessage_NoInternetConnection] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];
		[alert release];
	}
	//If user has an active internet connection, display fare calculator screen
	else 
	{
        CameraViewController* cameraViewController = nil;
        NSString* title = nil;
        if([cameraOrName isKindOfClass:[NSString class]])
        {
            cameraViewController = [[CameraViewController alloc] initWithCameraName:cameraOrName];
            title = cameraOrName;
        }
        else
        {
            cameraViewController = [[CameraViewController alloc] initWithCamera:cameraOrName];
            title = [((CDCamera*) cameraOrName) Name];
        }
        
		self.infoPopupViewController = [[InfoPopupViewController alloc] initWithViewController:cameraViewController andTitle:title];
		[cameraViewController release];
		[self.infoPopupViewController slideIn];
	}
}
//Used to enable the View type segmented control asyncronously
-(void)enabledSelectorControls
{
    viewSelectorLeft.enabled = YES;
    viewSelectorRight.enabled = YES;
}
//Indicates the user is switching between one of the three views
-(void)viewChanged
{		
	//Load a list of stations
	if(!self.roadways)
	{
		iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext* context = delegate.managedObjectContext;
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRoadway" inManagedObjectContext:context];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		//Asks core data to prefetch the Stations relationship
		NSArray * fetchedRelationshipArray = [[NSArray alloc] initWithObjects:@"Cameras",nil];
		[fetchRequest setRelationshipKeyPathsForPrefetching:fetchedRelationshipArray];
		
		[fetchRequest setEntity:entity];
		NSError *error = nil;
		NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
		self.roadways = fetchedObjects;
		
		[fetchRequest release];
		[fetchedRelationshipArray release];
	}
	
	[self.cameraListView reloadData];
	
	//List view
	if(contentType == listContentType)
	{
		//Set state of buttons
		[viewSelectorLeft setSelected:YES];
		[viewSelectorRight setSelected:NO];
	}
	//Distance view
	else 
	{
		//Set state of buttons
		[viewSelectorLeft setSelected:NO];
		[viewSelectorRight setSelected:YES];
	}
}
- (void)showLoadingCellInTableHeader
{
	cameraListView.tableHeaderView = loadingDirectionListCell;
}
-(void)hideLoadingCellInTableHeader
{
	cameraListView.tableHeaderView = nil;
}
-(void)viewCameraNotificationRecieved:(NSNotification*)notification
{
    [self spawnCameraPopup:notification.object];
}
-(void)populateCameraDistancesWithNotification:(NSNotification*)notification 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSMutableArray * sortedCameras = [[[NSMutableArray alloc] initWithCapacity:150] autorelease];
	CLLocation* currentLocation = [[LocationCenter sharedCenter] currentLocation];
	
	//Check if a location was definately returned
	if(currentLocation)
	{
		[self sortCamerasByDistanceFromLocation:currentLocation intoArray:sortedCameras];
		self.camerasSortedByDistance = sortedCameras;
	}
	[self hideLoadingCellInTableHeader];
	[self.cameraListView reloadData];

}
-(void)sortCamerasByDistanceFromLocation:(CLLocation*)location intoArray:(NSMutableArray*)sortedCameras
{
	for(CDRoadway* roadway in self.roadways)
	{
	
		for(CDCamera* camera in roadway.Cameras)
		{
			for(int i = 0; i < [sortedCameras count] + 1; i++)
			{
				CDCamera* compareCamera = nil;
				if([sortedCameras count] > i)
				{
					compareCamera = [sortedCameras objectAtIndex:i];
				}
			
				//if no station exists at this position
				if(!compareCamera)
				{
					[sortedCameras insertObject:camera atIndex:i];
					break;
				}
				//This condition can happen if a station is in 2 lines (Union)
				else if(camera == compareCamera)
				{
					break;
				}
				// compare distances, if station is closer ,insert at position
				else 
				{
					//If station distance hasn't been calculated
					if([camera.Distance doubleValue] == 0)
					{
						CLLocation * stationLocation = [[CLLocation alloc] initWithLatitude:[camera.Latitude doubleValue] longitude:[camera.Longitude doubleValue]];
						camera.Distance = [NSNumber numberWithDouble:[location distanceFromLocation:stationLocation]];
						[stationLocation release];
					}
					//If compared station distance hasn't been calculated
					if([compareCamera.Distance doubleValue] == 0)
					{
						CLLocation * stationLocation = [[CLLocation alloc] initWithLatitude:[compareCamera.Latitude doubleValue] longitude:[compareCamera.Longitude doubleValue]];
						compareCamera.Distance = [NSNumber numberWithDouble:[location distanceFromLocation:stationLocation]];
						[stationLocation release];
					}
					if([camera.Distance doubleValue] < [compareCamera.Distance doubleValue])
					{
						[sortedCameras insertObject:camera atIndex:i];
						break;
					}
				}
			}
		}
	}
}
/* UITableView Delegate & DataSource methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if(contentType == listContentType)
	{
		// Return the number of Roadways stored in the databa	se
			return [roadways count];
		}
		else 
		{
			return 1;
		}
	}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{    
		if(contentType == listContentType)
		{
			// Return the number of rows in the section.
			CDRoadway* roadway = [self.roadways objectAtIndex:section];
			//NSArray* filteredStations = [line valueForKey:@"filteredStations"];
			NSArray* cameras = roadway.Cameras;
			return [cameras count];
		}
		else 
		{
			return [camerasSortedByDistance count];
		}
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(contentType == distanceContentType)
    {
            return 10;
    }
    else
    {
        return 27;
    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(contentType == listContentType)
    {
        CDRoadway* roadway = [self.roadways objectAtIndex:section];		
        
        GradientView* gradientView = [[[GradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 27) andBeginningColour:[UIColor colorWithRed:0.306 green:0.494 blue:0.722 alpha:1.0] andEndingColour:[UIColor colorWithRed:0.051 green:0.298 blue:0.702 alpha:1.0]] autorelease];
        gradientView.layer.borderWidth = 1.0;
        
        UILabel* headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(4, 0, tableView.bounds.size.width, 27)] autorelease];  
        
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setFont:[Constants sharedConstants].cellTextFont];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setText:[roadway Name]];
        
        [gradientView addSubview:headerLabel];
        return gradientView;
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
			CDRoadway* roadway = [self.roadways objectAtIndex:indexPath.section];
			NSArray* cameras = roadway.Cameras;
			CDCamera* camera = [[cameras allObjects] objectAtIndex:indexPath.row];
			
			cell.textLabel.text = camera.Name;
			
			// Configure the cell... 
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.textLabel.numberOfLines = 2;	
			cell.textLabel.textColor = [UIColor whiteColor];
			cell.textLabel.font = [Constants sharedConstants].cellTextFontSmall;
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
			CDCamera* camera = [self.camerasSortedByDistance objectAtIndex:indexPath.row];
			cell.textLabel.text = camera.Name;
			
			int km = (int)([camera.Distance doubleValue]/1000.0);
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Approximately %i km",km ];
			// Configure the cell...        
			cell.textLabel.textColor = [UIColor whiteColor];
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	CDCamera* camera;
	if(contentType == listContentType)
	{
		CDRoadway* roadway = [self.roadways objectAtIndex:indexPath.section];
		NSArray* cameras = roadway.Cameras;
		camera = [[cameras allObjects] objectAtIndex:indexPath.row];
		[self spawnCameraPopup:camera];
	}
	else 
	{
		camera = [self.camerasSortedByDistance objectAtIndex:indexPath.row];
		[self spawnCameraPopup:camera];
	}
}
@end
