//
//  PlaneViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-25.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaneViewController.h"

@implementation PlaneViewController

@synthesize flightTable;
@synthesize activityIndicator;
@synthesize flightSearchBar;
@synthesize airports;
@synthesize activeAirport;
@synthesize searchResults;
@synthesize isTypeArrivals;
@synthesize isUsingSearchResults;

static PAGE_LIMIT = 3;

-(void)awakeFromNib
{
    //Initial State setup
    isTypeArrivals = YES;
    isUsingSearchResults = NO;
    //Setup empty search results array
    searchResults = [NSMutableArray new];
    //Setup initial airport
    Airport* pearsonAirport = [Airport new];
    pearsonAirport.Name = @"Pearson Airport";
    pearsonAirport.Code = @"YYZ";
    
    airports = [[NSArray alloc] initWithObjects:pearsonAirport, nil];
    activeAirport = pearsonAirport;
    [pearsonAirport release];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	if(isPrecaching)
	{
		[activityIndicator startAnimating];	
	}
}
// Called when the view has been fully transitioned onto the screen
- (void)viewDidAppear:(BOOL)animated
{
    //Flashes the scrollbar
    [flightTable performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.5];
}
- (void)didReceiveMemoryWarning {
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
	[flightTable release];
	[activityIndicator release];
    [flightSearchBar release];
    [searchResults release];
    [activeAirport release];
    [airports release];
    [super dealloc];
}
// IBActions
-(IBAction)setFlightType:(id)sender
{
    //Clear search results from view
    [searchResults removeAllObjects];
    isUsingSearchResults = NO;
    [flightSearchBar setText:@""];

    int selectedTypeIndex = [sender selectedSegmentIndex];
    //If arrivals
    if(selectedTypeIndex == 0)
    {
        if(!isTypeArrivals)
        {
            isTypeArrivals = YES;
            [flightTable reloadData];
        }
    }
    //If departures
    else
    {
        if(isTypeArrivals)
        {
            isTypeArrivals = NO;
            //If departure flights have been populated
            if(activeAirport.DepartureFlights)
            {
                [flightTable reloadData];
            }
            else
            {
                [self getDepartingFlightsForAirport:activeAirport];
            }
        }
    }
}
-(IBAction)refresh
{
    if(self.isTypeArrivals)
    {
        [self performSelectorInBackground:@selector(getArrivingFlightsForAirport:) withObject:activeAirport];
    }
    else
    {
        [self performSelectorInBackground:@selector(getDepartingFlightsForAirport:) withObject:activeAirport];
    }
    
}
// Custom Methods
-(void)getArrivingFlightsForAirport:(Airport*)airport
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
	isPrecaching = YES;
	[activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    FlightAwareParser* flightAwareParser = [[FlightAwareParser alloc] init];
    airport.ArrivalFlights = [[flightAwareParser getFlightsWithFlightType:@"arrivals" forAirportCode:airport.Code OrderBy:@"actualarrivaltime" SortBy:@"desc" OnPage:1] retain];
    [flightAwareParser release];
    //Set pages loaded index of airport
    airport.arrivalPagesLoaded = 1;
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
	isPrecaching = NO;
    //If flights is an allocated array, the view has been loaded, and the table needs to be refreshed
    if(airport.ArrivalFlights)
    {
        [flightTable reloadData];
    }
    [pool drain];
}
-(void)getDepartingFlightsForAirport:(Airport*)airport
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
	isPrecaching = YES;
	[activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    FlightAwareParser* flightAwareParser = [[FlightAwareParser alloc] init];
    airport.DepartureFlights = [[flightAwareParser getFlightsWithFlightType:@"scheduled" forAirportCode:airport.Code OrderBy:@"filed_departuretime" SortBy:@"ASC" OnPage:1] retain];
    [flightAwareParser release];
    //Set pages loaded index of airport
    airport.departurePagesLoaded = 1;
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
	isPrecaching = NO;
    //If flights is an allocated array, the view has been loaded, and the table needs to be refreshed
    if(airport.DepartureFlights)
    {
        [flightTable reloadData];
    }
    [pool drain];
}
-(void)precacheResponseWithDelay:(NSNumber*)delay
{
    sleep([delay intValue]);
    [self performSelectorInBackground:@selector(getArrivingFlightsForAirport:) withObject:activeAirport];
}
// Search Bar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
       [searchResults removeAllObjects];
       isUsingSearchResults = NO;
       //flightSearchBar setText:@""];
       [flightTable reloadData];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //Clear search results from view
    [searchResults removeAllObjects];
    isUsingSearchResults = NO;
    [flightSearchBar setText:@""];
    [flightTable reloadData];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isUsingSearchResults = YES;
    
    NSArray* flightDataSource;
    if(isTypeArrivals) { flightDataSource = activeAirport.ArrivalFlights;   }
    else               { flightDataSource = activeAirport.DepartureFlights; }
    
    [searchResults removeAllObjects];
    for(Flight* flight in flightDataSource)
    {
        NSRange range  = [flight.FlightName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
        {
            [searchResults addObject:flight];
        }
    }

    [searchBar resignFirstResponder];
    [flightTable reloadData];
}
// Table View Datasource & Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    //If displaying search results
    if(isUsingSearchResults)
    {
        return [searchResults count];
    }
    //If not displaying search results
    // add one for a "load more" cell
    else
    {
        if(isTypeArrivals)
        {
            int offset = 0;
            if(activeAirport.arrivalPagesLoaded < PAGE_LIMIT)
            {
                offset = 1;
            }
            
            if(activeAirport.ArrivalFlights)
            {
                return [activeAirport.ArrivalFlights count] + offset;
            }
            return 0;
        }
        else
        {
            int offset = 0;
            if(activeAirport.departurePagesLoaded < PAGE_LIMIT)
            {
                offset = 1;
            }
            
            if(activeAirport.DepartureFlights)
            {
                return [activeAirport.DepartureFlights count] + offset;
            }
            return 0;
        }
    }
}
// Customize the appearance of table view cells.
- (FlightCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    NSArray* activeFlightArray;
    FlightCellView *cell;
    
    //If displaying search results
    if(isUsingSearchResults)
    {
        activeFlightArray = searchResults;
    }
    //If not displaying search results
    else
    {
        if(isTypeArrivals)
        {
            activeFlightArray = activeAirport.ArrivalFlights;
        }
        else
        {
            activeFlightArray = activeAirport.DepartureFlights;
        }
    }
    
    //If final cell, and this is not table of search results, show a "load more" cell
    if(!isUsingSearchResults && indexPath.row == [activeFlightArray count])
    {
        cell = (FlightCellView*)[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"loadmore"] autorelease];
        [cell.detailTextLabel setText:@"Load More..."];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    }
    else
    {
        Flight* flight = [activeFlightArray objectAtIndex:indexPath.row];
        NSString* CellIdentifier = [NSString stringWithFormat:@"%@~%@",flight.FlightName,[flight.DepartureTime description]];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[FlightCellView alloc] initWithFlight:flight isTypeArrivals:isTypeArrivals reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //If not displaying search results
    if(!isUsingSearchResults)
    {
        NSMutableArray* activeFlightArray;
        int activeFlightArrayCurrentPage;
        if(isTypeArrivals)
        {
            activeFlightArray = activeAirport.ArrivalFlights;
            activeFlightArrayCurrentPage = activeAirport.arrivalPagesLoaded;
        }
        else
        {
            activeFlightArray = activeAirport.DepartureFlights;
            activeFlightArrayCurrentPage = activeAirport.departurePagesLoaded;
        }
        //If final cell,this is a "load more" click
        if(indexPath.row == [activeFlightArray count])
        {
            if(isTypeArrivals)
            {
                activeAirport.arrivalPagesLoaded++;
            }
            else
            {
                activeAirport.departurePagesLoaded++;
            }
            
            //Load next page
            FlightAwareParser* flightAwareParser = [[FlightAwareParser alloc] init];
            NSArray* nextPageArray = [flightAwareParser getFlightsWithFlightType:@"arrivals" forAirportCode:activeAirport.Code OrderBy:@"actualarrivaltime" SortBy:@"desc" OnPage:activeFlightArrayCurrentPage + 1];
            
            [activeFlightArray addObjectsFromArray:nextPageArray];
            [flightAwareParser release];
            [tableView reloadData];
        }
    }
}
@end

@implementation Airport
@synthesize Name;
@synthesize Code;
@synthesize AirportTitleLogo;
@synthesize ArrivalFlights;
@synthesize DepartureFlights;
@synthesize arrivalPagesLoaded;
@synthesize departurePagesLoaded;
- (id)init
{
    if ((self = [super init])) 
    {
        arrivalPagesLoaded = 0;
        departurePagesLoaded = 0;
        //self.ArrivalFlights = [NSMutableArray new];
        //self.DepartureFlights = [NSMutableArray new];
    }
    return self;
}
- (void)dealloc {
    [Name release];
    [Code release];
    [AirportTitleLogo release];
    [ArrivalFlights release];
    [DepartureFlights release];
    [super dealloc];
}

@end

