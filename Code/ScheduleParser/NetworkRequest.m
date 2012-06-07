//
//  NetworkRequest.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkRequest.h"

@implementation NetworkRequest
@synthesize nsRequest;

-(id)initWithUrl:(NSString*)url
{
	if(self = [super init])
	{
		NSLog(@"Starting network request");
		NSURL* nsUrl = [NSURL URLWithString:url];
		nsRequest = [NSMutableURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];	
	}
	return self;
}
-(NSString*)post:(NSError**)error
{
	//if an error occured in the post
	//NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
	//[errorDetail setValue:@"Failed to do something wicked" forKey:NSLocalizedDescriptionKey];
	//*error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
//	return nil;
	
	[nsRequest setHTTPMethod:@"POST"];
	[nsRequest setValue:@"iGoToronto" forHTTPHeaderField:@"User-Agent"];
	[nsRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	NSString* postString = @""; 
	
	NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding]; 
	[nsRequest setHTTPBody:postData];
	NSURLResponse* nsResponse = nil;
	NSData* responseData = [NSURLConnection sendSynchronousRequest:nsRequest returningResponse:&nsResponse error:&error];
	return [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
}

/*
 
 if (YES) {
 //An error occurred
 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
 [errorDetail setValue:@"Failed to do something wicked" forKey:NSLocalizedDescriptionKey];
 *error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
 return nil;
 }
 
*/


/*
 @try
 {	

  
 */
@end
