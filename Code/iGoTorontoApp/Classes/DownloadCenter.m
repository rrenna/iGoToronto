//
//  DownloadCenter.m
//
//  Created by Ryan Renna on 10-12-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadCenter.h"

static DownloadCenter * _sharedCenter;

@implementation DownloadCenter

@synthesize downloadQueue;

/* Singleton Pattern methods */
+(id)sharedCenter
{	
	@synchronized(self) 
	{
		if(!_sharedCenter) 
		{
			_sharedCenter = [[self alloc] init];
		}
	}
	return _sharedCenter;	
}
+ (id)allocWithZone:(NSZone *)zone
{
	 @synchronized(self) 
	 {
		 if (_sharedCenter == nil) 
		 {
			 _sharedCenter = [super allocWithZone:zone];
			 return _sharedCenter;
		 }
	 }
	 return nil;
}
/* */
-(void)dealloc
{
	[downloadQueue release];
	[super dealloc];
}
- (NSString *)documentsDirectory 
{
	static NSString* documentsDirectory;
	if(!documentsDirectory)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
		//Autoreleased path must be retained to persist in static reference
		documentsDirectory = [[paths objectAtIndex:0] retain];
	}
	return documentsDirectory;
}
- (NSString *)cachesDirectory 
{
	static NSString* cachesDirectory;
	if(!cachesDirectory)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
															 NSUserDomainMask, YES);
		//Autoreleased path must be retained to persist in static reference
		cachesDirectory = [[paths objectAtIndex:0] retain];
	}
	return cachesDirectory;
}
-(BOOL) isFileStored : (NSString*) filename
{
	NSString* newFilename = [[filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@"~~f"];
	newFilename = [newFilename stringByReplacingOccurrencesOfString:@"\\" withString:@"~~b"];
	NSString *path = [[self cachesDirectory] stringByAppendingPathComponent:newFilename];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
// Asyncronous Download Methods
-(void)requestFileWithUrlString:(NSString*)urlString
{
	NSURL* url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self requestFileWithUrl:url];
	[url release];
}
-(void)requestFileWithUrl:(NSURL*)url
{
	if(!downloadQueue)
	{
		self.downloadQueue = [[NSOperationQueue alloc] init];
		[self.downloadQueue setMaxConcurrentOperationCount:4];
	}
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
	//Will retry timed-out connections this many times before failure
	[request setNumberOfTimesToRetryOnTimeout:4];
	[request setDelegate:self];
	[self.downloadQueue addOperation:request];
}
// Syncronous Download Methods
-(NSData*)syncronousRequestFileWithUrlString:(NSString*)urlString
{
    NSURL* url = [[[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] autorelease];
	return [self syncronousRequestFileWithUrl:url];
}
-(NSData*)syncronousRequestFileWithUrl:(NSURL*)url
{

	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
	//Will retry timed-out connections this many times before failure
	[request setNumberOfTimesToRetryOnTimeout:4];
    [request startSynchronous];
    return [request responseData];
}
-(UIImage*)resizeImage : (UIImage*)image
{
	CGFloat ratio = image.size.width/image.size.height;
	int width,height;
	
	if (ratio > 1) {
		width = 512;
		height = width / ratio;
	} else 
	{
		height = 512;
		width = height * ratio;
	}
	
	CGRect screenRect = CGRectMake(0, 0, width, height);
	UIGraphicsBeginImageContext(screenRect.size);
	[image drawInRect:screenRect blendMode:kCGBlendModePlusDarker alpha:1];
	UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return tmpImage;
}
-(void)saveImage : (NSArray*)args
{
	//Save resulting image to disk to prevent further resizes
	NSData* imageData = UIImagePNGRepresentation([args objectAtIndex:0]);
	NSString* saveLocation = [[self cachesDirectory] stringByAppendingPathComponent:[args objectAtIndex:1]];
	[imageData writeToFile:saveLocation atomically:YES];
}
-(UIImage*)retrieveImageNamed:(NSString*)imageName
{
	NSString* filename = [[imageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@"~~f"];
	filename = [filename stringByReplacingOccurrencesOfString:@"\\" withString:@"~~b"];
	NSString *path = [[self cachesDirectory] stringByAppendingPathComponent:filename];
	UIImage* retrievedImage = [UIImage imageWithContentsOfFile:path];
	
	UIImage* image; 
	//Resize and resave the image if larger than maximum allowed
	if(retrievedImage.size.width > 512 || retrievedImage.size.height > 512)
	{
		image = [self resizeImage:retrievedImage];
		NSArray * args = [NSArray arrayWithObjects:image,filename,nil];
		[self performSelectorInBackground:@selector(saveImage:) withObject:args];
	}	
	else 
	{
		image = retrievedImage;
	}

	return image;
}
/* ASIHTTPRequest Delegate Methods */
- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching binary data
	NSData *responseData = [request responseData];
	
	NSString* filename = [[request.url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"~~f"];
	filename = [filename stringByReplacingOccurrencesOfString:@"\\" withString:@"~~b"];
	NSString* saveLocation = [[self cachesDirectory] stringByAppendingPathComponent:filename];
	[responseData writeToFile:saveLocation atomically:YES];

	//Post a notification that a file has downloaded successfully
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FILE_DOWNLOADED_SUCCESSFULLY object:[request.url absoluteString]];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FILE_DOWNLOADED_ERROR object:[request.url absoluteString]];
}
@end
