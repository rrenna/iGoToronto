//
//  iGoMenuViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-09.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "InfoPopupViewController.h"

@interface iGoMenuViewController : UIViewController <MFMailComposeViewControllerDelegate>
{   
}
@property (retain,nonatomic) IBOutlet UIButton* shroudButton;
@property (retain,nonatomic) IBOutlet UILabel* scheduleLabel;
@property (retain,nonatomic) IBOutlet UILabel* versionLabel;
@property (retain,nonatomic)  IBOutlet UIView* OffblastView;
@property (retain,nonatomic)  IBOutlet UIView* LegaleseView;
//@property (retain,nonatomic)  IBOutlet UIView* WhatsNextView;
//@property (retain,nonatomic) IBOutlet UIWebView* whatsNextWebview;
@property (retain) InfoPopupViewController* infoPopupController;
@property (retain) MFMailComposeViewController *picker;

-(IBAction) viewAboutUs : (id) sender;
//-(IBAction) viewWhatsNext : (id) sender;
-(IBAction) viewLegalese : (id) sender;
-(IBAction) viewContactUs : (id) sender;
-(IBAction) viewTellAFriend : (id) sender;
-(IBAction) visitOffblastWebsite : (id) sender;
-(IBAction)hide:(id)sender;
@end
