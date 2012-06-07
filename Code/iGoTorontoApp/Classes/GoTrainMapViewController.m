    //
//  GoTrainMapViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-11.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "GoTrainMapViewController.h"

/* GOLine Class*/
@implementation GoLineController
@synthesize lineImage;
-(void)enable
{
    [self.view setEnabled:YES];
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.lineImage = nil;
}
- (void)dealloc 
{
    [lineImage release];
    [super dealloc];
}
@end

@implementation GoTrainMapViewController
@synthesize infoPopupViewController;
@synthesize LakeshoreWestLineController;
@synthesize LakeshoreEastLineController;
@synthesize RichmondHillLineController;
@synthesize StouffvilleLineController;
@synthesize MiltonLineController;
@synthesize BarrieLineController;
@synthesize GeorgetownLineController;

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[infoPopupViewController release];
	[LakeshoreWestLineController release];
	[LakeshoreEastLineController release];
	[RichmondHillLineController release];
	[StouffvilleLineController release];
	[MiltonLineController release];
	[BarrieLineController release];
	[GeorgetownLineController release];
    [super dealloc];
}

/* Union */
-(IBAction)spawnUnionPopup:(id)sender
{
    [self spawnStationPopup:@"Union Station"];
}
/* Lakeshore West */
-(IBAction)spawnExibitionPopup:(id)sender
{
    [self spawnStationPopup:@"Exhibition GO Station"];
}
-(IBAction)spawnMimicoPopup:(id)sender
{
    [self spawnStationPopup:@"Mimico GO Station"];
}
-(IBAction)spawnLongBranchPopup:(id)sender
{
    [self spawnStationPopup:@"Long Branch GO Station"];
}
-(IBAction)spawnPortCreditPopup:(id)sender
{
    [self spawnStationPopup:@"Port Credit GO Station"];
}
-(IBAction)spawnClarksonPopup:(id)sender
{
    [self spawnStationPopup:@"Clarkson GO Station"];
}
-(IBAction)spawnOakvillePopup:(id)sender
{
    [self spawnStationPopup:@"Oakville GO Station"];
}
-(IBAction)spawnBrontePopup:(id)sender
{
    [self spawnStationPopup:@"Bronte GO Station"];
}
-(IBAction)spawnApplebyPopup:(id)sender
{
    [self spawnStationPopup:@"Appleby GO Station"];
}
-(IBAction)spawnBurlingtonPopup:(id)sender
{
    [self spawnStationPopup:@"Burlington GO Station"];
}
-(IBAction)spawnAldershotPopup:(id)sender
{
    [self spawnStationPopup:@"Aldershot GO Station"];
}
-(IBAction)spawnHamiltonPopup:(id)sender
{
    [self spawnStationPopup:@"Hamilton GO Centre"];
}
/* Milton */
-(IBAction)spawnKiplingPopup:(id)sender
{
    [self spawnStationPopup:@"Kipling GO Station"];
}
-(IBAction)spawnDixiePopup:(id)sender
{
    [self spawnStationPopup:@"Dixie GO Station"];
}
-(IBAction)spawnCooksvillePopup:(id)sender
{
    [self spawnStationPopup:@"Cooksville GO Station"];
}
-(IBAction)spawnErindalePopup:(id)sender
{
    [self spawnStationPopup:@"Erindale GO Station"];
}
-(IBAction)spawnStreetsvillePopup:(id)sender
{
    [self spawnStationPopup:@"Streetsville GO Station"];
}
-(IBAction)spawnMeadowvalePopup:(id)sender
{
    [self spawnStationPopup:@"Meadowvale GO Station"];
}
-(IBAction)spawnLisgarPopup:(id)sender
{
    [self spawnStationPopup:@"Lisgar GO Station"];
}
-(IBAction)spawnMiltonPopup:(id)sender
{
    [self spawnStationPopup:@"Milton GO Station"];
}
/* Georgetown */
-(IBAction)spawnMountPleasantPopup:(id)sender
{
    [self spawnStationPopup:@"Mount Pleasant GO Station"];
}
-(IBAction)spawnMaltonPopup:(id)sender
{
    [self spawnStationPopup:@"Malton GO Station"];
}
-(IBAction)spawnGeorgetownPopup:(id)sender
{
    [self spawnStationPopup:@"Georgetown GO Station"];
}
-(IBAction)spawnBramptonPopup:(id)sender
{
    [self spawnStationPopup:@"Brampton GO Station"];
}
-(IBAction)spawnBramaleaPopup:(id)sender
{
    [self spawnStationPopup:@"Bramalea GO Station"];
}
-(IBAction)spawnEtobicokeNorthPopup:(id)sender
{
    [self spawnStationPopup:@"Etobicoke North GO stn"];
}
-(IBAction)spawnWestonPopup:(id)sender
{
    [self spawnStationPopup:@"Weston GO Station"];
}
-(IBAction)spawnBloorPopup:(id)sender
{
    [self spawnStationPopup:@"Bloor GO Station"];
}
/* Barrie */
-(IBAction)spawnBarriePopup:(id)sender
{
    [self spawnStationPopup:@"Barrie South GO Station"];
}
-(IBAction)spawnAuroraPopup:(id)sender
{
    [self spawnStationPopup:@"Aurora GO Station"];
}
-(IBAction)spawnBradfordPopup:(id)sender
{
    [self spawnStationPopup:@"Bradford GO Station"];
}
-(IBAction)spawnYorkUniversityPopup:(id)sender
{
    [self spawnStationPopup:@"York University GO Stn"];
}
-(IBAction)spawnRutherfordPopup:(id)sender
{
    [self spawnStationPopup:@"Rutherford GO Station"];
}
-(IBAction)spawnMaplePopup:(id)sender
{
    [self spawnStationPopup:@"Maple GO Station"];
}
-(IBAction)spawnKingCityPopup:(id)sender
{
    [self spawnStationPopup:@"King City GO Station"];
}
-(IBAction)spawnNewmarketPopup:(id)sender
{
    [self spawnStationPopup:@"Newmarket GO Station"];
}
-(IBAction)spawnEastGwillimburyPopup:(id)sender
{
    [self spawnStationPopup:@"East Gwillimbury GO Stn"];
}
/* Richmond Hill */
-(IBAction)spawnRichmondHillPopup:(id)sender
{
    [self spawnStationPopup:@"Richmond Hill GO Station"];
}
-(IBAction)spawnLangstaffPopup:(id)sender
{
    [self spawnStationPopup:@"Langstaff GO Station"];
}
-(IBAction)spawnOldCummerPopup:(id)sender
{
    [self spawnStationPopup:@"Old Cummer GO Station"];
}
-(IBAction)spawnOriolePopup:(id)sender
{
    [self spawnStationPopup:@"Oriole GO Station"];
}
/* Stouffville */

