//
//  InfoViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-26.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "TwitterParser.h"
#import "IGoMainScreenController.h"
#import "InfoPopupViewController.h"
#import "FeedInterpreter.h"
#import "FeedsViewController.h"
#import "HelpViewController.h"
#import "FeedInterpreter.h"
#import "OHAttributedLabel.h"

@class iGoGradientButton;
@class AdViewController;

@interface NewsViewController : IGoMainScreenController <UITableViewDelegate,UITableViewDataSource> 
{
    BOOL dirty;
    BOOL isRefreshing;
}
@property (retain,nonatomic) IBOutlet UITableView* NewsView;
@property (retain,nonatomic) IBOutlet UIProgressView* feedUpdateProgressView;
@property (retain,nonatomic) IBOutlet UILabel* noFeedsLabel;
@property (retain,nonatomic) IBOutlet UIButton* feedButton;
@property (retain,nonatomic) IBOutlet FeedsViewController* feedsViewController;
@property (retain,nonatomic) IBOutlet UIView* adSpaceView;
@property (retain,nonatomic) IBOutlet iGoGradientButton* allFilterButton;
@property (retain,nonatomic) IBOutlet iGoGradientButton* newsFilterButton;
@property (retain,nonatomic) IBOutlet iGoGradientButton* weatherFilterButton;
@property (retain,nonatomic) IBOutlet iGoGradientButton* pinnedFilterButton;
@property (retain) HelpViewController* helpViewController;
@property (retain) Feed* selectedFeed;
@property (retain) NSDate* timeOfLastRefresh;

-(IBAction)switchToFeedsView:(id)sender;
-(IBAction)displayHelp:(id)sender;
-(IBAction)displayiGoMenu:(id)sender;
-(IBAction)filterChanged : (id) sender;
-(IBAction)refresh:(id)sender;

-(void)reloadSection:(NSNumber*)sectionIndex;
-(int) sizeForStringLength : (NSString*)s;
@end
