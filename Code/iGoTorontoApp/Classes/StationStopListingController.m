//
//  StationStopListingController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-16.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "GOCenter.h"
#import "StationStopListingController.h"
#import "AdViewController.h"
#import "AdMobView.h"


@implementation StationStopListingController
@synthesize adViewController;
@synthesize adSpaceView;
@synthesize segmentedControlDirections;
@synthesize segmentedControlDayType;
@synthesize stopListingTable;
@synthesize customDayTypeFilterLabel;
@synthesize customDayTypeFilterDate;
@synthesize station;
@synthesize line;
@synthesize cellBackgroundColour;
@synthesize cellForegroundColour;
@synthesize directions;
@synthesize dayTypes;
@synthesize activeDirection;
@synthesize activeDayTypeName;
@synthesize todaysValidDayTypes;

#pragma mark -
#pragma mark View lifecycle
-(id) init
{
    self = [super init];
    if(self)
    {
        self.customDayTypeFilterDate = Nil;
    }
    return self;
}
-(id)initWithCustomDaytimeFilter:(NSDate*)date NibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    if((self = [super initWithNibName:nibName bundle:bundle]))
    {
        self.customDayTypeFilterDate = [[GOCenter sharedCenter] goComparableDateFromDate:date];
    }
    return self;
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    //If Lite version setup an Ad
    #ifdef LITE_VERSION
    self.adViewController = [[[AdViewController alloc] init] autorelease];
    self.adViewController.currentViewController = self;
    AdMobView* mobView = [AdMobView requestAdWithDelegate:self.adViewController];
    mobView.frame = CGRectMake(0, 0, 320, 48);
    [self.adSpaceView addSubview:mobView];
    self.adSpaceView.userInteractionEnabled = YES;
    //Reduce the table size
    CGRect stopTableViewFrame = self.stopListingTable.frame;
    stopTableViewFrame.size.height -= 48;
    self.stopListingTable.frame = stopTableViewFrame;
    #else
    #endif
    
	//Sets the default schedule
	cellBackgroundColour = [[UIColor grayColor] retain];
    cellForegroundColour = [[UIColor whiteColor] retain];
     
    if(customDayTypeFilterDate)
    {
		self.todaysValidDayTypes = [[[NSMutableSet alloc] init] autorelease];
        NSString* dayTypeDescription = nil;
        for(CDLine* line in [self.station.Lines allObjects])
        {
            DayTypeDescriptor* descriptor = [[GOCenter sharedCenter] getDayTimeDescriptorsForLine:line];
            
            //Set the day type description to the first descriptor string you get back
            if(!dayTypeDescription)
                dayTypeDescription = descriptor.description;
            //Add the name of the descriptor to the set
            [todaysValidDayTypes addObject:descriptor.name];
        }
    
        //sets the active day type name
        //self.activeDayTypeName = descriptor.name;
        //sets the active day type description
        [self.customDayTypeFilterLabel setText:dayTypeDescription];
		
		[self.customDayTypeFilterLabel setHidden:NO];
		//Hide the daytype segmented control
        [self.segmentedControlDayType setHidden:YES];      
    }
	
	[self retrieveDirections];
    
	//[self retrieveData];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.segmentedControlDirections = nil;
    self.segmentedControlDayType = nil;
    self.stopListingTable = nil;
    self.customDayTypeFilterLabel = nil;
    self.adSpaceView = nil;
}
- (void)dealloc 
{
    [adViewController release];
    [adViewController release];
	[segmentedControlDirections release];
    [segmentedControlDayType release];
    [stopListingTable release];
    [customDayTypeFilterLabel release];
    [customDayTypeFilterDate release];
	[station release];
    [line release];
    [cellBackgroundColour release];
    [cellForegroundColour release];
	[stopData release];
	[directions release];
	[dayTypes release];
    [activeDirection release];
    [activeDayTypeName release];
    [todaysValidDayTypes release];
    [super dealloc];
}
/* Custom Methods */
-(void)retrieveDayTypes
{
	self.dayTypes = [[NSMutableArray new] autorelease];
	[segmentedControlDayType removeAllSegments];
	
    if(self.line)
    {
        for(CDDirection* direction in [self.line Directions])
		{
			if(direction == activeDirection)
			{
				for(CDDayType* dayType in [self.line DayTypes])
				{
					BOOL found = NO;
					for(int i = 0; i < [dayTypes count];i++)
					{
						if([dayTypes objectAtIndex:i] == dayType)
						{
							found = YES;
							break;
						}
					}
					if(!found)
					{
						[self.dayTypes addObject:dayType];
					}
				}
				break;
			}
		}
    }
    else
    {
        for(CDLine* stationLine in station.Lines)
        {
            for(CDDirection* direction in [stationLine Directions])
            {
                if(direction == activeDirection)
                {
                    for(CDDayType* dayType in [stationLine DayTypes])
                    {
                        BOOL found = NO;
                        for(int i = 0; i < [dayTypes count];i++)
                        {
                            if([self.dayTypes objectAtIndex:i] == dayType)
                            {
                                found = YES;
                                break;
                            }
                        }
                        if(!found)
                        {
                            [self.dayTypes addObject:dayType];
                        }
                    }
                    break;
                }
            }
        }
    }
	
	NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
	self.dayTypes = [self.dayTypes sortedArrayUsingDescriptors:sortDescriptors];
	
	[sortNameDescriptor release];
	[sortDescriptors release];
	
	for(CDDayType* dayType in dayTypes)
	{
		if([dayTypes count] > 4)
		{
			[segmentedControlDayType insertSegmentWithTitle:dayType.ShortenedName atIndex:[segmentedControlDayType numberOfSegments] animated:NO];
		}
		else 
		{
			[segmentedControlDayType insertSegmentWithTitle:dayType.Name atIndex:[segmentedControlDayType numberOfSegments] animated:NO];
		}

	}
	//Auto selects the first segment - unless there is a custom date filter assigned
	if(!customDayTypeFilterDate && [segmentedControlDayType numberOfSegments] > 0)
	{
		[segmentedControlDayType setSelectedSegmentIndex:0];
        [self dayTypeChanged];
	}
}
-(void)retrieveDirections
{
	self.directions = [NSMutableArray new];
	[segmentedControlDirections removeAllSegments];
	
    if(self.line)
    {
        for(CDDirection* direction in [line Directions])
		{
			//Hacks to not show empty routes
			if([station.Name isEqualToString:@"Union Station"])
			{
				if([direction.Name isEqualToString:@"South"])
				{
					//Filter out Southbound stops @ Union Station
					continue;
				}
			}
			BOOL found = NO;
			for(int i = 0; i < [segmentedControlDirections numberOfSegments];i++)
			{
				if([[segmentedControlDirections titleForSegmentAtIndex:i] isEqualToString:direction.Name])
				{
					found = YES;
					break;
				}
			}
			if(!found)
			{
				[directions addObject:direction];
				[segmentedControlDirections insertSegmentWithTitle:direction.Name atIndex:0 animated:NO];
			}
		}
    }
    else
    {
        for(CDLine* stationLine in station.Lines)
        {
            for(CDDirection* direction in [stationLine Directions])
            {
                //Hacks to not show empty routes
                if([station.Name isEqualToString:@"Union Station"])
                {
                    if([direction.Name isEqualToString:@"South"])
                    {
                        //Filter out Southbound stops @ Union Station
                        continue;
                    }
                }
                BOOL found = NO;
                for(int i = 0; i < [segmentedControlDirections numberOfSegments];i++)
                {
                    if([[segmentedControlDirections titleForSegmentAtIndex:i] isEqualToString:direction.Name])
                    {
                        found = YES;
                        break;
                    }
                }
                if(!found)
                {
                    [directions addObject:direction];
                    [segmentedControlDirections insertSegmentWithTitle:direction.Name atIndex:0 animated:NO];
                }
            }
        }
    }
	
	//Auto selects the first segment
	if([segmentedControlDirections numberOfSegments] > 0)
	{
		[segmentedControlDirections setSelectedSegmentIndex:0];
        [self directionChanged];
	}
}
-(void)retrieveData
{
	//Ensure's there is a valid direction to view
	if([segmentedControlDirections numberOfSegments] > 0)
	{
		iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext* context = delegate.managedObjectContext;
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDStop" inManagedObjectContext:context];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        //If a time filter has been set, filter stops by this time
        if(self.customDayTypeFilterDate)
        {
            if(self.line)
            {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(Station == %@) and (Route.Line == %@) and (DayType == %@) and (finalStop == NO) and (Route.Direction.Name == %@) and (Time > %@)",station,self.line,activeDayTypeName,activeDirection.Name,customDayTypeFilterDate]];
            }
            else
            {        
                //Checks day type is in set of daytypes valid for today
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(Station == %@) and (DayType in %@) and (finalStop == NO) and (Time > %@) and (Route.Direction.Name == %@)",station,todaysValidDayTypes,customDayTypeFilterDate,activeDirection.Name]];
            }
            
            [fetchRequest setFetchLimit:7];
		}
        else
        {
            if(self.line)
            {
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(Station == %@) and (Route.Line == %@) and (DayType == %@) and (finalStop == NO) and (Route.Direction == %@)",station,line,activeDayTypeName,activeDirection]];
            }
            else
            {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(Station == %@) and (DayType == %@) and (finalStop == NO) and (Route.Direction == %@)",station,activeDayTypeName,activeDirection]];

            }
		}

		[fetchRequest setEntity:entity];		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Time" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors: sortDescriptors];
		NSError *error = nil;
		
		id data = [context executeFetchRequest:fetchRequest error:&error];

        [stopData release];
		stopData = [data retain];
		
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
}
/* IBActions */
-(IBAction)directionChanged
{
    int index = [segmentedControlDirections numberOfSegments] - [segmentedControlDirections selectedSegmentIndex] - 1;
    activeDirection = [directions objectAtIndex:index];
	
    [self retrieveDayTypes];
	//Only need to trigger a data retrival in "upcoming" tab
	if(self.customDayTypeFilterDate)
	{
        [self retrieveData];
	}
    
    [self retrieveData];
    [stopListingTable reloadData];
}
-(IBAction)dayTypeChanged
{
    int index = [segmentedControlDayType selectedSegmentIndex];
    CDDayType* dayType = [dayTypes objectAtIndex:index];
    activeDayTypeName = dayType.Name;
    [self retrieveData];
    [stopListingTable reloadData];
}
/* TableView Delegate & Datasource */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [stopData count];
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}
// Customize the appearance of table view cells.
- (StopCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    NSString* CellIdentifier = [NSString stringWithFormat:@"%@~%@~%i~%i",activeDayTypeName,activeDirection.Name,indexPath.section,indexPath.row];
    StopCellView *cell = (StopCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        CDStop* stop = [stopData objectAtIndex:indexPath.row];
		cell = [[[StopCellView alloc] initWithBackgroundColour:cellBackgroundColour	foregroundColor:cellForegroundColour font:[Constants sharedConstants].cellTextFont reuseIdentifier:CellIdentifier andStop:stop] autorelease];
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}
@end

