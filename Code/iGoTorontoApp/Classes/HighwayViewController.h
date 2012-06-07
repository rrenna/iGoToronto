//
//  HighwayViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCenter.h"
#import "iGoTorontoAppDelegate.h"
#import "IGoMainScreenController.h"
#import "CameraViewController.h"
#import "CDRoadway.h"
#import "CDCamera.h"

typedef enum 
{
	listContentType,
	distanceContentType	
} 
HighwaySection_ContentType;

@interface HighwayViewController : IGoMainScreenController <UITableViewDelegate,UITableViewDataSource> 
{
	IBOutlet UITableView* cameraListView; 
	IBOutlet UIButton* viewSelectorLeft;
	IBOutlet UIButton* viewSelectorRight;
	IBOutlet UITableViewCell* loadingDirectionListCell;
	HighwaySection_ContentType contentType;
}
@property (retain) NSArray* roadways;
@property (retain) NSMutableArray* camerasSortedByDistance;
@property (retain,nonatomic) IBOutlet UITableView* cameraListView; 
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorLeft; 
@property (retain,nonatomic) IBOutlet UIButton* viewSelectorRight;
@property (retain,nonatomic) IBOutlet UITableViewCell* loadingDirectionListCell;

-(IBAction)listViewSelected:(id)sender;
-(IBAction)distanceViewSelected:(id)sender;
-(void)viewCameraNotificationRecieved:(NSNotification*)notification;
-(void)populateCameraDistancesWithNotification:(NSNotification*)notification;
-(void)spawnCameraPopup:(id)cameraOrName;
-(void)viewChanged;
-(void)showLoadingCellInTableHeader;
-(void)hideLoadingCellInTableHeader;
-(void)sortCamerasByDistanceFromLocation:(CLLocation*)location intoArray:(NSMutableArray*)sortedCameras;
@end
