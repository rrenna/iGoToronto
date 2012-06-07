//
//  Feed.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeedInterpreter;

#define FEED_SOURCE_TWITTER 0
#define FEED_SOURCE_WEB 1
#define OBJECT_CAMERA 2
#define OBJECT_GO_STATION 3

@interface Feed : NSObject 
{
    BOOL Dirty;
    BOOL Enabled;
	int Source;
    NSDate* LastUpdated;
    NSString* Name;
    NSString* Url;
    NSMutableArray* latestUpdates;
	FeedInterpreter* interpreter;
}
@property (assign) BOOL Dirty;
@property (assign) BOOL Enabled;
@property (assign) int Source;
@property (retain) NSDate* LastUpdated;
@property (retain) NSString* Name;
@property (retain) NSString* Url;
@property (retain) NSMutableArray* latestUpdates;
@property (retain) FeedInterpreter* interpreter;

- (id)initWithName:(NSString*)name Url:(NSString*)url andSource:(int)source;
- (id)initWithName:(NSString*)name Url:(NSString*)url Interpreter:(FeedInterpreter*)feedInterpreter andSource:(int)source;
@end

