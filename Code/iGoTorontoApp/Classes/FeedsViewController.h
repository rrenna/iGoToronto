//
//  FeedsViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-28.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedType.h"
#import "Feed.h"
//Forward declaration to maintain class order
@class FeedType;

@interface FeedsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> 
{
    NSMutableDictionary* feedLists;
    NSMutableArray* activeFeedTypes;
    UIImage* twitterCellImage;
    BOOL dirty;
    FEED_FILTER filter;
}
@property (retain) NSMutableDictionary* feedLists;
@property (retain,nonatomic) IBOutlet UITableView* feedTable;

-(IBAction)close:(id)sender;

-(int)getActiveFeedTypeNumber;
-(FeedType*)getFeedTypeAtRelativeIndex:(int)index;
-(void)setFilter : (FEED_FILTER) f;
-(void)loadStaticSettings;
-(void)loadDynamicSettings;
@end