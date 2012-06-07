//
//  PlaneViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-25.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLParser.h"
#import "FlightAwareParser.h"
#import "Flight.h"
#import "FlightCellView.h"

//Forward declaration of Airport so PlaneViewController can use it
@class Airport;

@interface PlaneViewController : UIViewController <UISearchBarDelegate ,UITableViewDelegate,UITableViewDataSource> 
{
	IBOutlet UITableView* flightTable;
	IBOutlet UIActivityIndicatorView* activityIndicator;
    IBOutlet UISearchBar* flightSearchBar;
	BOOL isPrecaching;
       NSArray* airports;
    Airport* activeAirport;
    NSMutableArray* searchResults;
    BOOL isTypeArrivals;
    BOOL isUsingSearchResults;
}
@property (nonatomic,retain) IBOutlet UITableView* flightTable;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic,retain) IBOutlet UISearchBar* flightSearchBar;
@property (retain) NSArray* airports;
@property (retain) Airport* activeAirport;
@property (retain) NSMutableArray* searchResults;
@property (assign) BOOL isTypeArrivals;
@property (assign) BOOL isUsingSearchResults;

-(IBAction)refresh;
-(void)precacheResponseWithDelay:(NSNumber*)delay;
@end
@interface Airport : NSObject 
{
    NSString* Name;
    NSString* Code;
    UIImage* AirportTitleLogo;
    NSMutableArray* ArrivalFlights;
    NSMutableArray* DepartureFlights;
    int arrivalPagesLoaded;
    int departurePagesLoaded;
}
@property (retain) NSString* Name;
@property (retain) NSString* Code;
@property (retain) UIImage* AirportTitleLogo;
@property (retain) NSMutableArray* ArrivalFlights;
@property (retain) NSMutableArray* DepartureFlights;
@property (assign) int arrivalPagesLoaded;
@property (assign) int departurePagesLoaded;
@end

