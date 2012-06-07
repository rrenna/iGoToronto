//
//  HelperModelClasses.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-10-16.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelStation : NSObject 
{
    NSString* name;
    BOOL isDescriptor;
    NSString* url;
    NSMutableArray* factoids;
	NSString* address;
    double latitude;
    double longitude;
}
@property (retain) NSString* name;
@property (retain) NSString* address;
@property (assign) BOOL isDescriptor;
@property (retain) NSString* url;
@property (retain) NSMutableArray* factoids;
@property (assign) double latitude;
@property (assign) double longitude;
@end

@interface ModelRouteTypePage : NSObject {
    NSString* urlFormat;
    NSString* dayType;
    NSString* direction;
    int pages;
	int tableHeaderRowsToOffset;

}
@property (retain) NSString* urlFormat;
@property (retain) NSString* dayType;
@property (retain) NSString* direction;
@property (assign) int pages;
@property (assign) int tableHeaderRowsToOffset;
@end

@interface  ModelLine  : NSObject 
{
    NSString* name;
	int r,g,b;
	NSMutableArray* dayTypes;
	NSMutableArray* directions;
  	NSMutableArray* stations;
    NSMutableArray* routeTypePages;
}
@property (retain) NSString* name;
@property (assign) int r;
@property (assign) int g;
@property (assign) int b;
@property (retain) NSMutableArray* dayTypes;
@property (retain) NSMutableArray* directions;
@property (retain) NSMutableArray* stations;
@property (retain) NSMutableArray* routeTypePages;
@end

@interface ModelStop : NSObject
{
    int stationNumber;
    NSString* time;
    NSString* type;
	BOOL isFinal;
}
@property (assign) int stationNumber;
@property (retain) NSString* time;
@property (retain) NSString* type;
@property (assign) BOOL isFinal;
@end

@interface ModelRoute : NSObject {
    NSMutableArray* stops;
    NSString* direction;
    NSString* line;
}
@property (retain) NSMutableArray* stops;
@property (retain) NSString* direction;
@property (retain) NSString* line;
@end