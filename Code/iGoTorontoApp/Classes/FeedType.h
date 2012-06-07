//
//  FeedType.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "Feed.h"

typedef enum
{
    FEED_FILTER_ALL = 0,
    FEED_FILTER_NEWS = 1,
    FEED_FILTER_WEATHER = 2,
    FEED_FILTER_PINNED = 3
} FEED_FILTER;

@interface FeedType : NSObject 
{
    NSMutableArray* Feeds;
    NSString* Name;
    FEED_FILTER associatedFilter;
    BOOL isDataLoaded;
}
@property (retain,nonatomic) NSString* Name;
@property (retain,nonatomic) NSMutableArray* Feeds;
@property (assign) FEED_FILTER associatedFilter;
@property (assign) BOOL isDataLoaded;

-(id)initWithName:(NSString*)name;
-(int)getEnabledFeedNumber;
-(Feed*)getFeedAtRelativeIndex:(int)index;
@end