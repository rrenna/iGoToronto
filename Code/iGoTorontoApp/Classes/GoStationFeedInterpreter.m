//
//  GoStationFeedInterpreter.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-04-02.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "GoStationFeedInterpreter.h"
#import "GOCenter.h"
#import "CDStation.h"
#import "CDStop.h"
#import "CDDirection.h"
#import "CircleView.h"

@implementation GoStationFeedInterpreter
@synthesize station;

/* Custom Method */
-(void)interpret
{    
    iGoTorontoAppDelegate *delegate;
    NSManagedObjectContext* context;
    NSFetchRequest *fetchRequest;
    NSArray *fetchedObjects;
    NSError *error = nil;
    NSDate* filterDate = [[GOCenter sharedCenter] goComparableDateFromDate:[NSDate date]];
    
    UIView* contentView;
    UIView*  stopView;
    UILabel * stationNameLabel;
    
    //Retrieve Station
    delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CDStation" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"(Name ==  %@)", self.feed.Url]];
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"Lines",@"Lines.Directions",nil]];
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];

    
    if([fetchedObjects count] > 0)
    {
        self.station = [fetchedObjects objectAtIndex:0];
    }
    
    //The content view that all controls will be placed inside
    contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;

    //TODO : Replace with custom view, should alternate over each line
    stopView = [[[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 65)] autorelease];
    stopView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    stationNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
    stationNameLabel.backgroundColor = [UIColor clearColor];
    [stationNameLabel setTextColor:[UIColor whiteColor]];
    [stationNameLabel setText:station.Name];
    stationNameLabel.numberOfLines = 2;
    stationNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    [contentView addSubview:stationNameLabel];
    [contentView addSubview:stopView];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CDStop" inManagedObjectContext:context]];
    [fetchRequest setFetchLimit:4];
    
    NSMutableSet * dayTypes = [[[NSMutableSet alloc]init] autorelease];
    for(CDLine* line in [self.station.Lines allObjects])
    {
        DayTypeDescriptor* descriptor = [[GOCenter sharedCenter] getDayTimeDescriptorsForLine:line];
        [dayTypes addObject:descriptor.name];
    }
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(Station == %@) and (DayType in %@) and (finalStop == NO) and (Time > %@)",station,dayTypes,filterDate]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Time" ascending:YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObjects:sortDescriptor, nil]];
    error = nil;
    id stops = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    int stopWidth = 78;
    int stopRowHeight = 20;
    int xCounter = 0;
    CircleView* circleView = nil;
    UILabel* stopTimeLabel = nil;
    UILabel* stopTypeLabel = nil;
    UILabel* stopDirectionLabel = nil;
    
    for(CDStop* stop in stops)
    {
        CGRect lineCircleRect = CGRectMake(xCounter, 5, 10, 10);
        CGRect stopTimeRect = CGRectMake(14 + xCounter, 0, stopWidth, stopRowHeight);
        CGRect stopTypeRect = CGRectMake(18 + xCounter, stopRowHeight, stopWidth, stopRowHeight);
        CGRect stopDirectionRect = CGRectMake(18 + xCounter, stopTypeRect.origin.y + stopRowHeight, stopWidth, stopRowHeight);
        
        CircleView* circleView = [[[CircleView alloc] initWithFrame:lineCircleRect] autorelease];
        circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        circleView.color = [[stop.Route Line] PrimaryColour];
        
        stopTimeLabel = [[UILabel alloc] initWithFrame:stopTimeRect];
        stopTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [stopTimeLabel setBackgroundColor:[UIColor clearColor]];
        [stopTimeLabel setTextColor:[UIColor whiteColor]];
        [stopTimeLabel setFont:[Constants sharedConstants].stopTextFont];
        [stopTimeLabel setText:[[Constants sharedConstants].twelveHourDateFormatter stringFromDate:stop.Time]];
        
        stopTypeLabel = [[UILabel alloc] initWithFrame:stopTypeRect];
        stopTypeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [stopTypeLabel setBackgroundColor:[UIColor clearColor]];
        [stopTypeLabel setTextColor:[UIColor lightGrayColor]];
        [stopTypeLabel setFont:[Constants sharedConstants].stopTextFont];
        
        //Print the vehicle type
        if([stop.isTrain boolValue])
        {
            [stopTypeLabel setText:@"Train"];
        }
        else
        {
            [stopTypeLabel setText:@"Bus"];
            
        }
        
        stopDirectionLabel = [[UILabel alloc] initWithFrame:stopDirectionRect];
        stopDirectionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [stopDirectionLabel setBackgroundColor:[UIColor clearColor]];
        [stopDirectionLabel setTextColor:[UIColor lightGrayColor]];
        [stopDirectionLabel setFont:[Constants sharedConstants].stopTextFont];
        
        CDDirection* direction = [stop.Route Direction];
        [stopDirectionLabel setText: direction.Name];
 
        xCounter += stopWidth;
        [stopView addSubview:circleView];
        [stopView addSubview:stopTimeLabel];
        [stopView addSubview:stopTypeLabel];
        [stopView addSubview:stopDirectionLabel];
        [stopTimeLabel release];
        [stopTypeLabel release];
        [stopDirectionLabel release];
    }
    
    //If no stops, display a warning
    if([stops count] == 0)
    {
        UILabel* warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        warningLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [warningLabel setBackgroundColor:[UIColor clearColor]];
        [warningLabel setTextColor:[UIColor lightGrayColor]];
        [warningLabel setFont:[Constants sharedConstants].stopTextFont];
        [warningLabel setText:@"There are no more stops today"];
        [stopView addSubview:warningLabel];
        [warningLabel release];

    }
    
    self.content = contentView; 
    //Set the feed as updated
    self.feed.LastUpdated = [NSDate date];
}
-(void)dealloc
{
    [station release];
    [super dealloc];
}
@end
