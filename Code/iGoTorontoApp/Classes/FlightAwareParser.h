//
//  FlightAwareParser.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-03.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"
#import "Flight.h"

@interface FlightAwareParser : NSObject {

}

-(NSMutableArray*)getFlightsWithFlightType:(NSString*)flightType forAirportCode:(NSString*)airportCode OrderBy:(NSString*)orderBy SortBy:(NSString*)sortBy OnPage:(int)page;
@end
