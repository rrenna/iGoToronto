    //
//  SubwayStationPopupViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-23.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "SubwayStationPopupViewController.h"

@implementation SubwayStationPopupViewController
@synthesize lblStationDescription;
@synthesize lblAddress;
@synthesize station;

-(id)initWithStationName:(NSString*)name
{
	NSMutableString *stationStopListingControllerNibName = [NSMutableString stringWithString:@"SubwayStationPopupView"];
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
		[stationStopListingControllerNibName appendString:@"-iPad"];
	}
	if ((self = [super initWithNibName:stationStopListingControllerNibName bundle:nil])) 
	{
        iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = delegate.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDSubwayStation" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"Name = %@",name]];
        [fetchRequest setEntity:entity];
		
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if([fetchedObjects count] > 0)
        {
            
            self.station = [fetchedObjects objectAtIndex:0];
        }
		
		[fetchRequest release];
    }
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	lblAddress.text = station.Address;
	//Sets and sizes the description label
	self.lblStationDescription.text = station.Description;
	[self.lblStationDescription sizeToFit];
	
	CGPoint descriptionLabelCenter;
	descriptionLabelCenter.x = self.view.center.x;
	descriptionLabelCenter.y = lblStationDescription.center.y;
	lblStationDescription.center = descriptionLabelCenter;
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.lblStationDescription = nil;
    self.lblAddress = nil;
}
- (void)dealloc 
{
	[lblStationDescription release];
	[lblAddress release];
	[station release];
    [super dealloc];
}
/* IBActions */
- (IBAction)viewMap:(id)sender
{
	NSString* latLong = [NSString stringWithFormat:@"%f,%f",[station.Latitude doubleValue],[self.station.Longitude doubleValue]];
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",latLong];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:apiUrlStr]];
}
@end
