//
//  StationPopupViewController.h
//
//  Created by Ryan Renna on 10-10-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "iGoTorontoAppDelegate.h"
#import "UnionBoardViewController.h"
#import "StationStopListingController.h"
//Managed Objects
#import "CDStation.h"
#import "CDFactoid.h"

@class CDLine;
@class iGoGradientButton;

@interface StationPopupViewController : IGoScreenController <UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UIView* actionPanel;
	IBOutlet UILabel* lblAddress;
	IBOutlet UILabel* lblStationDescription;
	IBOutlet UIButton* btnBoard;
    IBOutlet id btnUpcoming;
	IBOutlet UIActivityIndicatorView* activityIndicator;
}
@property (retain,nonatomic) IBOutlet UIView* actionPanel;
@property (retain,nonatomic) IBOutlet UILabel* lblAddress;
@property (retain,nonatomic) IBOutlet UILabel* lblStationDescription;
@property (retain,nonatomic) IBOutlet UIButton* btnBoard;
@property (retain,nonatomic) IBOutlet iGoGradientButton* pinButton;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (retain,nonatomic) IBOutlet UITableView* lineTable;
@property (retain) UIViewController* childViewController;
@property (retain) CDStation* station;
@property (retain) NSArray* stationLines;

/* IBActions */
- (IBAction)viewUpcoming:(id)sender;
- (IBAction)viewSchedule:(id)sender;
- (IBAction)viewBoard:(id)sender;
- (IBAction)viewMap:(id)sender;
- (IBAction)pinToHome:(id)sender;
//
-(id)initWithStationName:(NSString*)name;
-(void)layoutControls;
-(void)checkForPinnedStatus;
@end
