//
//  InfoPopupViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iGoTorontoAppDelegate.h"
#import "IGoPopupViewController.h"

@interface InfoPopupViewController : IGoPopupViewController {
	IBOutlet UIView* bodyView; 
    UILabel* titleView;
	UIView* content;
	UIViewController* contentViewController;
}
@property (nonatomic,retain) IBOutlet UIView* bodyView;
@property (nonatomic,retain) IBOutlet UILabel* titleView;
@property (retain,nonatomic) IBOutlet UIButton* refreshButton;
@property (nonatomic,retain) UIView* content;
@property (retain,nonatomic) UIViewController* contentViewController;

-(id)initWithView:(UIView*)view andTitle:(NSString*)title;
-(id)initWithView:(UIView*)view andTitle:(NSString*)title shouldScroll:(BOOL)shouldScroll;
-(id)initWithViewController:(UIViewController*)viewController andTitle:(NSString*)title;
-(id)initWithViewController:(UIViewController*)viewController andTitle:(NSString*)title shouldScroll:(BOOL)shouldScroll;
/* IBActions */
-(IBAction)refresh : (id) sender;
@end
