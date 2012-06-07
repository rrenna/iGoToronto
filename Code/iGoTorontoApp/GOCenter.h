//
//  GoHelper.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-16.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class CDLine;
@class CDDayType;

@interface DayTypeDescriptor : NSObject 
{
}
@property (retain) NSString* name;
@property (retain) NSString* description;
@property (assign) int dayOfMonthLastCalculated;
@end

@interface GOCenter : Singleton 
{
    NSMutableDictionary* dayTypeCache;
}

+(id)sharedCenter;
//
-(NSDate*)goComparableDateFromDate:(NSDate*)date;
-(DayTypeDescriptor*)getDayTimeDescriptorsForLine : (CDLine*) line;
@end
