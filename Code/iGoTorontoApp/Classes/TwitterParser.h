//
//  TwitterParser.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-27.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "TBXML.h"

@interface TwitterParser : NSObject 
{
    
}
-(NSMutableArray*)getLast:(int)number TweetsForUser:(NSString*)username;
@end
