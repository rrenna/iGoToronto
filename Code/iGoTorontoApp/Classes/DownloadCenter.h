//
//  DownloadCenter.h
//  LifeStylerClient
//
//  Created by Ryan Renna on 10-12-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "ASIHTTPRequest.h"

/* A singleton which manages all file downloads */
@interface DownloadCenter : Singleton <ASIHTTPRequestDelegate>
{
	NSOperationQueue* downloadQueue;
}
@property (retain) NSOperationQueue* downloadQueue;

+(id)sharedCenter;

- (NSString *)documentsDirectory;
- (NSString *)cachesDirectory;
-(BOOL) isFileStored : (NSString*) filename;
//Download Methods
//Asyncronous
-(void)requestFileWithUrlString:(NSString*)urlString;
-(void)requestFileWithUrl:(NSURL*)url;
//Syncronous
-(NSData*)syncronousRequestFileWithUrlString:(NSString*)urlString;
-(NSData*)syncronousRequestFileWithUrl:(NSURL*)url;

-(UIImage*)retrieveImageNamed:(NSString*)imageName;
@end
