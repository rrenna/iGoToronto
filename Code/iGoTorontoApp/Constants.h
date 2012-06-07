//
//  Constants.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-12-19.
//  Copyright 2010 Offblast Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iGoMenuViewController.h"
#import "FeedType.h"

typedef enum
{
	IPAD_PROFILE,
	DESKTOP_PROFILE,
	IPHONE_PROFILE
} DEVICE_PROFILE;

static CGSize iPhoneLandscapeContentSize;
static CGSize iPhonePortraitContentSize;
static CGSize iPadLanscapeContentSize;
static CGSize iPadPortraitContentSize;

static NSString* isTrainLabel = @"Train";
static NSString* isNotTrainLabel = @"Bus";
//Notifications
static NSString* NOTIFICATION_OBJECT_PIN_CHANGED = @"NOTIFICATION_OBJECT_PIN_CHANGED";
static NSString* NOTIFICATION_LOCATION_CHANGED = @"NOTIFICATION_LOCATION_CHANGED";
static NSString* NOTIFICATION_FEED_SETTINGS_CHANGED = @"NOTIFICATION_FEED_SETTINGS_CHANGED";
static NSString* NOTIFICATION_GO_STATION_VIEW = @"NOTIFICATION_GO_STATION_VIEW";
static NSString* NOTIFICATION_GO_UNION_BOARD_VIEW = @"NOTIFICATION_GO_UNION_BOARD_VIEW";
static NSString* NOTIFICATION_SUBWAY_STATION_VIEW = @"NOTIFICATION_SUBWAY_STATION_VIEW";
static NSString* NOTIFICATION_CAMERA_VIEW = @"NOTIFICATION_CAMERA_VIEW";
static NSString* NOTIFICATION_FILE_DOWNLOADED_SUCCESSFULLY = @"NOTIFICATION_FILE_DOWNLOADED_SUCCESSFULLY";
static NSString* NOTIFICATION_FILE_DOWNLOADED_ERROR = @"NOTIFICATION_FILE_DOWNLOADED_ERROR";
//Go Schedule Day Types
static NSString* GODayType_MondayToThursday = @"Mon to Thur";
static NSString* GODayType_Friday = @"Friday";
static NSString* GODayType_MondayToFriday = @"Mon to Fri";
static NSString* GODayType_Saturday = @"Saturday";
static NSString* GODayType_Sunday = @"Sunday";
static NSString* GODayType_Holiday = @"Holiday";

//Static Content
static NSString* companyInformation = @"";

@interface Constants : NSObject 
{
}
/* Helper Objects */
@property (retain) NSDateFormatter *twelveHourDateFormatter;
/* UI Constants */
@property (assign) DEVICE_PROFILE deviceProfile;
@property (assign) UIDeviceOrientation orientation;
@property (assign) CGSize screenContentSize;
@property (assign) int goStopListingWidthPerStop;
@property (assign) BOOL portraitOrientationSupport;
@property (assign) BOOL landscapeOrientationSupport;
@property (retain) UIFont* headerTextFont;
@property (retain) UIFont* cellTextFont;
@property (retain) UIFont* cellTextFontSmall;
@property (retain) UIFont* cellTextFontMedium;
@property (retain) UIFont* stopTextFont;
@property (retain) UIFont* stopTextFontSmall;
@property (retain) UIColor* headerBackgroundColour;
@property (retain) UIImage* checkmarkImage;
@property (retain) UIImage* twitterBirdImage;
/* Text Constants */
@property (retain) NSString* ErrorMessage_NoInternetConnection;
@property (assign) BOOL iGoMenuDisplayed;
@property (retain) iGoMenuViewController* igoMenuViewController;
@property (retain) FeedType* weatherFeedType;
@property (retain) FeedType* newsFeedType;
@property (retain) FeedType* appFeedType;
@property (retain) FeedType* trafficFeedType;
@property (retain) NSString* versionName;
@property (retain) NSString* lastUpdatedSchedules;
@property (retain) NSString* updateReleaseNotes;
//Urls
@property (retain) NSString* tellAFriendMessage;
@property (retain) NSString* whatsNextWebpageUrl;
@property (retain) NSString* companyWebpageUrl;
@property (retain) NSString* iTunesAppUrl;
+(Constants*)sharedConstants;
//Used to auto update the orientation constant
-(void)orientationChanged:(NSNotification*)notification;
//Used to calculate useable screen area
-(void)calculateScreenArea;
@end