-(IBAction)spawnKennedyPopup:(id)sender
{
    [self spawnStationPopup:@"Kennedy GO Station"];
}
-(IBAction)spawnAgincourtPopup:(id)sender
{
    [self spawnStationPopup:@"Agincourt GO Station"];
}
-(IBAction)spawnMillikenPopup:(id)sender
{
    [self spawnStationPopup:@"Milliken GO Station"];
}
-(IBAction)spawnUnionvillePopup:(id)sender
{
    [self spawnStationPopup:@"Unionville GO Station"];
}
-(IBAction)spawnCentennialPopup:(id)sender
{
    [self spawnStationPopup:@"Centennial GO Station"];
}
-(IBAction)spawnMarkhamPopup:(id)sender
{
    [self spawnStationPopup:@"Markham GO Station"];
}
-(IBAction)spawnMountJoyPopup:(id)sender
{
    [self spawnStationPopup:@"Mount Joy GO Station"];
}-(IBAction)spawnStouffvillePopup:(id)sender
{
    [self spawnStationPopup:@"Stouffville GO Station"];
}
-(IBAction)spawnLincolnvillePopup:(id)sender
{
    [self spawnStationPopup:@"Lincolnville GO Station"];
}
/* Lakeshore East */
-(IBAction)spawnDanforthPopup:(id)sender
{
    [self spawnStationPopup:@"Danforth GO Station"];
}
-(IBAction)spawnScarboroughPopup:(id)sender
{
    [self spawnStationPopup:@"Scarborough GO Station"];
}
-(IBAction)spawnEglintonPopup:(id)sender
{
    [self spawnStationPopup:@"Eglinton GO Station"];
}
-(IBAction)spawnGuildwoodPopup:(id)sender
{
    [self spawnStationPopup:@"Guildwood GO Station"];
}
-(IBAction)spawnRougeHillPopup:(id)sender
{
    [self spawnStationPopup:@"Rouge Hill GO Station"];
}
-(IBAction)spawnPickeringPopup:(id)sender
{
    [self spawnStationPopup:@"Pickering GO Station"];
}
-(IBAction)spawnAjaxPopup:(id)sender
{
    [self spawnStationPopup:@"Ajax GO Station"];
}
-(IBAction)spawnWhitbyPopup:(id)sender
{
    [self spawnStationPopup:@"Whitby GO Station"];
}
-(IBAction)spawnOshawaPopup:(id)sender
{
    [self spawnStationPopup:@"Oshawa GO Station"];
}
/* Custom Methods */
-(void)spawnStationPopup:(NSString*)stationName
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_STATION_VIEW object:stationName];
}
-(void)cascadeEnableLines
{
    //Queue a cascade, enabling each line.
    [LakeshoreWestLineController performSelector:@selector(enable) withObject:nil afterDelay:1.0];
    [MiltonLineController performSelector:@selector(enable) withObject:nil afterDelay:1.1];
    [GeorgetownLineController performSelector:@selector(enable) withObject:nil afterDelay:1.25];
    [BarrieLineController performSelector:@selector(enable) withObject:nil afterDelay:1.4];
    [RichmondHillLineController performSelector:@selector(enable) withObject:nil afterDelay:1.55];
    [StouffvilleLineController performSelector:@selector(enable) withObject:nil afterDelay:1.7];
    [LakeshoreEastLineController performSelector:@selector(enable) withObject:nil afterDelay:1.85];
}
@end
