//
//  PopupViewController.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-02-01.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGoScreenController.h"

@interface IGoPopupViewController : IGoScreenController {

}
-(void)slideIn;
-(void)slideOutWithDuration:(double)duration;
@end
