//
//  CDRoute.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDEntity.h"

@class CDDirection;
@class CDLine;
@class CDStop;

@interface CDRoute :  CDEntity  
{
}

@property (nonatomic, retain) NSSet* Stops;
@property (nonatomic, retain) CDLine * Line;
@property (nonatomic, retain) CDDirection * Direction;

@end


@interface CDRoute (CoreDataGeneratedAccessors)
- (void)addStopsObject:(CDStop *)value;
- (void)removeStopsObject:(CDStop *)value;
- (void)addStops:(NSSet *)value;
- (void)removeStops:(NSSet *)value;

@end

