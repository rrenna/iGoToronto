//
//  FlightCellView.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-15.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"

@interface FlightCellView : UITableViewCell {
    Flight* Flight;
    
}

-(id)initWithFlight:(Flight*)flight isTypeArrivals:(BOOL)isTypeArrivals reuseIdentifier:(NSString*)reuseIdentifier;
@end
