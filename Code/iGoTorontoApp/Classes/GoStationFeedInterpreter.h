//
//  GoStationFeedInterpreter.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-04-02.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedInterpreter.h"

@class CDStation;

@interface GoStationFeedInterpreter : FeedInterpreter 
{
}
@property (retain) CDStation* station;

@end
