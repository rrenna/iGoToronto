//
//  StopCellView.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-08.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "StopCellView.h"
#import "CircleView.h"

static NSDateFormatter* estFormatter;

@implementation StopCellView
@synthesize stop;
@synthesize routeScrollView;

+(void)load
{
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	estFormatter = [[NSDateFormatter alloc] init];
	[estFormatter setDateFormat:@"HH:mm:ss"]; // e.g., set for mysql date strings
	[estFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
	[pool release];
}
- (id)initWithBackgroundColour:(UIColor*)backgroundColor foregroundColor:(UIColor*)foregroundColor font:(UIFont*)font reuseIdentifier:(NSString *)reuseIdentifier andStop:(CDStop*)pStop 
{
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) 
    {
        CircleView* circleView = [[[CircleView alloc] initWithFrame:CGRectMake(6, 6, 15, 15)] autorelease];
        circleView.color = [[[pStop Route] Line] PrimaryColour];
        [self addSubview:circleView];
		
		isScheduleLoaded = NO;
		self.stop = pStop;
		[self.textLabel setText:[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:stop.Time]];
       	[self.textLabel setBackgroundColor:backgroundColor];
        [self.textLabel setTextColor:foregroundColor];
        [self.textLabel setFont:font];
        
		if([stop.isTrain intValue] == 1)
        {
            [self.detailTextLabel setText:isTrainLabel];
        }
        else
        {
            [self.detailTextLabel setText:isNotTrainLabel];
        }
	}
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andStop:(CDStop*)pStop 
{
    if ((self = [self initWithBackgroundColour:[UIColor whiteColor] foregroundColor:[UIColor blackColor] font:[UIFont fontWithName:@"Helvetica" size:12] reuseIdentifier:reuseIdentifier andStop:pStop]))
	{
	}
    return self;
}
/* Custom Methods */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];
	
	if(selected)
	{
		if(!isScheduleLoaded)
		{
			int size = [Constants sharedConstants].goStopListingWidthPerStop;
            int timeWidth = 110;
			int counter = 0;
			CDRoute* route = stop.Route;
			NSDate* stopTime = stop.Time;
		
			//scrollview
			CGRect scrollViewFrame = CGRectMake(timeWidth, 0, (int)(self.frame.size.width - timeWidth), self.bounds.size.height);
			routeScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
			[routeScrollView setUserInteractionEnabled:YES];
			[routeScrollView setScrollEnabled:YES];
			[self addSubview:routeScrollView];
			[routeScrollView setHidden:YES];
			[routeScrollView release];
			
			for(CDStop* futureStop in [route sortedStopsAfterTime:stopTime])
			{
				CGRect labelViewFrame = CGRectMake(counter * size, 0, size, (int) (routeScrollView.frame.size.height * 0.25));
				CGRect timeLabelViewFrame = CGRectMake(counter * size, labelViewFrame.size.height, size, (int) (routeScrollView.frame.size.height * 0.25));
				CGRect typeLabelViewFrame = CGRectMake(counter * size, timeLabelViewFrame.size.height + timeLabelViewFrame.origin.y, size, (int) (routeScrollView.frame.size.height * 0.25));
				
				UILabel* futureStopLabel = [[UILabel alloc] initWithFrame:labelViewFrame];
				[futureStopLabel setText:[futureStop.Station Name]];
				[futureStopLabel setBackgroundColor:[UIColor clearColor]];
				[futureStopLabel setTextColor:[UIColor whiteColor]];
				[futureStopLabel setFont:[[Constants sharedConstants] stopTextFontSmall]];
				[routeScrollView addSubview:futureStopLabel];
				[futureStopLabel release];
				
				UILabel* stopTimeLabel = [[UILabel alloc] initWithFrame:timeLabelViewFrame];
				[stopTimeLabel setText:[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:futureStop.Time]];
				[stopTimeLabel setBackgroundColor:[UIColor clearColor]];
				[stopTimeLabel setTextColor:[UIColor whiteColor]];
				[stopTimeLabel setFont:[Constants sharedConstants].stopTextFont];
				[routeScrollView addSubview:stopTimeLabel];
				[stopTimeLabel release];
				
				UILabel* stopTypeLabel = [[[UILabel alloc] initWithFrame:typeLabelViewFrame] autorelease];
				//Print the vehicle type
				if([futureStop.isTrain boolValue])
				{
					[stopTypeLabel setText:isTrainLabel];
				}
				else
				{
					[stopTypeLabel setText:isNotTrainLabel];
					
				}
				[stopTypeLabel setBackgroundColor:[UIColor clearColor]];
				[stopTypeLabel setTextColor:[UIColor whiteColor]];
				[stopTypeLabel setFont:[Constants sharedConstants].stopTextFont];
				[routeScrollView addSubview:stopTypeLabel];
				
				counter++;
			}
			
			CGSize currentScrollViewContentSize = routeScrollView.contentSize;
			currentScrollViewContentSize.width += (counter * size);
			[routeScrollView setContentSize:currentScrollViewContentSize];
			isScheduleLoaded = YES;
			[routeScrollView setHidden:NO];
		}
		else
		{
			//Make scroll view visible while it is selected
			[routeScrollView setHidden:NO];
			
			//Only enable scrolling if the content is wider than it's containing scrollview
			if(routeScrollView.frame.size.width < routeScrollView.contentSize.width)
			{
				if(routeScrollView.contentOffset.x >= routeScrollView.contentSize.width - 116)
				{
					[routeScrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];   
				}
				else
				{
					[routeScrollView setContentOffset:CGPointMake(routeScrollView.contentOffset.x + 116,0.0) animated:YES];
				}
			}
		}
	}
	else 
	{
		//Make scroll view invsible when not selected
		[routeScrollView setHidden:YES];
	}
	
}


- (void)dealloc 
{
    [stop release];
    [routeScrollView release];
    [super dealloc];
}


@end
