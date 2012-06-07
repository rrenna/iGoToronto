//
//  FlightAwareParser.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-03.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


#import "FlightAwareParser.h"

static NSString* urlFormat = @"http://flightaware.com/live/airport/C%@/%@;offset=%i;order=%@;sort=%@;";

@implementation FlightAwareParser
-(NSMutableArray*)getFlightsWithFlightType:(NSString*)flightType forAirportCode:(NSString*)airportCode OrderBy:(NSString*)orderBy SortBy:(NSString *)sortBy OnPage:(int)page
{  
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    NSString* urlString = [NSString stringWithFormat:urlFormat,airportCode,flightType,((page - 1) * 20),orderBy,sortBy];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request startSynchronous];
	
	NSString* response = [request responseString];
	response = [response stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    NSMutableArray* flights;
    
    if(response)
    {
        flights = [NSMutableArray new];
        HTMLParser* parser = [[HTMLParser alloc] initWithString:response error:nil];
        HTMLNode* bodyNode = [parser body];
        HTMLNode* container = [bodyNode findChildOfClass:@"container"];
        NSArray* tables = [container findChildTags:@"table"];
        HTMLNode* tb2 = [tables objectAtIndex:1];
        HTMLNode* tr2 = [tb2 firstChild];
        HTMLNode* td2 = [tr2 firstChild];
        HTMLNode* table = [td2 findChildTag:@"table"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE hh:mmaaa"];
        
        int rowCounter = 0;
        for(HTMLNode* flightRow in [table findChildTags:@"tr"])
        {
            rowCounter++;
            if(rowCounter >= 2)
            {
                int columnCounter = 0;
                Flight* flight = [Flight new];
                
                for(HTMLNode* flightColumn in [flightRow findChildTags:@"td"])
                {
                    columnCounter++;
                    if(columnCounter == 1)
                    {
                        //Airline
                        HTMLNode* span = [[flightColumn children] objectAtIndex:1];
                        //NSLog(@"Airline #: %@",[span getAttributeNamed:@"title"]);
                        flight.Airline = [span getAttributeNamed:@"title"];
                        
                        //Print out airline hyperlink
                        //NSLog(@"Flight #: %@",[[span firstChild] contents]);
                        
						flight.FlightName = [[span firstChild] contents];
						//flight.Flight = [[span firstChild] contents];
                        
                    }
                    else if(columnCounter == 2)
                    {
                        //HTMLNode* span = [[flightColumn children] objectAtIndex:0];
                        //NSLog(@"Plane #: %@",[span getAttributeNamed:@"title"]);
                        //TOOD ADD PLANE TYPE
                    }
                    else if(columnCounter == 3)
                    {
                        //NSLog(@"DEPARTURE #: %@",[[flightColumn firstChild] contents]);
                        flight.Departed = [[flightColumn firstChild] contents];
                    }
                    else if(columnCounter == 4)
                    {
                        int dateLength = [[flightColumn contents] length];
                        NSString* departure = [[flightColumn contents] substringToIndex:dateLength - 3];
                        NSDate* departureDate = [df dateFromString:departure];
                        flight.DepartureTime = departureDate;

                    }
                    else if(columnCounter == 5)
                    {
                        int dateLength = [[flightColumn contents] length];
                        NSString* arrival = [[flightColumn contents] substringToIndex:dateLength - 3];
                        NSDate* arrivalDate = [df dateFromString:arrival];
                        flight.RevisedTime = arrivalDate;
                    }
                }
                [flights addObject:flight];
                [flight release];
            }
        }
        [df release];
        //Incase the dealloc method is called next, release will be called
        // on an already deallocated object
        response = nil;
        [pool drain];
    }
    return [flights autorelease];
}

@end

