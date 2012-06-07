//
//  CameraFeedInterpreter.m
//  iGoToronto
//
//  Created by Ryan Renna on 11-03-10.
//  Copyright 2011 Offblast Softworks. All rights reserved.
//

#import "CameraFeedInterpreter.h"
#import "DownloadCenter.h"
#import "iGoTorontoAppDelegate.h"
#import "CDCamera.h"

@implementation CameraFeedInterpreter
@synthesize Camera;

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

/* Custom Method */
-(void)interpret
{
    //Retrieve Camera
    iGoTorontoAppDelegate *delegate = (iGoTorontoAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = delegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCamera" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"(Name ==  %@)", self.feed.Name]];

    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    if([fetchedObjects count] > 0)
    {
        self.Camera = [fetchedObjects objectAtIndex:0];
    }

    NSString* urlString;

    if([self.Camera.RelativeUrl rangeOfString:@"http://"].location != NSNotFound)
	{
		urlString = self.Camera.RelativeUrl;
	}
	else 
	{
		urlString = [NSString stringWithFormat:@"%@%@",[self.Camera.Roadway BaseUrl],self.Camera.RelativeUrl];
	}
    
    NSData* imageData = [[DownloadCenter sharedCenter] syncronousRequestFileWithUrlString:urlString];
	UIImage* image = [UIImage imageWithData:imageData];
    self.image  = image;
    
    UILabel * cameraNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 640, 85)] autorelease];
    cameraNameLabel.backgroundColor = [UIColor clearColor];
    [cameraNameLabel setTextColor:[UIColor whiteColor]];
    [cameraNameLabel setText:Camera.Name];
    cameraNameLabel.numberOfLines = 2;
    cameraNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.content = cameraNameLabel; 
    //Set the feed as updated
    self.feed.LastUpdated = [NSDate date];
}
-(void)dealloc
{
    [Camera release];
    [super dealloc];
}
@end
