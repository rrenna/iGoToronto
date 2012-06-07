//
//  HelperModelClasses.m
//  ScheduleParser
//
//  Created by Ryan Renna on 10-10-16.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "HelperModelClasses.h"


@implementation ModelStation
@synthesize name;
@synthesize address;
@synthesize url;
@synthesize factoids;  
@synthesize isDescriptor;
@synthesize latitude;
@synthesize longitude;

-(id)init 
{
    if (self = [super init])
    {
        self.factoids = [NSMutableArray new];
        self.isDescriptor = NO;
        self.latitude = 0;
        self.longitude = 0;
    }
    return self;
}

-(void)dealloc
{
	[address release];
    [factoids release];
    [super dealloc];
}
@end
 
@implementation ModelRouteTypePage
@synthesize urlFormat;
@synthesize dayType;
@synthesize direction;
@synthesize pages;
@synthesize tableHeaderRowsToOffset;
-(id)init 
{
    if (self = [super init])
    {
        self.pages = 1;
		self.tableHeaderRowsToOffset = 2;
    }
    return self;
}

-(void)dealloc
{
    [urlFormat release];
    [dayType release];
    [direction release];
    [super dealloc];
}
@end

@implementation ModelLine
    @synthesize name;
	@synthesize r;
	@synthesize g;
	@synthesize b;
	@synthesize dayTypes;
	@synthesize directions;
	@synthesize stations;
    @synthesize routeTypePages;

-(id)init
{
	if((self = [super init]))
	{
		r = 0;
		g = 0;
		b = 0;
		dayTypes = [NSMutableArray new];
		stations = [NSMutableArray new];
		directions = [NSMutableArray new];
        routeTypePages = [NSMutableArray new];
	}
	return self;
}
@end


@implementation ModelStop
    @synthesize stationNumber;
    @synthesize time;
    @synthesize type;
	@synthesize isFinal;

-(id)init
{
	if((self = [super init]))
	{
		isFinal = NO;
	}
	return self;
}
@end

@implementation ModelRoute
@synthesize stops;
@synthesize direction;
@synthesize line;

-(id)init
{
    if ((self = [super init]))
    {
        stops = [NSMutableArray new];
    }
    return self;
}
@end