//
//  FeedType.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "FeedType.h"

@implementation FeedType
@synthesize Name;
@synthesize isDataLoaded;
@synthesize associatedFilter;
@synthesize Feeds;

-(id)initWithName:(NSString*)name
{
    if(self = [super init])
    {
        self.Name = name;
        self.Feeds = [NSMutableArray new];
        isDataLoaded = NO;
    }
    return self;
}
-(int)getEnabledFeedNumber
{
    int count = 0;
    for(Feed* feed in self.Feeds)
    {
        if(feed.Enabled)
        {
            count++;
        }
    }
    return count;
    
}
-(Feed*)getFeedAtRelativeIndex:(int)index
{
    int count = 0;
    for(Feed* feed in self.Feeds)
    {
        if(feed.Enabled)
        {
            if(count == index)
            {
                return feed;
            }
			
            count++;
        }
    }
    return nil;
}
-(void)dealloc 
{
    //associatedFilter - do not relesae
    //isDataLoaded - do not release
    [Name release];
    [Feeds release];
    [super dealloc];
}
@end