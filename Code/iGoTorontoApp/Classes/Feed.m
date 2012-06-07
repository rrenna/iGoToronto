//
//  Feed.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "Feed.h"
#import "FeedInterpreter.h"

@implementation Feed

@synthesize Dirty;
@synthesize Enabled;
@synthesize Source;
@synthesize LastUpdated;
@synthesize Name;
@synthesize Url;
@synthesize latestUpdates;
@synthesize interpreter;

- (id)initWithName:(NSString*)name Url:(NSString*)url Interpreter:(FeedInterpreter*)feedInterpreter andSource:(int)source
{
    if ((self = [super init])) 
    {
        self.LastUpdated = nil;
        self.Dirty = NO;
        self.Enabled = NO;
        self.Source = source;
        self.Name = name;
        self.Url = url;
        //Assign self as the interpreters feed
        feedInterpreter.feed = self;
        self.interpreter = feedInterpreter;
      
    }
    return self;

}
- (id)initWithName:(NSString*)name Url:(NSString*)url andSource:(int)source
{
    return [self initWithName:name Url:url Interpreter:[[[FeedInterpreter alloc] init] autorelease] andSource:source];
}
- (void)dealloc 
{
    //Dirty - do not release
    //Enabled - do not release
    [Name release];
    [LastUpdated release];
    [Url release];
    [latestUpdates release];
	[interpreter release];
    [super dealloc];
}

@end