//
//  FirstViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "IGoPopupViewController.h"
#import "InfoPopupViewController.h"
#import "UnionBoardDetailController.h"


//@class GoTrainTableController;

@interface UnionBoardViewController : IGoPopupViewController <ASIHTTPRequestDelegate, UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	UIView* viewBoardButton;
	NSMutableArray *trainInfoFirstLineArray;
	NSMutableArray *trainInfoSecondLineArray;
	NSMutableArray *trainInfoDetailHyperlinkArray;
    UIColor* cellBackgroundColour;
    UIColor* cellForegroundColour;
	//String response from server
	NSString *serverResponse;
@private
	NSInvocation* precacheCompleteInvocation;
}
@property (retain,nonatomic) IBOutlet UITableView* table;
@property (retain,nonatomic) UIView* viewBoardButton;
@property (retain,nonatomic) InfoPopupViewController *popupController;
@property (nonatomic,retain) NSString* serverResponse;
@property (retain) UIColor* cellBackgroundColour;
@property (retain) UIColor* cellForegroundColour;

/* Custom Methods */
-(void)precacheDataAndReplyWithInvocation:(NSInvocation*)invocation;
-(void)processResponse;
/* IBActions */
-(IBAction)close:(id)sender;
-(IBAction)refresh:(id)sender;
@end
