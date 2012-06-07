//
//  CDStop.h
//  ScheduleParser
//
//  Created by Ryan Renna on 10-11-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDEntity.h"

@class CDRoute;
@class CDStation;

@interface CDStop :  CDEntity  
{
}

@property (nonatomic, retain) NSString * DayType;
@property (nonatomic, retain) NSNumber * isTrain;
@property (nonatomic, retain) NSDate * Time;
@property (nonatomic, retain) NSNumber * finalStop;
@property (nonatomic, retain) CDStation * Station;
@property (nonatomic, retain) CDRoute * Route;

@end



