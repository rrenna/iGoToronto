//
//  iGoTorontoAppDelegate.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class PlaneViewController;

typedef enum
{
    QUALITY_HIGH,
    QUALITY_MEDIUM,
    QUALITY_LOW
} QUALITY_MODE;

@interface iGoTorontoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
    
	UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
	//Core Data Objects
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
   
}
@property (assign) QUALITY_MODE QualityMode;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)handleStartup;
@end
