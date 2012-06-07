//
//  CDDirection.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDLine;
@class CDRoute;

@interface CDDirection :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Lines;
@property (nonatomic, retain) NSSet* Routes;

@end


@interface CDDirection (CoreDataGeneratedAccessors)
- (void)addLinesObject:(CDLine *)value;
- (void)removeLinesObject:(CDLine *)value;
- (void)addLines:(NSSet *)value;
- (void)removeLines:(NSSet *)value;

- (void)addRoutesObject:(CDRoute *)value;
- (void)removeRoutesObject:(CDRoute *)value;
- (void)addRoutes:(NSSet *)value;
- (void)removeRoutes:(NSSet *)value;

@end

