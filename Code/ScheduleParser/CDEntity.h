//
//  CDEntity.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-11-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDFactoid;

@interface CDEntity :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* Factoids;

@end


@interface CDEntity (CoreDataGeneratedAccessors)
- (void)addFactoidsObject:(CDFactoid *)value;
- (void)removeFactoidsObject:(CDFactoid *)value;
- (void)addFactoids:(NSSet *)value;
- (void)removeFactoids:(NSSet *)value;

@end

