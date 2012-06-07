//
//  CDRoadway.h
//  ScheduleParser
//
//  Created by Ryan Renna on 11-01-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CDCamera;

@interface CDRoadway :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * BaseUrl;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Cameras;

@end

@interface CDRoadway (CoreDataGeneratedAccessors)
- (void)addCamerasObject:(CDCamera *)value;
- (void)removeCamerasObject:(CDCamera *)value;
- (void)addCameras:(NSSet *)value;
- (void)removeCameras:(NSSet *)value;

@end

