//
//  LocationCenter.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-31.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "LocationCenter.h"

static LocationCenter * _sharedCenter;

@implementation LocationCenter
@synthesize locationManager;
@synthesize currentLocation;

/* Singleton Pattern methods */
+(id)sharedCenter
{	
	@synchronized(self) 
	{
		if(!_sharedCenter) 
		{
			_sharedCenter = [[self alloc] init];
		}
	}
	return _sharedCenter;	
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) 
	{
		if (_sharedCenter == nil) 
		{
			_sharedCenter = [super allocWithZone:zone];
			return _sharedCenter;
		}
	}
	return nil;
}
-(id)init
{
	self = [super init];
	if(self)
	{
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
	return self;
}
-(void)updateLocation
{
	[self performSelectorInBackground:@selector(asyncUpdateLocation) withObject:nil];
}
-(void)asyncUpdateLocation
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	self.currentLocation = nil;
	[self.locationManager startUpdatingLocation];
	self.currentLocation = [self.locationManager location];

	int count = 0;
    //If a current location was retrieved, set the age property, otherwise it's -1
    NSTimeInterval age = (self.currentLocation) ? [self.currentLocation.timestamp timeIntervalSinceNow] : -1;
    
    //Conditions
    BOOL noCurrentLocation = (self.currentLocation == Nil);
    BOOL hasPoorAccuracy = ([self.currentLocation verticalAccuracy] > 500.0 && [currentLocation horizontalAccuracy] > 500.0);
    BOOL hasAgedContent = (age < -120);
    
    //If the current location was returned as nil, both h and v not within 500 meter accuracy,
    // or the last location is more than 2 minutes old, wait
    while(noCurrentLocation || hasPoorAccuracy || hasAgedContent)
	{
		//Prevent an endless loop
		if(count > 10) 
		{ 
			break; 
		}
            
		[NSThread sleepForTimeInterval:1];
		count++;
		//If the gps has not returned a location or it's location is not accurate, fetch another location
		self.currentLocation = [self.locationManager location];
       age = [self.currentLocation.timestamp timeIntervalSinceNow];
        
        
        noCurrentLocation = (self.currentLocation == Nil);
        hasPoorAccuracy = ([self.currentLocation verticalAccuracy] > 500.0 && [currentLocation horizontalAccuracy] > 500.0);
        hasAgedContent = (age < -120);
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_CHANGED object:nil];
	[self.locationManager stopUpdatingLocation];
	[pool drain];
}
@end
