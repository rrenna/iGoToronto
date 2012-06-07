//
//  LocationCenter.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-31.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Singleton.h"

@interface LocationCenter : Singleton {

}
@property (retain) CLLocationManager* locationManager;
@property (retain) CLLocation* currentLocation;

+(id)sharedCenter;

-(void)updateLocation;
@end
