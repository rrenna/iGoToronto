//
//  CDRoute+Extension.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDRoute.h"

@interface CDRoute (CDRoute_Extension)

-(NSArray*)sortedStops;
-(NSArray*)sortedStopsAfterTime:(NSDate*)time;

@end
