//
//  CDRoute+Extension.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "CDRoute+Extension.h"
#import "iGoTorontoAppDelegate.h"


@implementation CDRoute (CDRoute_Extension)

-(NSArray*) sortedStops
{
	NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Time" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
	id results = [[[self Stops] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	
	[sortNameDescriptor release];
	[sortDescriptors release];
	
	return results;
}
-(NSArray*)sortedStopsAfterTime:(NSDate*)time
{
    NSError *error;
    iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = delegate.managedObjectContext;
    //Sort by Time
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Time" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDStop"
                                   inManagedObjectContext:context]];

    //Must be attached to this route, and take place after a certain stop time
    [request setPredicate:[NSPredicate predicateWithFormat:@"(Route ==  %@ ) AND (Time > %@)", self, time]];

    NSArray *results = [context executeFetchRequest:request error:&error];
	results = [results sortedArrayUsingDescriptors:sortDescriptors];
	
	[sortNameDescriptor release];
	[sortDescriptors release];
	[request release];
	
    return results;
}

@end
