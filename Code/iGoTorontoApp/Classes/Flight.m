//
//  Flight.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-24.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Flight.h"

@implementation Flight
@synthesize FlightName;
@synthesize Departed;
@synthesize Airline;
@synthesize Status;
@synthesize Terminal;
@synthesize DepartureTime;
@synthesize ScheduledTime;
@synthesize RevisedTime;

-(void)dealloc 
{
    [FlightName release];
    [Departed release];
    [Airline release];
    [Status release];
    [Terminal release];
    [DepartureTime release];
    [ScheduledTime release];
    [RevisedTime release];
    [super dealloc];
}
@end
