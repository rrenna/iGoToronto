//
//  CameraViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCenter.h"
#import "CDCamera.h"
@class iGoGradientButton;

@interface CameraViewController : IGoScreenController
{
}

@property (retain,nonatomic) IBOutlet UIImageView* cameraImageView;
@property (retain,nonatomic) IBOutlet UILabel* cameraStatusLabel;
@property (retain,nonatomic) IBOutlet UILabel* cameraNameLabel;
@property (retain,nonatomic) IBOutlet UIButton* showRouteButton;
@property (retain,nonatomic) IBOutlet iGoGradientButton* pinButton;
@property (retain,nonatomic) IBOutlet UITableView* cameraTable;
@property (retain,nonatomic) IBOutlet UITableViewCell* descriptionCell;
@property (retain,nonatomic) IBOutlet UITableViewCell* pinCell;
@property (retain,nonatomic) IBOutlet UITableViewCell* mapCell;
@property (retain) CDCamera* Camera;

- (IBAction)viewMap:(id)sender;
- (IBAction)pinToHome:(id)sender;

-(id)initWithCameraName:(NSString*)cameraName;
-(id)initWithCamera:(CDCamera*)camera;
-(void)presentCameraImage;
-(void)checkForPinnedStatus;
@end
