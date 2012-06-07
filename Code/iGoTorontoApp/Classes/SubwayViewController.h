//
//  SubwayViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-22.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "iGoTorontoAppDelegate.h"
#import "IGoMainScreenController.h"
#import "SubwayMapViewController.h"
#import "SubwayStationPopupViewController.h"
#import "CDSubwayStation.h"

typedef enum 
{
	mapContentType,
	listContentType,
	distanceContentType	
} 
SubwaySection_ContentType;

@interface SubwayViewController : IGoMainScreenController <UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UIScrollView* subwayMapScrollView;
	IBOutlet UITableView* subwayListView;
	IBOutlet UITableView* subwayLabelView;
	IBOutlet UIView* labelsView;
	IBOutlet UIImageView* compassImageView;
	SubwaySection_ContentType contentType;
	IBOutlet UIButton* labelButton;
	IBOutlet UIButton* viewSelectorLeft;
	IBOutlet UIButton* viewSelectorRight;
	IBOutlet UITableViewCell* loadingDirectionListCell;
}

@property (retain,nonatomic) IBOutlet UIScrollView* subwayMapScrollView;
@property (retain,nonatomic) IBOutlet UITableView* subwayListView;
@property (retain,nonatomic) IBOutlet UITableView* subwayLabelView;
@property (retain,nonatomic) IBOutlet UIView* labelsView;
@property (retain,nonatomic) IBOutlet UIImageView* compassImageView;
@property (retain,nonatomic) IBOutlet UIButton* labelButton;
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorLeft;
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorRight;
@property (retain,nonatomic) IBOutlet UITableViewCell* loadingDirectionListCell;
@property (retain) CLLocationManager *locationManager;
@property (retain) SubwayMapViewController * subwayMapViewController;
@property (retain) NSMutableArray * enabledLabelsArray;
@property (retain) NSArray * stations;
@property (retain) NSMutableArray * stationsSortedByDistance;
/* IBActions */
-(IBAction)showLabels:(id)sender;
-(IBAction)hideLabels:(id)sender;
-(IBAction)viewUnionBoard:(id)sender;
-(IBAction)mapViewSelected:(id)sender;
-(IBAction)listViewSelected:(id)sender;
-(IBAction)distanceViewSelected:(id)sender;
-(void)scrollToMiddle;
-(void)enableSubwayLineByIndex:(int)index;
@end
