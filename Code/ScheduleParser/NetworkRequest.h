//
//  NetworkRequest.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkRequest : NSObject
{
    NSMutableURLRequest* nsRequest;
}
@property (retain,readwrite) NSMutableURLRequest* nsRequest;

-(id)initWithUrl:(NSString*)url;
-(NSString*)post:(NSError**)error;



@end
