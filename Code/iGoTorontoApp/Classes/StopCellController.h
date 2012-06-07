//
//  StopCellController.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-11-08.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDStop.h"


@interface StopCellController : UIViewController 
{
 	CDStop* Stop;
}
@property (retain) CDStop* Stop;
@end
