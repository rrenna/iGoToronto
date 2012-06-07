//
//  GoTrainMapViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-11.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoPopupViewController.h"
#import "StationPopupViewController.h"

/* GoLineController Class*/
@interface GoLineController : UIViewController 
{
    IBOutlet UIButton* lineImage;
}
@property (retain,nonatomic) IBOutlet UIButton* lineImage;
-(void)enable;
@end

@interface GoTrainMapViewController : UIViewController 
{
}

@property (retain) InfoPopupViewController* infoPopupViewController;
@property (retain,nonatomic) IBOutlet GoLineController* LakeshoreWestLineController;
@property (retain,nonatomic) IBOutlet GoLineController* LakeshoreEastLineController;
@property (retain,nonatomic) IBOutlet GoLineController* RichmondHillLineController;
@property (retain,nonatomic) IBOutlet GoLineController* StouffvilleLineController;

@property (retain,nonatomic) IBOutlet GoLineController* MiltonLineController;

@property (retain,nonatomic) IBOutlet GoLineController* BarrieLineController;
@property (retain,nonatomic) IBOutlet GoLineController* GeorgetownLineController;
// IBActions
// Union
-(IBAction)spawnUnionPopup:(id)sender;
// Lakeshore West
-(IBAction)spawnExibitionPopup:(id)sender;
-(IBAction)spawnMimicoPopup:(id)sender;
-(IBAction)spawnLongBranchPopup:(id)sender;
-(IBAction)spawnPortCreditPopup:(id)sender;
-(IBAction)spawnClarksonPopup:(id)sender;
-(IBAction)spawnOakvillePopup:(id)sender;
-(IBAction)spawnBrontePopup:(id)sender;
-(IBAction)spawnApplebyPopup:(id)sender;
-(IBAction)spawnBurlingtonPopup:(id)sender;
-(IBAction)spawnAldershotPopup:(id)sender;
-(IBAction)spawnHamiltonPopup:(id)sender;
/* Milton */
-(IBAction)spawnKiplingPopup:(id)sender;
-(IBAction)spawnDixiePopup:(id)sender;
-(IBAction)spawnCooksvillePopup:(id)sender;
-(IBAction)spawnErindalePopup:(id)sender;
-(IBAction)spawnStreetsvillePopup:(id)sender;
-(IBAction)spawnMeadowvalePopup:(id)sender;
-(IBAction)spawnLisgarPopup:(id)sender;
-(IBAction)spawnMiltonPopup:(id)sender;
/* Georgetown */
-(IBAction)spawnMountPleasantPopup:(id)sender;
-(IBAction)spawnMaltonPopup:(id)sender;
-(IBAction)spawnGeorgetownPopup:(id)sender;
-(IBAction)spawnBramptonPopup:(id)sender;
-(IBAction)spawnBramaleaPopup:(id)sender;
-(IBAction)spawnEtobicokeNorthPopup:(id)sender;
-(IBAction)spawnWestonPopup:(id)sender;
-(IBAction)spawnBloorPopup:(id)sender;
/* Barrie */
-(IBAction)spawnBarriePopup:(id)sender;
-(IBAction)spawnAuroraPopup:(id)sender;
-(IBAction)spawnBradfordPopup:(id)sender;
-(IBAction)spawnYorkUniversityPopup:(id)sender;
-(IBAction)spawnRutherfordPopup:(id)sender;
-(IBAction)spawnMaplePopup:(id)sender;
-(IBAction)spawnKingCityPopup:(id)sender;
-(IBAction)spawnNewmarketPopup:(id)sender;
-(IBAction)spawnEastGwillimburyPopup:(id)sender;
/* Richmond Hill */
-(IBAction)spawnRichmondHillPopup:(id)sender;
-(IBAction)spawnLangstaffPopup:(id)sender;
-(IBAction)spawnOldCummerPopup:(id)sender;
-(IBAction)spawnOriolePopup:(id)sender;
/* Stouffville */
-(IBAction)spawnKennedyPopup:(id)sender;
-(IBAction)spawnAgincourtPopup:(id)sender;
-(IBAction)spawnMillikenPopup:(id)sender;
-(IBAction)spawnUnionvillePopup:(id)sender;
-(IBAction)spawnCentennialPopup:(id)sender;
-(IBAction)spawnMarkhamPopup:(id)sender;
-(IBAction)spawnMountJoyPopup:(id)sender;
-(IBAction)spawnStouffvillePopup:(id)sender;
-(IBAction)spawnLincolnvillePopup:(id)sender;
/* Lakeshore East */
-(IBAction)spawnDanforthPopup:(id)sender;
-(IBAction)spawnScarboroughPopup:(id)sender;
-(IBAction)spawnEglintonPopup:(id)sender;
-(IBAction)spawnGuildwoodPopup:(id)sender;
-(IBAction)spawnRougeHillPopup:(id)sender;
-(IBAction)spawnPickeringPopup:(id)sender;
-(IBAction)spawnAjaxPopup:(id)sender;
-(IBAction)spawnWhitbyPopup:(id)sender;
-(IBAction)spawnOshawaPopup:(id)sender;
/* Custom Methods */
-(void)spawnStationPopup:(NSString*)stationName;
-(void)cascadeEnableLines;
@end