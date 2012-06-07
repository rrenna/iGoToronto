//
//  CameraFeedInterpreter.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-03-10.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedInterpreter.h"
@class CDCamera;

@interface CameraFeedInterpreter : FeedInterpreter {
    
}
@property (retain) CDCamera* Camera;
@end
