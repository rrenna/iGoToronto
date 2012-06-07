//
//  CDFactoid.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-11-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CDFactoid :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Body;
@property (nonatomic, retain) NSManagedObject * Entity;

@end



