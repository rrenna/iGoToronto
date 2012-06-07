//
//  StationStopListingController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-16.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iGoTorontoAppDelegate.h"
#import "StopCellView.h"
#import "CDDirection.h"
#import "CDStation.h"
#import "CDStop.h"
#import "CDDayType.h"
@class CDLine;
@class AdViewController;

@interface StationStopListingController : UIViewController
{
	IBOutlet UISegmentedControl* segmentedControlDirections;
    IBOutlet UISegmentedControl* segmentedControlDayType;
    IBOutlet UITableView* stopListingTable;
    IBOutlet UILabel* customDayTypeFilterLabel;
   
	NSArray* stopData;
}
@property (retain,nonatomic) IBOutlet UISegmentedControl* segmentedControlDirections;
@property (retain,nonatomic) IBOutlet UISegmentedControl* segmentedControlDayType;
@property (retain,nonatomic) IBOutlet UITableView* stopListingTable;
@property (retain,nonatomic) IBOutlet UILabel* customDayTypeFilterLabel;
@property (retain,nonatomic) IBOutlet UIView* adSpaceView;
@property (retain) AdViewController* adViewController;
@property (retain) NSDate* customDayTypeFilterDate;
@property (retain) CDStation* station;
@property (retain) CDLine* line;

@property (retain) UIColor* cellBackgroundColour;
@property (retain) UIColor* cellForegroundColour;

@property (retain) NSMutableArray* directions;
@property (retain) NSMutableArray* dayTypes;
@property (retain) CDDirection* activeDirection;
@property (retain) NSMutableSet* todaysValidDayTypes;
@property (retain) NSString* activeDayTypeName;

-(id)initWithCustomDaytimeFilter:(NSDate*)date NibName:(NSString *)nibName bundle:(NSBundle *)bundle;
-(IBAction)directionChanged;
-(void)retrieveDayTypes;
-(void)retrieveDirections;
-(void)retrieveData;

@end