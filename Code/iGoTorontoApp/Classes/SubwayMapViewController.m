    //
//  GoMapViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-22.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "SubwayMapViewController.h"

@implementation SubwayMapViewController
@synthesize YoungeUniversitySpadinaLineView;
@synthesize YoungeUniversitySpadinaandSheppardLineView;
@synthesize YoungeUniversitySpadinaandBloorDanforthLineView;
@synthesize ScarboroughRTLineView;
@synthesize ScarboroughRTandBloorLineView;
@synthesize BloorDanforthLineView;
@synthesize BloorDanforthRotateView;
@synthesize SheppardLineView;

- (void)viewDidLoad 
{    
	[UIView beginAnimations:@"rotateToViewableAngle" context:nil];
	[UIView setAnimationDuration:0.0];
	for(UILabel* stationLabel in BloorDanforthRotateView.subviews)
	{
		stationLabel.transform = CGAffineTransformMakeRotation(-1.0);
	}
	[UIView commitAnimations];
	
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.YoungeUniversitySpadinaLineView = nil;
    self.YoungeUniversitySpadinaandBloorDanforthLineView = nil;
    self.YoungeUniversitySpadinaandSheppardLineView = nil;
    self.ScarboroughRTLineView = nil;
    self.ScarboroughRTandBloorLineView = nil;
    self.BloorDanforthLineView = nil;
    self.BloorDanforthRotateView = nil;
    self.SheppardLineView = nil;    
}
- (void)dealloc 
{
	[YoungeUniversitySpadinaLineView release];
	[YoungeUniversitySpadinaandBloorDanforthLineView release];
	[YoungeUniversitySpadinaandSheppardLineView release];
	[ScarboroughRTLineView release];
	[ScarboroughRTandBloorLineView release];
	[BloorDanforthLineView release];
	[BloorDanforthRotateView release];
	[SheppardLineView release];
    [super dealloc];
}

// IBActions
// Scarborough RT
-(IBAction)spawnMcCowanPopup:(id)sender
{
    [self spawnStationPopup:@"McCowan"];
}
-(IBAction)spawnScarboroughCentrePopup:(id)sender
{
    [self spawnStationPopup:@"Scarborough Centre"];
}
-(IBAction)spawnMidlandPopup:(id)sender
{
    [self spawnStationPopup:@"Midland"];
}
-(IBAction)spawnEllesmerePopup:(id)sender
{
    [self spawnStationPopup:@"Ellesmere"];
}
-(IBAction)spawnLawrenceEastPopup:(id)sender
{
    [self spawnStationPopup:@"Lawrence East"];
}
// Scarborough RT & Bloor-Danforth
-(IBAction)spawnKennedyPopup:(id)sender
{
    [self spawnStationPopup:@"Kennedy"];
}

