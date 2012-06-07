//
//  CDStation.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-07-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CDLocation.h"
@class CDLine;
@class CDStop;

@interface CDStation :  CDLocation  
{
}

@property (nonatomic, retain) NSNumber * isDescriptor;
@property (nonatomic, retain) NSSet* Lines;
@property (nonatomic, retain) NSSet* Stops;

- (void)addLinesObject:(CDLine *)value;
- (void)removeLinesObject:(CDLine *)value;
- (void)addLines:(NSSet *)value;
- (void)removeLines:(NSSet *)value;

- (void)addStopsObject:(CDStop *)value;
- (void)removeStopsObject:(CDStop *)value;
- (void)addStops:(NSSet *)value;
- (void)removeStops:(NSSet *)value;

@end
