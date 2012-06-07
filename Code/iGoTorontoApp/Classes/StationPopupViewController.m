//
//  StationPopupViewController.m
//
//  Created by Ryan Renna on 10-10-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationPopupViewController.h"
#import "CDLine.h"
#import "GradientView.h"
#import "iGoGradientButton.h"
#import "CircleView.h"

@implementation StationPopupViewController
@synthesize actionPanel;
@synthesize lblAddress;
@synthesize lblStationDescription;
@synthesize btnBoard;
@synthesize pinButton;
@synthesize activityIndicator;
@synthesize lineTable;
@synthesize childViewController;
@synthesize station;
@synthesize stationLines;

-(id)initWithStationName:(NSString*)name
{
	NSMutableString *stationPopupViewControllerNibName = [NSMutableString stringWithString:@"StationPopupView"];
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
		[stationPopupViewControllerNibName appendString:@"-iPad"];
	}
	
	if ((self = [super initWithNibName:stationPopupViewControllerNibName bundle:nil])) 
	{
        iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = delegate.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDStation" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"Name = %@",name]];
        [fetchRequest setEntity:entity];
		
        NSArray * fetchedRelationshipArray = [[NSArray alloc] initWithObjects:@"Lines",@"Lines.Directions",@"Factoids",nil];
		[fetchRequest setRelationshipKeyPathsForPrefetching:fetchedRelationshipArray];
		[fetchedRelationshipArray release];
		
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if([fetchedObjects count] > 0)
        {
            
            self.station = [fetchedObjects objectAtIndex:0];
            self.stationLines = [self.station.Lines allObjects];
        }
		
		[fetchRequest release];
    }
	return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Logic for how pin button is displayed
    [self checkForPinnedStatus];
	
    //Set tableview background to be clear
    lineTable.backgroundColor = [UIColor clearColor];
    lineTable.separatorColor = [UIColor blackColor];
	//iOS 3.2 and above have a background view, checks for background view to maintain backwards compatibility
	if ([lineTable respondsToSelector:@selector(backgroundView)])
	{
		lineTable.backgroundView = nil;
	}
	
	//Display station address
    lblAddress.text = station.Address;
	//Display station factoid
    NSSet* factoids = [station Factoids];
    int numFactoids = [factoids count];
    if(numFactoids > 0)
    {
        int randomFactoidIndex = rand()  % numFactoids;
        CDFactoid* factoid = [[factoids allObjects] objectAtIndex:randomFactoidIndex];
        [lblStationDescription setText:factoid.Body];
    }
    
    //If lite version, disable pinning
    #ifdef LITE_VERSION
    self.pinButton.enabled = NO;
    #else
    #endif
    
    if([station.Name isEqualToString:@"Union Station"])
	{
        //Pre-cache live union board if NON-Lite version
        #ifdef LITE_VERSION
        #else
        [childViewController release];
		childViewController = nil;
        self.btnBoard.hidden = NO;
        
        //Attempt to precache union station live board if reachability is set to reachable
        Reachability * reachability = [Reachability reachabilityForInternetConnection];
        if([reachability isReachable])
        {
            NSMutableString *unionBoardControllerNibName = [NSMutableString stringWithString:@"UnionStationView"];
            if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
            {
                [unionBoardControllerNibName appendString:@"-iPad"];
            }		
            
            self.childViewController = [[[UnionBoardViewController alloc] initWithNibName:unionBoardControllerNibName bundle:nil] autorelease];
            [self.activityIndicator startAnimating];
            NSMethodSignature * enabledUnionBoardButtonMethodSignature = [StationPopupViewController instanceMethodSignatureForSelector:@selector(enableBoardButton)];
            NSInvocation* enableBoardButtonInvocation = [NSInvocation invocationWithMethodSignature:enabledUnionBoardButtonMethodSignature];
            [enableBoardButtonInvocation setTarget:self];
            [enableBoardButtonInvocation setSelector:@selector(enableBoardButton)];    
            [childViewController performSelector:@selector(precacheDataAndReplyWithInvocation:) withObject:enableBoardButtonInvocation];
        }
        #endif
		
	}
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.actionPanel = nil;
    self.lblAddress = nil;
    self.lblStationDescription = nil;
    self.btnBoard = nil;
    self.pinButton = nil;
    self.activityIndicator = nil;
    self.lineTable = nil;
}
-(void)dealloc
{
	[actionPanel release];
	[lblAddress release];
	[btnBoard release];
    [pinButton release];
    [btnUpcoming release];
    [lblStationDescription release];
   	[activityIndicator release];
    [lineTable release];
	[childViewController release];
    [station release];
    [stationLines release];
	[super dealloc];
}
/* IBActions */
- (IBAction)viewUpcoming:(id)sender 
{
	if(station)
	{
		NSMutableString *stationStopListingControllerNibName = [NSMutableString stringWithString:@"StationStopListingView"];
		if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
		{
			[stationStopListingControllerNibName appendString:@"-iPad"];
		}
		
		StationStopListingController* stationStopListingController = [[StationStopListingController alloc]  initWithCustomDaytimeFilter:[NSDate date] NibName:stationStopListingControllerNibName bundle:nil];
		stationStopListingController.station = station;
		childViewController = stationStopListingController;
		
		CGRect popupContentFrame = self.view.superview.frame;
		CGRect contentFrame; contentFrame.origin.x = 0; contentFrame.origin.y = 0;
		contentFrame.size = popupContentFrame.size;
		
		self.view.superview.autoresizesSubviews = YES;
		childViewController.view.frame = contentFrame;
		[self.view.superview addSubview: childViewController.view];
        [self.view removeFromSuperview];
	}
}
- (IBAction)viewSchedule:(id)sender 
{
	
}
- (IBAction)viewBoard:(id)sender 
{
	IGoPopupViewController* popupScreenController = (IGoPopupViewController*)childViewController;
	[popupScreenController slideIn];
}
- (IBAction)viewMap:(id)sender
{
	NSString* latLong = [NSString stringWithFormat:@"%f,%f",[station.Latitude doubleValue],[self.station.Longitude doubleValue]];
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",latLong];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:apiUrlStr]];
}
- (IBAction)pinToHome:(id)sender
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    //If station name is in user defaults, it's already pinned and must be unpinned
    if([prefs objectForKey:station.Name])
    {
        //Removed key
        [prefs removeObjectForKey:station.Name];
        //Now remove camera from dictionary
        
        NSDictionary* pinnedStations = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_go_stations"];
        NSMutableDictionary* newPinnedStations = [[NSMutableDictionary alloc] initWithDictionary:pinnedStations];
        [newPinnedStations removeObjectForKey:station.Name];
        [[NSUserDefaults standardUserDefaults] setObject:newPinnedStations forKey:@"pinned_go_stations"];
    }
    //If camera url is not in user defaults, it must be pinned 
    else
    {
        
        NSDictionary* pinnedStations = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"pinned_go_stations"];
        if(!pinnedStations)
        {
            pinnedStations = [[[NSDictionary alloc] init] autorelease];
        }
        
        NSMutableDictionary* newPinnedStations = [[NSMutableDictionary alloc] initWithDictionary:pinnedStations];
        [newPinnedStations setObject:station.Name forKey:station.Name];
        [[NSUserDefaults standardUserDefaults] setObject:newPinnedStations forKey:@"pinned_go_stations"];
        //Also, enable this feed by default
        [prefs setBool:YES forKey:station.Name];
    }
    [prefs synchronize];
    
    //Post pin notification
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OBJECT_PIN_CHANGED object:nil];
    
    //Refresh the Pinned status
    [self checkForPinnedStatus];
}
/* Custom Methods */
-(void)enableBoardButton
{
	[self.activityIndicator stopAnimating];
	self.btnBoard.enabled = YES;
	self.btnBoard.hidden = NO;
}
-(void)layoutControls
{
	CGRect actionPanelFrame = self.actionPanel.frame;
	int y = self.view.frame.size.height - actionPanelFrame.size.height;
	
	actionPanelFrame.origin.y = y;
	
    self.actionPanel.frame = actionPanelFrame;

}
-(void)checkForPinnedStatus
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    //If camera url is in user defaults, it's already pinned and must be unpinned
    if([prefs objectForKey:station.Name])
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
/* UITableView Delegate & DataSource methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{    
    return [self.stationLines count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{    
    return 1;
    //return [self.stationLines count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString* CellIdentifier = [[NSString alloc] initWithFormat:@"%i~%i",indexPath.section,indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
    if (cell == nil) 
    {
        CDLine* line = [self.stationLines objectAtIndex:indexPath.section];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.opaque = NO;
        
        CGRect lineCircleRect = CGRectMake(6, 6, 15, 15);
        CGRect lineLabelRect = CGRectMake(25, 0, cell.frame.size.width, 50);
        CGRect rowViewRect = CGRectMake(0, 0, cell.frame.size.width, 50);

        UIView* containerView = [[[UIView alloc] initWithFrame:rowViewRect] autorelease];
                containerView.clipsToBounds = YES;
        UIView* backgroundView = [[[UIView alloc] initWithFrame:rowViewRect] autorelease];
        
        UIView* backgroundUniformView = [[[UIView alloc] initWithFrame:rowViewRect] autorelease];
        backgroundUniformView.backgroundColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:0.4f];
       
        GradientView* selectedBackgroundGradientView = [[[GradientView alloc] initWithFrame:rowViewRect andBeginningColour:[UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:0.75f] andEndingColour:[UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:0.55f]] autorelease];

        iGoTorontoAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        if([Constants sharedConstants].deviceProfile == IPAD_PROFILE)
        {
            if(delegate.QualityMode != QUALITY_LOW)
            {
                containerView.layer.cornerRadius = 9.0;
                backgroundView.layer.cornerRadius = 9.0;
            }
            
            containerView.layer.borderWidth = 2.0;
            backgroundView.layer.borderWidth = 2.0;
        }
        else
        {
            if(delegate.QualityMode != QUALITY_LOW)
            {
                containerView.layer.cornerRadius = 5.0;
                backgroundView.layer.cornerRadius = 5.0;
            }
            
            containerView.layer.borderWidth = 1.0;
            backgroundView.layer.borderWidth = 1.0;
        }
        
        containerView.layer.borderColor = [UIColor blackColor].CGColor;
        backgroundView.layer.borderColor = [UIColor blackColor].CGColor;
        backgroundView.clipsToBounds = YES;                
        
        [containerView addSubview:backgroundUniformView];
        [backgroundView addSubview:selectedBackgroundGradientView];
        
        cell.backgroundView = containerView;
        cell.selectedBackgroundView = backgroundView;
        
        
        CircleView* circleView = [[[CircleView alloc] initWithFrame:lineCircleRect] autorelease];
        circleView.color = [line PrimaryColour];
        
        UILabel* lineLabel = [[[UILabel alloc] initWithFrame:lineLabelRect] autorelease];
        lineLabel.backgroundColor = [UIColor clearColor];
        lineLabel.font = [Constants sharedConstants].headerTextFont;
        lineLabel.textColor = [UIColor whiteColor];
        lineLabel.textAlignment = UITextAlignmentLeft;
        lineLabel.text = line.Name;

        [cell.contentView addSubview:circleView];
        [cell.contentView addSubview:lineLabel];
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
    if(station)
	{
		NSMutableString *stationStopListingControllerNibName = [NSMutableString stringWithString:@"StationStopListingView"];
		if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
		{
			[stationStopListingControllerNibName appendString:@"-iPad"];
		}		
        
        CDLine* line = [self.stationLines objectAtIndex:indexPath.section];
		StationStopListingController* stationStopListingController = [[StationStopListingController alloc] initWithNibName:stationStopListingControllerNibName bundle:nil];
		stationStopListingController.station = station;
		stationStopListingController.line = line;
        childViewController = stationStopListingController;
		
		CGRect popupContentFrame = self.view.superview.frame;
		CGRect contentFrame; contentFrame.origin.x = 0; contentFrame.origin.y = 0;
		contentFrame.size = popupContentFrame.size;
		
		self.view.superview.autoresizesSubviews = YES;
		childViewController.view.frame = contentFrame;
		
		[self.view.superview addSubview: childViewController.view];
        [self.view removeFromSuperview];
	}
}
@end