// Bloor-Danforth
-(IBAction)spawnWardenPopup:(id)sender
{
    [self spawnStationPopup:@"Warden"];
}
-(IBAction)spawnVictoriaParkPopup:(id)sender
{
    [self spawnStationPopup:@"Victoria Park"];
}
-(IBAction)spawnMainStreetPopup:(id)sender
{
    [self spawnStationPopup:@"Main Street"];
}
-(IBAction)spawnWoodbinePopup:(id)sender
{
    [self spawnStationPopup:@"Woodbine"];
}
-(IBAction)spawnCoxwellPopup:(id)sender
{
    [self spawnStationPopup:@"Coxwell"];
}
-(IBAction)spawnGreenwoodPopup:(id)sender
{
    [self spawnStationPopup:@"Greenwood"];
}
-(IBAction)spawnDonlandsPopup:(id)sender
{
    [self spawnStationPopup:@"Donlands"];
}
-(IBAction)spawnPapePopup:(id)sender
{
    [self spawnStationPopup:@"Pape"];
}
-(IBAction)spawnChesterPopup:(id)sender
{
    [self spawnStationPopup:@"Chester"];
}
-(IBAction)spawnBroadviewPopup:(id)sender
{
    [self spawnStationPopup:@"Broadview"];
}
-(IBAction)spawnCastleFrankPopup:(id)sender
{
    [self spawnStationPopup:@"Castle Frank"];
}
-(IBAction)spawnSherbournePopup:(id)sender
{
    [self spawnStationPopup:@"Sherbourne"];
}
-(IBAction)spawnBayPopup:(id)sender
{
    [self spawnStationPopup:@"Bay"];
}
-(IBAction)spawnBathurstPopup:(id)sender
{
    [self spawnStationPopup:@"Bathurst"];
}
-(IBAction)spawnChristiePopup:(id)sender
{
    [self spawnStationPopup:@"Christie"];
}
-(IBAction)spawnOssingtonPopup:(id)sender
{
    [self spawnStationPopup:@"Ossington"];
}
-(IBAction)spawnDufferinPopup:(id)sender
{
    [self spawnStationPopup:@"Dufferin"];
}
-(IBAction)spawnLansdownePopup:(id)sender
{
    [self spawnStationPopup:@"Lansdowne"];
}
-(IBAction)spawnKeelePopup:(id)sender
{
    [self spawnStationPopup:@"Keele"];
}
-(IBAction)spawnDundasWestPopup:(id)sender
{
    [self spawnStationPopup:@"Dundas West"];
}
-(IBAction)spawnHighParkPopup:(id)sender
{
    [self spawnStationPopup:@"High Park"];
}
-(IBAction)spawnRunnymedePopup:(id)sender
{
    [self spawnStationPopup:@"Runnymede"];
}
-(IBAction)spawnJanePopup:(id)sender
{
    [self spawnStationPopup:@"Jane"];
}
-(IBAction)spawnOldMillPopup:(id)sender
{
    [self spawnStationPopup:@"Old Mill"];
}
-(IBAction)spawnRoyalYorkPopup:(id)sender
{
    [self spawnStationPopup:@"Royal York"];
}
-(IBAction)spawnIslingtonPopup:(id)sender
{
    [self spawnStationPopup:@"Islington"];
}
-(IBAction)spawnKiplingPopup:(id)sender
{
    [self spawnStationPopup:@"Kipling"];
}
// Bloor-Danforth & Younge-University-Spadina
-(IBAction)spawnSpadinaPopup:(id)sender
{
    [self spawnStationPopup:@"Spadina"];
}
-(IBAction)spawnStGeorgePopup:(id)sender
{
    [self spawnStationPopup:@"St. George"];
}
-(IBAction)spawnBloorYoungePopup:(id)sender
{
    [self spawnStationPopup:@"Bloor-Yonge"];
}
//Younge-University-Spadina
-(IBAction)spawnFinchPopup:(id)sender
{
    [self spawnStationPopup:@"Finch"];
}
-(IBAction)spawnNorthYorkCentrePopup:(id)sender
{
    [self spawnStationPopup:@"North York Centre"];
}
-(IBAction)spawnYorkMillsPopup:(id)sender
{
    [self spawnStationPopup:@"York Mills"];
}
-(IBAction)spawnLawrencePopup:(id)sender
{
    [self spawnStationPopup:@"Lawrence"];
}
-(IBAction)spawnEglintonPopup:(id)sender
{
    [self spawnStationPopup:@"Eglinton"];
}
-(IBAction)spawnDavisvillePopup:(id)sender
{
    [self spawnStationPopup:@"Davisville"];
}
-(IBAction)spawnStClairPopup:(id)sender
{
    [self spawnStationPopup:@"St. Clair"];
}
-(IBAction)spawnSummerhillPopup:(id)sender
{
    [self spawnStationPopup:@"Summerhill"];
}
-(IBAction)spawnRosedalePopup:(id)sender
{
    [self spawnStationPopup:@"Rosedale"];
}
-(IBAction)spawnWellesleyPopup:(id)sender
{
    [self spawnStationPopup:@"Wellesley"];
}
-(IBAction)spawnCollegePopup:(id)sender
{
    [self spawnStationPopup:@"College"];
}
-(IBAction)spawnDundasPopup:(id)sender
{
    [self spawnStationPopup:@"Dundas"];
}
-(IBAction)spawnQueenPopup:(id)sender
{
    [self spawnStationPopup:@"Queen"];
}
-(IBAction)spawnKingPopup:(id)sender
{
    [self spawnStationPopup:@"King"];
}
-(IBAction)spawnUnionPopup:(id)sender
{
    [self spawnStationPopup:@"Union"];
}
-(IBAction)spawnStAndrewPopup:(id)sender
{
    [self spawnStationPopup:@"St. Andrew"];
}
-(IBAction)spawnOsgoodePopup:(id)sender
{
    [self spawnStationPopup:@"Osgoode"];
}
-(IBAction)spawnStPatrickPopup:(id)sender
{
    [self spawnStationPopup:@"St. Patrick"];
}
-(IBAction)spawnQueensParkPopup:(id)sender
{
    [self spawnStationPopup:@"Queen's Park"];
}
-(IBAction)spawnMuseumPopup:(id)sender
{
    [self spawnStationPopup:@"Museum"];
}
-(IBAction)spawnDupontPopup:(id)sender
{
    [self spawnStationPopup:@"Dupont"];
}
-(IBAction)spawnStClairWestPopup:(id)sender
{
    [self spawnStationPopup:@"St. Clair West"];
}
-(IBAction)spawnEglingtonWestPopup:(id)sender
{
    [self spawnStationPopup:@"Eglinton West"];
}
-(IBAction)spawnGlencairnPopup:(id)sender
{
    [self spawnStationPopup:@"Glencairn"];
}
-(IBAction)spawnLawrenceWestPopup:(id)sender
{
    [self spawnStationPopup:@"Lawrence West"];
}
-(IBAction)spawnYorkdalePopup:(id)sender
{
    [self spawnStationPopup:@"Yorkdale"];
}
-(IBAction)spawnWilsonPopup:(id)sender
{
    [self spawnStationPopup:@"Wilson"];
}
-(IBAction)spawnDownsviewPopup:(id)sender
{
    [self spawnStationPopup:@"Downsview"];
}
// Younge-University-Spadina & Sheppard
-(IBAction)spawnSheppardYoungePopup:(id)sender
{
    [self spawnStationPopup:@"Sheppard-Yonge"];
}
 // Sheppard
-(IBAction)spawnBayviewPopup:(id)sender
{
    [self spawnStationPopup:@"Bayview"];
}
-(IBAction)spawnBessarionPopup:(id)sender
{
    [self spawnStationPopup:@"Bessarion"];
}
-(IBAction)spawnLesliePopup:(id)sender
{
    [self spawnStationPopup:@"Leslie"];
}
-(IBAction)spawnDonMillsPopup:(id)sender
{
    [self spawnStationPopup:@"Don Mills"];
}
/* Custom Methods */
-(void)spawnStationPopup:(NSString*)stationName
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUBWAY_STATION_VIEW object:stationName];
}
@end
