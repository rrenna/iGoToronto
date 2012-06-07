//
//  CDLocation.h
//  ScheduleParser
//
//  Created by Ryan Renna on 11-01-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDEntity.h"


@interface CDLocation :  CDEntity  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSString * Address;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSNumber * Distance;

@end



