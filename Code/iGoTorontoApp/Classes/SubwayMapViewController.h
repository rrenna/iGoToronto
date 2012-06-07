//
//  GoMapViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-22.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubwayMapViewController : UIViewController {

	IBOutlet UIView* YoungeUniversitySpadinaLineView;
	IBOutlet UIView* YoungeUniversitySpadinaandBloorDanforthLineView;
	IBOutlet UIView* YoungeUniversitySpadinaandSheppardLineView;
	IBOutlet UIView* ScarboroughRTLineView;
	IBOutlet UIView* ScarboroughRTandBloorLineView;
	IBOutlet UIView* BloorDanforthLineView;
	IBOutlet UIView* BloorDanforthRotateView;
	IBOutlet UIView* SheppardLineView;
}

@property (retain,nonatomic) IBOutlet UIView* YoungeUniversitySpadinaLineView;
@property (retain,nonatomic) IBOutlet UIView* YoungeUniversitySpadinaandBloorDanforthLineView;
@property (retain,nonatomic) IBOutlet UIView* YoungeUniversitySpadinaandSheppardLineView;
@property (retain,nonatomic) IBOutlet UIView* ScarboroughRTLineView;
@property (retain,nonatomic) IBOutlet UIView* ScarboroughRTandBloorLineView;
@property (retain,nonatomic) IBOutlet UIView* BloorDanforthLineView;
@property (retain,nonatomic) IBOutlet UIView* BloorDanforthRotateView;
@property (retain,nonatomic) IBOutlet UIView* SheppardLineView;

// IBActions
// Scarborough RT
-(IBAction)spawnMcCowanPopup:(id)sender;
-(IBAction)spawnScarboroughCentrePopup:(id)sender;
-(IBAction)spawnMidlandPopup:(id)sender;
-(IBAction)spawnEllesmerePopup:(id)sender;
-(IBAction)spawnLawrenceEastPopup:(id)sender;
// Scarborough RT & Bloor-Danforth
-(IBAction)spawnKennedyPopup:(id)sender;
// Bloor-Danforth
-(IBAction)spawnWardenPopup:(id)sender;
-(IBAction)spawnVictoriaParkPopup:(id)sender;
-(IBAction)spawnMainStreetPopup:(id)sender;
-(IBAction)spawnWoodbinePopup:(id)sender;
-(IBAction)spawnCoxwellPopup:(id)sender;
-(IBAction)spawnGreenwoodPopup:(id)sender;
-(IBAction)spawnDonlandsPopup:(id)sender;
-(IBAction)spawnPapePopup:(id)sender;
-(IBAction)spawnChesterPopup:(id)sender;
-(IBAction)spawnBroadviewPopup:(id)sender;
-(IBAction)spawnCastleFrankPopup:(id)sender;
-(IBAction)spawnSherbournePopup:(id)sender;
-(IBAction)spawnBayPopup:(id)sender;
-(IBAction)spawnBathurstPopup:(id)sender;
-(IBAction)spawnChristiePopup:(id)sender;
-(IBAction)spawnOssingtonPopup:(id)sender;
-(IBAction)spawnDufferinPopup:(id)sender;
-(IBAction)spawnLansdownePopup:(id)sender;
-(IBAction)spawnKeelePopup:(id)sender;
-(IBAction)spawnDundasWestPopup:(id)sender;
-(IBAction)spawnHighParkPopup:(id)sender;
-(IBAction)spawnRunnymedePopup:(id)sender;
-(IBAction)spawnJanePopup:(id)sender;
-(IBAction)spawnOldMillPopup:(id)sender;
-(IBAction)spawnRoyalYorkPopup:(id)sender;
-(IBAction)spawnIslingtonPopup:(id)sender;
-(IBAction)spawnKiplingPopup:(id)sender;
// Bloor-Danforth & Younge-University-Spadina
-(IBAction)spawnSpadinaPopup:(id)sender;
-(IBAction)spawnStGeorgePopup:(id)sender;
-(IBAction)spawnBloorYoungePopup:(id)sender;
//Younge-University-Spadina
-(IBAction)spawnFinchPopup:(id)sender;
-(IBAction)spawnNorthYorkCentrePopup:(id)sender;
-(IBAction)spawnYorkMillsPopup:(id)sender;
-(IBAction)spawnLawrencePopup:(id)sender;
-(IBAction)spawnEglintonPopup:(id)sender;
-(IBAction)spawnDavisvillePopup:(id)sender;
-(IBAction)spawnStClairPopup:(id)sender;
-(IBAction)spawnSummerhillPopup:(id)sender;
-(IBAction)spawnRosedalePopup:(id)sender;
-(IBAction)spawnWellesleyPopup:(id)sender;
-(IBAction)spawnCollegePopup:(id)sender;
-(IBAction)spawnDundasPopup:(id)sender;
-(IBAction)spawnQueenPopup:(id)sender;
-(IBAction)spawnKingPopup:(id)sender;
-(IBAction)spawnUnionPopup:(id)sender;
-(IBAction)spawnStAndrewPopup:(id)sender;
-(IBAction)spawnOsgoodePopup:(id)sender;
-(IBAction)spawnStPatrickPopup:(id)sender;
-(IBAction)spawnQueensParkPopup:(id)sender;
-(IBAction)spawnMuseumPopup:(id)sender;
-(IBAction)spawnDupontPopup:(id)sender;
-(IBAction)spawnStClairWestPopup:(id)sender;
-(IBAction)spawnEglingtonWestPopup:(id)sender;
-(IBAction)spawnGlencairnPopup:(id)sender;
-(IBAction)spawnLawrenceWestPopup:(id)sender;
-(IBAction)spawnYorkdalePopup:(id)sender;
-(IBAction)spawnWilsonPopup:(id)sender;
-(IBAction)spawnDownsviewPopup:(id)sender;
// Younge-University-Spadina & Sheppard
-(IBAction)spawnSheppardYoungePopup:(id)sender;
// Sheppard
-(IBAction)spawnBayviewPopup:(id)sender;
-(IBAction)spawnBessarionPopup:(id)sender;
-(IBAction)spawnLesliePopup:(id)sender;
-(IBAction)spawnDonMillsPopup:(id)sender;
//Custom Methods
-(void)spawnStationPopup:(NSString*)stationName;
@end
