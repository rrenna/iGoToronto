//
//  IGoMainScreenController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-09.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "HelpViewController.h"
#import "iGoMenuViewController.h"
#import "InfoPopupViewController.h"
#import "IGoScreenController.h"
@class AdViewController;
@class iGoGradientButton;
@interface IGoMainScreenController : IGoScreenController 
{
}
@property (retain,nonatomic) IBOutlet iGoGradientButton* iGoButton;
@property (retain,nonatomic) IBOutlet UIView* adSpaceView;
@property (retain) HelpViewController* helpViewController;
@property (retain) AdViewController* adViewController;
@property (retain) InfoPopupViewController* infoPopupViewController;

-(IBAction)displayiGoMenu:(id)sender;
-(void)displayHelp:(NSString*)text;
@end
