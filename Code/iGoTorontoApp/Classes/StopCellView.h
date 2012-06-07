//
//  StopCellView.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-08.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopCellController.h"

@interface StopCellView : UITableViewCell 
{
	bool isScheduleLoaded;
}
@property (retain) CDStop* stop;
@property (retain) UIScrollView *routeScrollView;

- (id)initWithBackgroundColour:(UIColor*)backgroundColor foregroundColor:(UIColor*)foregroundColor font:(UIFont*)font reuseIdentifier:(NSString *)reuseIdentifier andStop:(CDStop*)pStop;

@end
