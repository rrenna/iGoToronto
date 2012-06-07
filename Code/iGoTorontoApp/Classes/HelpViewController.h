//
//  HelpVewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-05.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController 
{
	IBOutlet UILabel* helpTextLabel;
}
@property (retain,nonatomic) IBOutlet UILabel* helpTextLabel;
@property (retain) NSString* helpText;

-(IBAction)close:(id)sender;
@end
