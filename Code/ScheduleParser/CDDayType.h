//
//  CDDayType.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDLine;

@interface CDDayType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * ShortenedName;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * Order;
@property (nonatomic, retain) NSSet* Lines;

@end


@interface CDDayType (CoreDataGeneratedAccessors)
- (void)addLinesObject:(CDLine *)value;
- (void)removeLinesObject:(CDLine *)value;
- (void)addLines:(NSSet *)value;
- (void)removeLines:(NSSet *)value;

@end

