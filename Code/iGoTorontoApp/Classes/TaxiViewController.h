//
//  TaxiViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-13.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCenter.h"
#import "InfoPopupViewController.h"
#import "IGoMainScreenController.h"
#import "MapView.h"
#import "Place.h"

@interface CabCompany : NSObject
{
}
@property (retain) NSString* Name;
@property (retain) NSString* Phone;
@property (assign) double Rating;
@end


@interface TaxiViewController : IGoMainScreenController <UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, UITextFieldDelegate> 
{

}
@property (retain) CLLocationManager *locationManager;
@property (retain) NSArray* CabCompanies;
@property (retain) Place* fromPlace;
@property (retain) Place* toPlace;
@property (retain) CLLocation* customFromLocation;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* findMeActivityIndicator;
@property (retain, nonatomic) IBOutlet UITableView* cabTableView;
@property (retain, nonatomic) IBOutlet UIView* fareCalculatorView;
@property (retain, nonatomic) IBOutlet UIView* routePreviewView;
@property (retain, nonatomic) IBOutlet UITextField* fromLocationTextView;
@property (retain, nonatomic) IBOutlet UITextField* toLocationTextView;
@property (retain, nonatomic) IBOutlet UILabel* priceLabel;
@property (retain, nonatomic) IBOutlet UILabel* distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton* fareButton;
@property (retain, nonatomic) IBOutlet UIButton* calculateButton;
@property (retain, nonatomic) IBOutlet UIButton* showRouteButton;
@property (assign) double centsStartingFare;
@property (assign) double centsPerDistanceMeasure;
@property (assign) double centsPerMinute;
@property (assign) double distanceMeasure;

-(IBAction)showFareCalculator : (id)sender;
-(IBAction)showRouteMap : (id)sender;
-(IBAction)findFromLocation : (id)sender;
-(IBAction)calculateFare : (id)sender;
-(IBAction)fromLocationTextViewValueChanged : (id)sender;
@end
