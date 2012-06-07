//
//  CDLine+Extension.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-24.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import "CDLine+Extension.h"

@implementation CDLine (CDLine_Extension)

-(NSArray*) sortedDayTypes
{
	NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Order" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
	id results = [[[self DayTypes] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
	
	[sortNameDescriptor release];
	[sortDescriptors release];
	return results;
}
-(NSArray*) sortedFilteredStations
{
	NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
	
	id results = [[self filteredStations] sortedArrayUsingDescriptors:sortDescriptors];
	
	[sortNameDescriptor release];
	[sortDescriptors release];
	return results;
}
- (void)awakeFromFetch
{
	[super awakeFromFetch];
	self.PrimaryColour = [UIColor colorWithRed:[self.PrimaryColourR floatValue] green:[self.PrimaryColourG floatValue] blue:[self.PrimaryColourB floatValue] alpha:1.0];
}
@end
