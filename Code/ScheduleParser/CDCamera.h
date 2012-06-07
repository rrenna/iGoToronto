//
//  CDCamera.h
//  ScheduleParser
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDLocation.h"

@class CDRoadway;

@interface CDCamera :  CDLocation  
{
}

@property (nonatomic, retain) NSString * RelativeUrl;
@property (nonatomic, retain) CDRoadway * Roadway;

@end



