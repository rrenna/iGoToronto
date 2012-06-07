//
//  Flight.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-24.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Flight : NSObject 
{
    NSString* FlightName;
    NSString* Departed;
    NSString* Airline;
    NSString* Status;
    NSString* Terminal;
    NSDate* DepartureTime;
    NSDate* ScheduledTime;
    NSDate* RevisedTime;
}
@property (retain) NSString* FlightName;
@property (retain) NSString* Departed;
@property (retain) NSString* Airline;
@property (retain) NSString* Status;
@property (retain) NSString* Terminal;
@property (retain) NSDate* DepartureTime;
@property (retain) NSDate* ScheduledTime;
@property (retain) NSDate*RevisedTime;
@end
