//
//  GoHelper.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-16.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "GOCenter.h"
#import "CDLine.h"

static GOCenter * _sharedCenter;

@implementation DayTypeDescriptor
@synthesize name;
@synthesize description;
@synthesize dayOfMonthLastCalculated;
-(id)init
{
    self = [super init];
    if(self)
    {
        self.name = nil;
        self.description = nil;
        self.dayOfMonthLastCalculated = -1;
    }
    return self;
}
-(void)dealloc
{
    //dayOfMonthLastCalculated - do not release
    [name release];
    [description release];
    [super dealloc];
}
@end

@implementation GOCenter
// Singleton Pattern methods
+(id)sharedCenter
{	
	@synchronized(self) 
	{
		if(!_sharedCenter) 
		{
			_sharedCenter = [[self alloc] init];
		}
	}
	return _sharedCenter;	
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
    {
        if (_sharedCenter == nil) 
        {
            _sharedCenter = [super allocWithZone:zone];
            return _sharedCenter;
        }
    }
    return nil;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        dayTypeCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [dayTypeCache release];
	[super dealloc];
}
// Custom Methods
-(NSDate*)goComparableDateFromDate:(NSDate*)date
{
	//Converts the current date to a date comparable to the times in the database
	// which are all set to January 1st 2000. 
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[NSDate date]];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
	
    int hour = [timeComponents hour];
    int minute = [timeComponents minute];
	[dateComponents setMonth:1];
	[dateComponents setYear:2000];
    
    if(hour >= 0 && hour <= 2)
    {
        [dateComponents setDay:2];
    }
    else
    {
        [dateComponents setDay:1];
    }
	[dateComponents setHour:hour];
	[dateComponents setMinute:minute];
	[dateComponents setSecond:[timeComponents second]];
	
	[self willChangeValueForKey:@"start"];
	return [calendar dateFromComponents:dateComponents];
}
-(DayTypeDescriptor*)getDayTimeDescriptorsForLine : (CDLine*) line
{
    //Retrieve date components
    NSDate* date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate: date];
    int dayOfMonth = [components day];

    //Look up the descriptor in the cache
    DayTypeDescriptor* descriptor = [dayTypeCache objectForKey:line.Name];
    //If we've stored a daytype descriptor for this line, check the date it was calculated on
    if(descriptor)
    {
        //If this descriptor for this line was calculated today, return it
        if(dayOfMonth == descriptor.dayOfMonthLastCalculated)
            return descriptor;
    }
    else
    {
        descriptor = [[[DayTypeDescriptor alloc] init] autorelease];
        [dayTypeCache setObject:descriptor forKey:line.Name];
    }
    //set the date of the month - to avoid repeat calculations
    descriptor.dayOfMonthLastCalculated = dayOfMonth;
    
    //If the day of the week is monday, tuesday, wednesday, thursday or friday
	if([components weekday] >= 2 && [components weekday] <= 6)
	{
		descriptor.name = GODayType_MondayToFriday;
		//Special case for Georgetown line, which has a monday to thursday & friday schedule
		//Note : Special case removed, Georgetown is now on a monday to Friday schedule 
        // - June 22nd 2011 
        /*if([[line Name] isEqualToString:@"Georgetown"])
        {
            if([components weekday] == 6)
            {
                descriptor.name = GODayType_Friday;
            }
            else 
            {
                descriptor.name = GODayType_MondayToThursday;
            }
        }*/
	}
	else if([components weekday] == 1)
	{
		descriptor.name = GODayType_Sunday;
	}
	else if([components weekday] == 7)
	{
		descriptor.name = GODayType_Saturday;
	}
	
	NSString* specialDayLabelOverride = nil;
	//Overrides for specific days
	if([components month] == 1)
	{
		//New Years Day
		if([components day] == 1)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"New Year's Day schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
	else if([components month] == 2)
	{
		//Family Day
		if([components day] == 21)
		{
			descriptor.name = GODayType_Saturday;
			descriptor.description = [NSString stringWithFormat:@"Family Day schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 4)
	{
		//Good Friday
		if([components day] == 22)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"Good Friday schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 5)
	{
		//Victoria Day
		if([components day] == 23)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"Victoria Day schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 7)
	{
		//Canada Day
		if([components day] == 1)
		{
			descriptor.name = GODayType_Saturday;
			descriptor.description = [NSString stringWithFormat:@"Canada Day schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 8)
	{
		//Civic Holiday Day
		if([components day] == 1)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"Civic Holiday schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 9)
	{
		//Labour Day
		if([components day] == 5)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"Labour Day schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    else if([components month] == 10)
	{
		//Labour Day
		if([components day] == 10)
		{
			descriptor.name = GODayType_Holiday;
			descriptor.description = [NSString stringWithFormat:@"Thanksgiving schedule, after %@",[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
		}
	}
    //Default description
    if(!descriptor.description)
	{
        NSDateFormatter *weekday = [[[NSDateFormatter alloc] init] autorelease];
        [weekday setDateFormat: @"EEEE"];
               
        NSString * weekdayString = [weekday stringFromDate:date];
        descriptor.description = [NSString stringWithFormat:@"%@ schedule, after %@",weekdayString,[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:date]];
	}
	
    return descriptor;
}
@end
