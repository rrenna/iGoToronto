    //
//  TaxiViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-13.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "TaxiViewController.h"
#import "AdMobView.h"
#import "AdViewController.h"
#import "iGoGradientButton.h"

@implementation CabCompany
@synthesize Name;
@synthesize Phone;
@synthesize Rating;
-(id)init
{
	self = [super init];
	if(self)
	{
		self.Rating = 0;
	}
	return self;
}
-(void)dealloc
{
	[Name release];
	[Phone release];
	//Rating - do not release
	[super dealloc];
}
@end

@implementation TaxiViewController
@synthesize fromPlace;
@synthesize toPlace;
@synthesize CabCompanies;
@synthesize cabTableView;
@synthesize locationManager;
@synthesize customFromLocation;
@synthesize fareCalculatorView;
@synthesize routePreviewView;
@synthesize fromLocationTextView;
@synthesize toLocationTextView;
@synthesize findMeActivityIndicator;
@synthesize priceLabel;
@synthesize distanceLabel;
@synthesize fareButton;
@synthesize calculateButton;
@synthesize showRouteButton;
@synthesize centsStartingFare;
@synthesize centsPerDistanceMeasure;
@synthesize centsPerMinute;
@synthesize distanceMeasure;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    //If Lite version setup an Ad - do not show help tab
    // and hide fare calculator
    #ifdef LITE_VERSION
    fareButton.hidden = YES;
    
    self.adViewController = [[[AdViewController alloc] init] autorelease];
    self.adViewController.currentViewController = self;
    AdMobView* mobView = [AdMobView requestAdWithDelegate:self.adViewController];
    mobView.frame = CGRectMake(0, 0, 320, 48);
    [self.adSpaceView addSubview:mobView];
    self.adSpaceView.userInteractionEnabled = YES;
    //Reduce the cab table's height by 43
    CGRect cabTableViewFrame = self.cabTableView.frame;
    cabTableViewFrame.size.height -= 48;
    self.cabTableView.frame = cabTableViewFrame;
    #else
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//Show help screen on first load
    BOOL showHelpScreen = YES;
    if([prefs objectForKey:@"ShowHelpScreen-Taxi"])
    {
        showHelpScreen = [prefs boolForKey:@"ShowHelpScreen-Taxi"];
    }
    if(showHelpScreen)
    {
        [self displayHelp:@"To get an estimation of the fare between any two locations, open the Fare calculator."];
        [prefs setBool:NO forKey:@"ShowHelpScreen-Taxi"];
        [prefs synchronize];
    }
    #endif
	
	//Hard coded values
	// Todo : sync from web
	centsStartingFare = 425;
	centsPerDistanceMeasure = 25;
	centsPerMinute = 35;
	distanceMeasure = 143;
	
	//Todo : sync from web
    
    CabCompany* executiveTaxi = [[[CabCompany alloc] init] autorelease];
	executiveTaxi.Name = @"Executivetaxi";
	executiveTaxi.Phone = @"1-416-721-9511";
	executiveTaxi.Rating = 5;
    
	CabCompany* torontoLimoCarService = [[[CabCompany alloc] init] autorelease];
	torontoLimoCarService.Name = @"Toronto Limo Car Service";
	torontoLimoCarService.Phone = @"1-416-467-5466";
	torontoLimoCarService.Rating = 5;
	
	CabCompany* emeraldTaxi = [[[CabCompany alloc] init] autorelease];
	emeraldTaxi.Name = @"Emerald Taxi";
	emeraldTaxi.Phone = @"1-888-590-9292";
	emeraldTaxi.Rating = 5;
	
	CabCompany* airportTaxiToronto = [[[CabCompany alloc] init] autorelease];
	airportTaxiToronto.Name = @"Airport Taxi Toronto";
	airportTaxiToronto.Phone = @"1-416-843-1222";
	
	CabCompany* airportLimoTaxiCanada = [[[CabCompany alloc] init] autorelease];
	airportLimoTaxiCanada.Name = @"Airport Limo Taxi Canada";
	airportLimoTaxiCanada.Phone = @"1-416-594-3400";
	
	CabCompany* mapleLeafTaxi = [[[CabCompany alloc] init] autorelease];
	mapleLeafTaxi.Name = @"Maple Leaf Taxi";
	mapleLeafTaxi.Phone = @"1-416-465-5555";
	
	CabCompany* samaTaxi = [[[CabCompany alloc] init] autorelease];
	samaTaxi.Name = @"Sama Taxi";
	samaTaxi.Phone = @"1-416-203-1331";
	
	CabCompany* olympicTaxi = [[[CabCompany alloc] init] autorelease];
	olympicTaxi.Name = @"Olympic Taxi";
	olympicTaxi.Phone = @"1-416-240-0000";
	
	CabCompany* airporTaxiInc = [[[CabCompany alloc] init] autorelease];
	airporTaxiInc.Name = @"Airpor Taxi Inc.";
	airporTaxiInc.Phone = @"1-800-465-3434";
	
	CabCompany* yellowCab = [[[CabCompany alloc] init] autorelease];
	yellowCab.Name = @"Yellow Cab";
	yellowCab.Phone = @"1-416-504-4141";
	
	CabCompany* beckTaxi = [[[CabCompany alloc] init] autorelease];
	beckTaxi.Name = @"Beck Taxi Ltd";
	beckTaxi.Phone = @"1-416-751-5555";
	
	CabCompany* aaaMarkhamAndRichmondHillTaxi = [[[CabCompany alloc] init] autorelease];
	aaaMarkhamAndRichmondHillTaxi.Name = @"AAA Markham & Richmond Hill Taxi";
	aaaMarkhamAndRichmondHillTaxi.Phone = @"1-905-895-0455";
	
	CabCompany* ambassadorExpressTaxiInc = [[[CabCompany alloc] init] autorelease];
	ambassadorExpressTaxiInc.Name = @"Ambassador Express Taxi Inc";
	ambassadorExpressTaxiInc.Phone = @"1-416-322-3800";
	
	CabCompany* abcTaxiAmbassadorsAirportAndOutOfTownExecutiveTaxiServices = [[[CabCompany alloc] init] autorelease];
	abcTaxiAmbassadorsAirportAndOutOfTownExecutiveTaxiServices.Name = @"ABC Taxi-Ambassadors Airport & Out-Of-Town Executive Taxi Services";
	abcTaxiAmbassadorsAirportAndOutOfTownExecutiveTaxiServices.Phone = @"1-416-690-3200";
	
	CabCompany* fourOneSixTaxi = [[[CabCompany alloc] init] autorelease];
	fourOneSixTaxi.Name = @"416-Taxicab";
	fourOneSixTaxi.Phone = @"1-416-829-4222";
	
	CabCompany* aaa1ABCTaxiCoOpDriver = [[[CabCompany alloc] init] autorelease];
	aaa1ABCTaxiCoOpDriver.Name = @"AAA1 ABC TAXI - CO-OP Drivers";
	aaa1ABCTaxiCoOpDriver.Phone = @"1-416-465-6400";
	
	CabCompany* wheelchairAccessibleTransit = [[[CabCompany alloc] init] autorelease];
	wheelchairAccessibleTransit.Name = @"Wheelchair Accessible Transit";
	wheelchairAccessibleTransit.Phone = @"1-877-225-2212";
	
	CabCompany* actTaxiInc = [[[CabCompany alloc] init] autorelease];
	actTaxiInc.Name = @"Act Taxi Inc";
	actTaxiInc.Phone = @"1-416-360-1100";
	
	CabCompany* imperialTaxi = [[[CabCompany alloc] init] autorelease];
	imperialTaxi.Name = @"Imperial Taxi";
	imperialTaxi.Phone = @"1-416-603-1600";
	
	CabCompany* metroCab = [[[CabCompany alloc] init] autorelease];
	metroCab.Name = @"Metro Cab Ltd";
	metroCab.Phone = @"1-416-504-8294";
	
	CabCompany* cityTaxi = [[[CabCompany alloc] init] autorelease];
	cityTaxi.Name = @"City Taxi";
	cityTaxi.Phone = @"1-416-241-1400";
	
	CabCompany* royalTaxi = [[[CabCompany alloc] init] autorelease];
	royalTaxi.Name = @"Royal Taxi";
	royalTaxi.Phone = @"1-416-777-9222";
	
	CabCompany* crownTaxi = [[[CabCompany alloc] init] autorelease];
	crownTaxi.Name = @"Crown Taxi";
	crownTaxi.Phone = @"1-416-240-0000";
	
	CabCompany* diamondTaxicab = [[[CabCompany alloc] init] autorelease];
	diamondTaxicab.Name = @"Diamond Taxicab";
	diamondTaxicab.Phone = @"1-416-366-6868";
	
	self.CabCompanies = [NSArray arrayWithObjects:aaa1ABCTaxiCoOpDriver,aaaMarkhamAndRichmondHillTaxi,abcTaxiAmbassadorsAirportAndOutOfTownExecutiveTaxiServices,actTaxiInc,airportLimoTaxiCanada,airporTaxiInc,airportTaxiToronto,ambassadorExpressTaxiInc,beckTaxi,cityTaxi,crownTaxi,diamondTaxicab,emeraldTaxi,executiveTaxi,fourOneSixTaxi,imperialTaxi,mapleLeafTaxi,metroCab,olympicTaxi,samaTaxi,torontoLimoCarService,royalTaxi,wheelchairAccessibleTransit,yellowCab,nil];
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    self.findMeActivityIndicator = nil;
    self.cabTableView = nil;
    self.fareCalculatorView = nil;
    self.routePreviewView = nil;
    self.fromLocationTextView = nil;
    self.toLocationTextView = nil;
    self.priceLabel = nil;
    self.distanceLabel = nil;
    self.fareButton = nil;
    self.calculateButton = nil;
    self.showRouteButton = nil;
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[fromPlace release];
	[toPlace release];
	[CabCompanies release];
	[cabTableView release];
	[customFromLocation release];
	[locationManager release];
	[fareCalculatorView release];
	[routePreviewView release];
	[fromLocationTextView release];
	[toLocationTextView release];
	[findMeActivityIndicator release];
	[priceLabel release];
	[distanceLabel release];
    [fareButton release];
    [calculateButton release];
	[showRouteButton release];
	//centsStartingFare - do not release
	//centsPerDistanceMeasure - do not release
	//centsPerMinute - do not release
	//distanceMeasure - do not release
    [super dealloc];
}
/* IBActions */
-(IBAction)showRouteMap : (id) sender
{
	NSString* routeUrlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",fromPlace.latitude,fromPlace.longitude,toPlace.latitude,toPlace.longitude];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeUrlString]];
}
-(IBAction)findFromLocation : (id)sender
{
	[[LocationCenter sharedCenter] updateLocation];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateFromLocationTextboxWithNotification:) name:NOTIFICATION_LOCATION_CHANGED object:nil];
	
	//Shows the activity indicator beside the "find me" button
	self.findMeActivityIndicator.hidden = NO;
}
-(IBAction)showFareCalculator : (id)sender
{
	//Check if there's an active internet connection
	Reachability * reachability = [Reachability reachabilityForInternetConnection];
	if(![reachability isReachable])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[Constants sharedConstants] ErrorMessage_NoInternetConnection] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];
		[alert release];
	}
	//If user has an active internet connection, display fare calculator screen
	else 
	{

		self.infoPopupViewController = [[[InfoPopupViewController alloc] initWithView:self.fareCalculatorView andTitle:@"Fare Calculator"] autorelease];
		[self.infoPopupViewController slideIn];
	}
}
-(IBAction)calculateFare : (id)sender
{
	//Remove the keyboard
	[self.toLocationTextView resignFirstResponder];
	[self.fromLocationTextView resignFirstResponder];
	
	NSString* fromLatLongString;
	NSString* urlString;
	//If a custom from location has been set
	if(customFromLocation)
	{
		fromLatLongString = [NSString stringWithFormat:@"%f,%f",customFromLocation.coordinate.latitude,customFromLocation.coordinate.longitude];
	}
	//If no custom from location has been set
	else
	{
		urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [self.fromLocationTextView.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		fromLatLongString = [[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]] autorelease];
	}
	
	urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [self.toLocationTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString* toLatLongString = [[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]] autorelease];
	NSArray *fromComponents = [fromLatLongString componentsSeparatedByString: @","];
	NSArray *toComponents = [toLatLongString componentsSeparatedByString: @","];
	double fromLat = [[fromComponents objectAtIndex:[fromComponents count] -2] doubleValue];
	double fromLong = [[fromComponents objectAtIndex:[fromComponents count] - 1] doubleValue];
	double toLat = [[toComponents objectAtIndex:[toComponents count] -2] doubleValue];
	double toLong = [[toComponents objectAtIndex:[toComponents count] - 1] doubleValue];
	
	//self.mapView = [[[MapView alloc] initWithFrame: CGRectMake(0, 0, self.routePreviewView.frame.size.width, self.routePreviewView.frame.size.height)] autorelease];
	
	self.fromPlace = [[[Place alloc] init] autorelease];
	fromPlace.name = self.fromLocationTextView.text;
	fromPlace.description = @"";
	fromPlace.latitude = fromLat;
	fromPlace.longitude = fromLong;
	
	self.toPlace = [[[Place alloc] init] autorelease];
	toPlace.name = self.toLocationTextView.text;
	toPlace.description = @"";
	toPlace.latitude = toLat;
	toPlace.longitude = toLong;
	
	PlaceMark* from = [[[PlaceMark alloc] initWithPlace:fromPlace] autorelease];
	PlaceMark* to = [[[PlaceMark alloc] initWithPlace:toPlace] autorelease];
	
	//
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", from.coordinate.latitude, from.coordinate.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", to.coordinate.latitude, to.coordinate.longitude];
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	//NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	
	int distanceMeters = 0;
	int durationMinutes = 0;
	
	NSArray* components = [apiResponse componentsSeparatedByString:@"\""];
	 NSString* routeDescriptionDetails;
	 if([components count] > 0)
	 {
		 routeDescriptionDetails = [components objectAtIndex:1];
		 routeDescriptionDetails = [routeDescriptionDetails stringByReplacingOccurrencesOfString:@"\\x26#160;" withString:@""];
		 routeDescriptionDetails = [routeDescriptionDetails stringByReplacingOccurrencesOfString:@"," withString:@""];
		 
		 NSArray* routeDetailsComponents = [routeDescriptionDetails componentsSeparatedByString:@"/"];
		 
		 //Parse distance
		 int distanceMultiplyer = 1;
		 NSString* distanceComponent = [routeDetailsComponents objectAtIndex:0];
		 NSRange rangeOfKMCharacters = [distanceComponent rangeOfString:@"km"];
		 NSRange rangeOfMICharacters = [distanceComponent rangeOfString:@"mi"];
		 if(rangeOfKMCharacters.location != NSNotFound)
		 {
			 distanceMultiplyer = 1000;
			 distanceComponent = [distanceComponent stringByReplacingOccurrencesOfString:@"km" withString:@""];
			 distanceComponent = [distanceComponent stringByReplacingOccurrencesOfString:@"(" withString:@""];	
		 }
		 if(rangeOfMICharacters.location != NSNotFound)
		 {
			 //If mi is detected, google is returning a unknown distance or a distance too small to take a taxi for
			 distanceComponent = @"0";
		 }
		 else 
		 {
			 distanceComponent = [distanceComponent stringByReplacingOccurrencesOfString:@"m" withString:@""];
			 distanceComponent = [distanceComponent stringByReplacingOccurrencesOfString:@")" withString:@""];
		 }
		 
		 distanceMeters = [distanceComponent doubleValue] * distanceMultiplyer;

		 //Parse duration
		 int indexOfMinutesString = 0;
		 NSString* durationComponent = [routeDetailsComponents objectAtIndex:1];
		 durationComponent = [durationComponent stringByReplacingOccurrencesOfString:@")" withString:@""];
		 NSArray* timeComponents =[durationComponent componentsSeparatedByString:@" "];
		 //Find index of "mins"
		 int i = 0;
		 for(NSString* component in timeComponents)
		 {
			 if([component isEqualToString:@"mins"])
			 {
				 indexOfMinutesString = i;
				 break;
			 }
			 i++;
		 }
		 
		 int minutes = 0;
		 //If the string was found in a valid location
		 if(indexOfMinutesString > 0)
		 {
			 minutes = [[timeComponents objectAtIndex:indexOfMinutesString - 1] intValue];
		 }
		 durationMinutes += minutes;
	 }
	if(distanceMeters == 0)
	{
		UIAlertView *distanceErrorAlert = [[UIAlertView alloc] initWithTitle: @"I think you made a mistake" message: @"Your route can not be computed, try to include more detailed addresses." delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[distanceErrorAlert show];
		[distanceErrorAlert release];
		self.priceLabel.text = @"";
		self.distanceLabel.text = @"";
	}
	else
	{
		if(distanceMeters > 300000)
		{
			UIAlertView *distanceErrorAlert = [[UIAlertView alloc] initWithTitle: @"I think you made a mistake" message: @"Your route is over 300km distance, try to include more detailed addresses." delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			[distanceErrorAlert show];
			[distanceErrorAlert release];
		}
			 
		double estimatedFareCents = centsStartingFare +  ( (distanceMeters / distanceMeasure) * centsPerDistanceMeasure) + (durationMinutes * centsPerMinute);
		NSDecimalNumber* estimatedFareNumber = [NSDecimalNumber numberWithDouble:estimatedFareCents];
		NSNumberFormatter *currencyFormatter  = [[[NSNumberFormatter alloc] init] autorelease];
		[currencyFormatter setGeneratesDecimalNumbers:YES];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		if (estimatedFareNumber == nil)
		{
			estimatedFareNumber = [NSDecimalNumber zero];
		}
		
		NSDecimalNumber *price  = [NSDecimalNumber decimalNumberWithMantissa:[estimatedFareNumber integerValue]
																	exponent:(-1 * [currencyFormatter maximumFractionDigits])
																  isNegative:NO];
		
		self.priceLabel.text = [NSString stringWithFormat:@"$%@",[price stringValue]];
		self.distanceLabel.text = [NSString stringWithFormat:@"Approximately %d km",(int)(distanceMeters/1000)];
		//Fade elements in
		CABasicAnimation *shroudAlphaAnimation = nil;
		shroudAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[shroudAlphaAnimation setToValue:[NSNumber numberWithDouble:1.0]];
		[shroudAlphaAnimation setFromValue:[NSNumber numberWithDouble:0.0]];
		[shroudAlphaAnimation setDuration:0.5f];
		[self.priceLabel.layer addAnimation: shroudAlphaAnimation forKey: @"opacityAnimationInt"];
		[self.distanceLabel.layer addAnimation: shroudAlphaAnimation forKey: @"opacityAnimationInt"];
		[self.showRouteButton.layer addAnimation:shroudAlphaAnimation forKey:@"opacityAnimationInt"];
		self.showRouteButton.hidden = NO;
	}
}
-(IBAction)fromLocationTextViewValueChanged : (id)sender
{
	if(self.customFromLocation)
	{
		//If a custom section has been set, any alterations to the from text box cancels out the custom lat long
		self.customFromLocation = nil;
		[self.fromLocationTextView setTextColor:[UIColor blackColor]];
	}
}
/* Template Methods */
-(void)layoutControls
{
    CGPoint currentCalculateCenter = self.calculateButton.center;
    CGPoint currentShowRouteCenter = self.showRouteButton.center;
    
    currentCalculateCenter.x = self.view.center.x;
    currentShowRouteCenter.x = self.view.center.x;
    
    self.calculateButton.center = currentCalculateCenter;
    self.showRouteButton.center = currentShowRouteCenter;
}
/* Custom Methods */
-(void)populateFromLocationTextboxWithNotification:(NSNotification*)notification
{
	CLLocation* currentLocation = [[LocationCenter sharedCenter] currentLocation];
	//Check if a location was definately returned
	if(currentLocation)
	{
		[self performSelectorOnMainThread:@selector(setCustomFrom:) withObject:currentLocation waitUntilDone:NO];
		[self.locationManager performSelectorOnMainThread:@selector(stopUpdatingLocation) withObject:nil waitUntilDone:NO];
	}
}
-(void)setCustomFrom : (CLLocation*) location
{
	//Stops the activity indicator from being displayed
	self.findMeActivityIndicator.hidden = YES;
	
	self.customFromLocation = location;
	fromLocationTextView.text = @"Here";
	fromLocationTextView.textColor = [UIColor blueColor];
}
/* UITableView Delegate & DataSource methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [CabCompanies count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"%i~%i",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		CabCompany* company = [CabCompanies objectAtIndex:indexPath.row];
		cell.textLabel.text = company.Name;
		
		// Configure the cell...        
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.font = [Constants sharedConstants].cellTextFontSmall;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//Configure accessory
		CGRect callButtonFrame = CGRectMake(0, 0, 70, 28);
			
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]])
		{
			// device has phone capabilities
			iGoGradientButton* callButton = [[iGoGradientButton alloc] initWithFrame:callButtonFrame];
			[callButton setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
			[callButton setTitle:@"Call" forState:UIControlStateNormal];
            cell.accessoryView = callButton;

			[callButton addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
			[callButton release];
		}
		else 
		{
			CabCompany* cab = [self.CabCompanies objectAtIndex:indexPath.row];
			UILabel* telephoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
			
			[telephoneNumberLabel setBackgroundColor:[UIColor clearColor]];
			[telephoneNumberLabel setFont:[[Constants sharedConstants] cellTextFontSmall] ];
			[telephoneNumberLabel setTextColor:[UIColor whiteColor]];
			[telephoneNumberLabel setText:cab.Phone];
			[telephoneNumberLabel sizeToFit];
			cell.accessoryView = telephoneNumberLabel;
			[telephoneNumberLabel release];
		}
	}
	[CellIdentifier release];
	return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.cabTableView];
	NSIndexPath *indexPath = [self.cabTableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.cabTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath :(NSIndexPath *)indexPath 
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	CabCompany* cab = [self.CabCompanies objectAtIndex:indexPath.row];
	NSString * url = [NSString stringWithFormat:@"tel://%@",cab.Phone];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
/* Core Location Delegate Methods */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
}
/* UITextField Delegate Methods */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == fromLocationTextView)
	{
		[toLocationTextView becomeFirstResponder];
	}
	else if(textField == toLocationTextView) 
	{
		[self calculateFare:textField];
	}
	return YES;
}
@end
