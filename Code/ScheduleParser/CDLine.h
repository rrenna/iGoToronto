//
//  CDLine.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-12-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDEntity.h"

@class CDDayType;
@class CDDirection;
@class CDRoute;
@class CDStation;

@interface CDLine :  CDEntity  
{
}

@property (nonatomic, retain) NSNumber * PrimaryColourG;
@property (nonatomic, retain) NSNumber * PrimaryColourB;
@property (nonatomic, retain) NSNumber * PrimaryColourR;
@property (nonatomic, retain) id PrimaryColour;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Routes;
@property (nonatomic, retain) NSSet* Directions;
@property (nonatomic, retain) NSSet* DayTypes;
@property (nonatomic, retain) NSSet* Stations;

@end


@interface CDLine (CoreDataGeneratedAccessors)
- (void)addRoutesObject:(CDRoute *)value;
- (void)removeRoutesObject:(CDRoute *)value;
- (void)addRoutes:(NSSet *)value;
- (void)removeRoutes:(NSSet *)value;

- (void)addDirectionsObject:(CDDirection *)value;
- (void)removeDirectionsObject:(CDDirection *)value;
- (void)addDirections:(NSSet *)value;
- (void)removeDirections:(NSSet *)value;

- (void)addDayTypesObject:(CDDayType *)value;
- (void)removeDayTypesObject:(CDDayType *)value;
- (void)addDayTypes:(NSSet *)value;
- (void)removeDayTypes:(NSSet *)value;

- (void)addStationsObject:(CDStation *)value;
- (void)removeStationsObject:(CDStation *)value;
- (void)addStations:(NSSet *)value;
- (void)removeStations:(NSSet *)value;

@end

