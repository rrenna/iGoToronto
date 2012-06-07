//
//  FlightselfView.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-15.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FlightCellView.h"

static NSDateFormatter* flightselfDateFormatter;
UIColor* selfForegroundColour;

@implementation FlightCellView

+(void)load
{
    flightselfDateFormatter = [[NSDateFormatter alloc] init];
    [flightselfDateFormatter setDateFormat:@"hh:mm aaa"];
}

-(id)initWithFlight:(Flight*)flight isTypeArrivals:(BOOL)isTypeArrivals reuseIdentifier:(NSString*)reuseIdentifier
{
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) 
    {
        //Flight = flight;

        [self.textLabel setText: flight.Departed];
        [self.textLabel setTextColor:[UIColor lightGrayColor]];
        [self.textLabel setFont:[[Constants sharedConstants] headerTextFont]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setText: [NSString stringWithFormat:@"Flight %@ on %@",flight.FlightName,flight.Airline]];
        [self.detailTextLabel setTextColor:[UIColor whiteColor]];
        [self.detailTextLabel setFont:[[Constants sharedConstants] headerTextFont]];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 85, 10, 85, 28)];
        [timeLabel setFont:[[Constants sharedConstants] headerTextFont]];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        //If viewing arrivals, show the revised arrival time, if not show the scheduled departure time
        if(isTypeArrivals)
        {
            [timeLabel setText:[flightselfDateFormatter stringFromDate:flight.RevisedTime]];
        }
        else
        {
            [timeLabel setText:[flightselfDateFormatter stringFromDate:flight.DepartureTime]];   
        }
        
        [self.contentView addSubview:timeLabel];
        [timeLabel release];
    }
    return self;
    
}

- (void) layoutSubviews {
    
    [super layoutSubviews]; 
    
    [self.textLabel setFrame:CGRectMake(2, 12, 200, 20)];
    [self.detailTextLabel setFrame:CGRectMake(2, 37, 300, 20)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
