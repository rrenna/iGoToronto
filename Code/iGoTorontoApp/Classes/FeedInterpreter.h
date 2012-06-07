//
//  FeedInterpreter.h
//  iGoToronto
//
//  Created by Ryan Renna on 11-01-12.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedsViewController.h"
#import "Feed.h"
#import "RegexKitLite.h"

@interface FeedInterpreter : NSObject 
{
}
@property (retain) UIImage* image;
@property (retain) UIView* content;
@property (retain) NSString* firstURL;
@property (assign) NSRange rangeOfFirstURL;
@property (assign) Feed* feed;

/* Custom Methods */
-(void)interpret;
@end
