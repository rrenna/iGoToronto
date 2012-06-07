//
//  SubwayStationPopupViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-23.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iGoTorontoAppDelegate.h"
#import "CDSubwayStation.h"

@interface SubwayStationPopupViewController : UIViewController 
{
    IBOutlet UILabel* lblStationDescription;
	IBOutlet UILabel* lblAddress;
    CDSubwayStation* station;	
}
@property (retain,nonatomic) IBOutlet UILabel* lblStationDescription;
@property (retain,nonatomic) IBOutlet UILabel* lblAddress;
@property (retain) CDSubwayStation* station;

-(id)initWithStationName:(NSString*)name;
/* IBActions */
- (IBAction)viewMap:(id)sender;
@end
