//
//  iGoTorontoAppDelegate.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <sys/utsname.h>
#import "iGoTorontoAppDelegate.h"
#import "GoViewController.h"
#import "NewsViewController.h"

@implementation iGoTorontoAppDelegate
@synthesize QualityMode;
@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{        
    //Set Low Quality Mode based on Device
    struct utsname u; uname(&u);
    NSString* deviceType = [NSString stringWithFormat:@"%s", u.machine];
    if([deviceType isEqualToString:@"iPhone1,1"] || [deviceType isEqualToString:@"iPhone1,2"]  || [deviceType isEqualToString:@"iPod1,1"] || [deviceType isEqualToString:@"iPod2,1"])
    {
        QualityMode = QUALITY_LOW;
    }
    else
    {
        QualityMode = QUALITY_MEDIUM;
    }
    
	//Handles displaying any alerts, recording usage stats 
	[self handleStartup];
	[[Constants sharedConstants] calculateScreenArea];
	
    //Queues up the plane view to do an initial data request
	//TODO: Add in Version 1.1
	//[planeViewController performSelectorInBackground:@selector(precacheResponseWithDelay:) withObject:[NSNumber numberWithInt:4]];
	
	//Unhides the status bar
	[application setStatusBarHidden:NO animated:NO];
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If iPad - support all orientations
	if ([Constants sharedConstants].deviceProfile == IPAD_PROFILE) 
	{
		return YES;
	}
	//If iPhone - support only portrait/portrait upsidedown orientation
	else 
	{
		if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || toInterfaceOrientation == UIInterfaceOrientationPortrait)
		{
			return YES;
		}
		
	}
	
	return NO;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
/* Custom Methods */
-(void)handleStartup
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* numberOfLaunchesKey = @"NumberOfLaunches";
	NSString* haveShownPatchNotesKey = [NSString stringWithFormat:@"PatchNotesDisplayedForVersion:%@",[[Constants sharedConstants] versionName]];
	
	BOOL showPatchNotes = YES;
	int numberOfLaunches = 0;
	//Get number of previous launches
    if([prefs objectForKey:numberOfLaunchesKey])
    {
        numberOfLaunches = [prefs integerForKey:numberOfLaunchesKey];
    }
	//Asks if the patch notes have been displayed for this verion
	if([prefs objectForKey:haveShownPatchNotesKey])
    {
        showPatchNotes = ![prefs integerForKey:haveShownPatchNotesKey];
    }
	
	//Do not popup anything on first load, this user doesn't need patch nodes
	// as they just read the app description
	// As we are updating user's who've previously had the application but have not been 
	// tracking their usage
	if(numberOfLaunches == 0)
	{
		//Save that the patch notes for this release have been shown
		//This user did not need to see patch notes
		[prefs setBool:YES forKey:haveShownPatchNotesKey];
	}
	//If this is not the first load by this user
	else 
	{
		//If display patch notes
		if(showPatchNotes)
		{
			NSString *patchNotes = [NSString stringWithFormat:@"Changes in this update: \n%@",[[Constants sharedConstants] updateReleaseNotes]];
			UIAlertView* patchAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"iGo Toronto %@ Update",[[Constants sharedConstants] versionName]] message:patchNotes delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Rate",nil];
			[patchAlertView show];
			[patchAlertView release];
			//Save that the patch notes for this release have been shown
			[prefs setBool:YES forKey:haveShownPatchNotesKey];
		}
		//If the user has used the app 15 times, ask them to rate it
		//This should only fire if the patch notes arn't being displayed at this startup
		else if(numberOfLaunches == 14)
		{
			NSString *usageMessage = @"It looks like you've used iGo Toronto quite a bit! Would you like to show your support by rating the application? All feedback received is taken seriously and every effort is made to address it.";
			UIAlertView* patchAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Thanks for using iGo Toronto %@",[[Constants sharedConstants] versionName]] message:usageMessage delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Rate",nil];
			[patchAlertView show];
			[patchAlertView release];
			//Save that the patch notes for this release have been shown
			[prefs setBool:YES forKey:haveShownPatchNotesKey];		
		}		
	}

	//Increase the number of launches
    numberOfLaunches++;
	//Save the new number of launches to the user prefs 
	[prefs setInteger:numberOfLaunches forKey:numberOfLaunchesKey];
	[prefs synchronize];
}
/* UITabbar Delegate Methods */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL value = YES;
    //TabBarItems are disabled instead
   /* #ifdef LITE_VERSION
        if([viewController class] == [GoViewController class] || [viewController class] == [NewsViewController class])
        {
            return YES;
        }
        else
        {
            value = NO;
        }
    #else
    #endif*/
    return value;
}
/* UIAlertViewDelegate Methods */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Rate"])
	{
		NSURL *url = [NSURL URLWithString:[[Constants sharedConstants] iTunesAppUrl]];
		[[UIApplication sharedApplication] openURL:url];
	}
}
/* Core Data Methods */
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	NSURL *storeUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ScheduleParser" ofType:@"sqlite"]];
	
	NSError *newStoreCreationError = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel:[self managedObjectModel]];
	 
	
	if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												 configuration:nil URL:storeUrl options:nil error:&newStoreCreationError]) 
    {
        
        NSLog(@"%@",[newStoreCreationError description]);
		/*Error for store creation should be handled in here*/
	}
	//If persistent store was created successfully, delete the previous storage location
	return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc 
{
    [tabBarController release];
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
    [window release];
    [super dealloc];
}

@end

