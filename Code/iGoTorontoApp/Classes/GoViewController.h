//
//  GoViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-24.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCenter.h"
#import "IGoMainScreenController.h"
#import "StationPopupViewController.h"
#import "UnionBoardViewController.h"
#import "GoTrainMapViewController.h"

typedef enum 
{
	mapContentType,
	listContentType,
	distanceContentType	
} 
GoSection_ContentType;

@interface GoViewController : IGoMainScreenController <UITableViewDelegate,UITableViewDataSource>
{
    NSArray* lines;
	IBOutlet UIActivityIndicatorView* activityIndicatorView;
	IBOutlet UIScrollView* contentScrollView;
    IBOutlet UITableView* goListView;
	IBOutlet UIImageView* compassImageView;
	IBOutlet UIButton* viewSelectorLeft;
	IBOutlet UIButton* viewSelectorCenter;
	IBOutlet UIButton* viewSelectorRight;
	IBOutlet UITableViewCell* loadingDirectionListCell;
	UnionBoardViewController* unionBoardViewController;
	GoSection_ContentType contentType;
	BOOL isGettingLocation;
}
@property (retain) NSArray* lines;
@property (retain) NSMutableArray* stationsSortedByDistance;
@property (retain) GoTrainMapViewController* mapViewController;
@property (retain, nonatomic) UIImageView* compassImageView;
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView; 
@property (retain,nonatomic) IBOutlet UIScrollView* contentScrollView; 
@property (retain,nonatomic) IBOutlet UITableView* goListView;
@property (retain,nonatomic) IBOutlet UITableViewCell* loadingDirectionListCell;
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorLeft;
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorCenter;
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorRight;
//Union Station Board controller
@property (retain,nonatomic) UnionBoardViewController* unionBoardViewController;

/* IBActions */
-(IBAction)viewUnionBoard:(id)sender;
-(IBAction)mapViewSelected:(id)sender;
-(IBAction)listViewSelected:(id)sender;
-(IBAction)distanceViewSelected:(id)sender;
/* Custom Methods */
- (void)showLoadingCellInTableHeader;
-(void)hideLoadingCellInTableHeader;
-(void)sortStationsByDistanceFromLocation:(CLLocation*)location intoArray:(NSMutableArray*)sortedStations;

-(void)viewChanged;
-(void)viewBoardNotificationRecieved:(NSNotification*)notification;
-(void)viewStationNotificationRecieved:(NSNotification*)notification;
-(void)spawnStationPopup:(NSString*)stationName;
-(void)enabledSelectorControls;
-(void)scrollToMiddle;
@end