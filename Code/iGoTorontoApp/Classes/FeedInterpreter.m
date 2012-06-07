//
//  FeedInterpreter.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "FeedInterpreter.h"

@implementation FeedInterpreter
@synthesize image;
@synthesize content;
@synthesize firstURL;
@synthesize rangeOfFirstURL;
@synthesize feed;

-(id)init
{
	self = [super init];
	if(self)
	{
		NSRange range; range.length = -1; range.location = NSNotFound;
		self.rangeOfFirstURL = range;
	}
	return self;
}

-(void)dealloc
{
	[image release];
	[content release];
	//feed - do not release
	[super dealloc];
}
/* Custom Method */
-(void)interpret
{
	FeedType *weatherFeedType = [Constants sharedConstants].weatherFeedType;
	NSString* latestUpdate = Nil;
    if([feed.latestUpdates count] > 0)
    {
        latestUpdate = [feed.latestUpdates objectAtIndex:0];
        NSRange rangeOfFirstUrl = [latestUpdate rangeOfRegex:@"((mailto\\:|(news|(ht|f)tp(s?))\\://){1}\\S+)" capture:1]; // check for the hours
        if(rangeOfFirstUrl.location != NSNotFound)
        {
            self.rangeOfFirstURL = rangeOfFirstUrl;
            self.firstURL = [latestUpdate substringWithRange:rangeOfFirstUrl];
        }
    }
    
	//If a weather feed, and there are updates to interpret	
	if([weatherFeedType.Feeds containsObject:feed] && latestUpdate)
	{
		
		//Gets the range of the chunk of text we think contains a forcast
		NSRange forcastTextRange; 
		forcastTextRange.location = 11;
		forcastTextRange.length= 50;
        //Ensures the update is long enough to search the position
		if([latestUpdate length] <= (forcastTextRange.location + forcastTextRange.length) )
        {
            forcastTextRange.location = 0;
            forcastTextRange.length= [latestUpdate length];
        }
        
        if([latestUpdate rangeOfString:@"Sunny" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_sunny.png"];
        }
        else if([latestUpdate rangeOfString:@"Clear" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_cloudy1.png"];
        }
        else if([latestUpdate rangeOfString:@"Cloud" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_cloudy5.png"];
        }
        else if(
                ([latestUpdate rangeOfString:@"Light Snow" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
                ||
                ([latestUpdate rangeOfString:@"Flurries" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
                ) //Flurries is a euphism of snow
        {
            self.image = [UIImage imageNamed:@"weather_icon_snow1.png"];
        }
        else if([latestUpdate rangeOfString:@"Snow" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_snow4.png"];
        }
        else if([latestUpdate rangeOfString:@"Hail" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_hail.png"];
        }
        else if(
                ([latestUpdate rangeOfString:@"Rain" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
                ||
                ([latestUpdate rangeOfString:@"Showers" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
                ) //Showers is a euphism of rain
        {
            self.image = [UIImage imageNamed:@"weather_icon_light_rain.png"];
        }
        else if([latestUpdate rangeOfString:@"Storm" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_tstorm1.png"];
        }
        else if([latestUpdate rangeOfString:@"Fog" options:NSCaseInsensitiveSearch range:forcastTextRange].location != NSNotFound)
        {
            self.image = [UIImage imageNamed:@"weather_icon_fog.png"];
        }
        else
        {
            self.image = [UIImage imageNamed:@"weather_icon_dunno.png"];
        }
	}
	else
	{
		self.image = nil;
		//self.image = [Constants sharedConstants].twitterBirdImage;
	}
	
	//Not yet used
	//UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,90,25)];
	//NSString* latestUpdate = [feed.latestUpdates objectAtIndex:0];
	//[label setText:latestUpdate];		
	//self.content = label;
	//[label release];
}
@end
