/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "AppDelegate.h"
#import "TransportationMode.h"
#import "Destination.h"
#import "ProfileViewController.h"
#import "ADBMobile.h"

#define RED_COLOR  [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1.0]
#define BLUE_COLOR  [UIColor colorWithRed: 0 green: 0 blue: 1 alpha: 1.0]
#define GREEN_COLOR  [UIColor colorWithRed: 0 green: 1 blue: 0 alpha: 1.0]
#define YELLOW_COLOR  [UIColor colorWithRed: 1 green: 1 blue: 0 alpha: 1.0]
#define TEXT_COLOR_NAMES @{@"blue":BLUE_COLOR, @"green":GREEN_COLOR, @"red": RED_COLOR, @"yellow": YELLOW_COLOR};

@interface AppDelegate()
@property (strong, nonatomic) NSMutableDictionary *destinations;
@property (strong, nonatomic) NSMutableDictionary *transportationModes;
@property (nonatomic) BOOL hasSpecialOffer;
@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate methods
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    [application registerForRemoteNotifications];
    
    /* Adobe Analytics
	 *
	 * 1. turn debug logging on so we can see activity in the Xcode console
	 * 2. collect lifecycle data with additional data reporting the year
	 */
    
	[ADBMobile setDebugLogging:YES];
	[ADBMobile collectLifecycleDataWithAdditionalData:@{@"summit.year":@"2017"}];
    NSDictionary *contextData = @{@"testName":@"Summit Lab 2017", @"testMessage":@"AMS postbacks are sweet!"};
    [ADBMobile trackAction:@"demo-postbacks" data:contextData];
	
	// initialize our fake data for the app
    [self loadDestinations];
    [self loadTransportationModes];    
    
    return YES;
}

#pragma mark - Deep linking
- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[url scheme] isEqualToString:@"com.adobe.summitlab"]) {
		/* Adobe Analytics
		 *
		 * 1. track the deep link used as an entry point to the app
		 */
        // [ADBMobile trackAdobeLink:url];
		
		
        _hasSpecialOffer = YES;
        return YES;
    }
    
    return NO;
}

#pragma mark - Push Message methods
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	/* Adobe Analytics
	 *
	 * 1. pass the push token for this device to the Adobe SDK
	 */    
	[ADBMobile setPushIdentifier:deviceToken];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	/* Adobe Analytics
	 *
	 * (optional)
	 * 1. set the push token to nil for this device (this helps keep the estimated audience more accurate)
	 */
	[ADBMobile setPushIdentifier:nil];
}

// app target < iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	// only send the hit if the app is not active
	if (application.applicationState != UIApplicationStateActive) {
		/* Adobe Analytics
		 *
		 * 1. when the user opens your app by clicking through your push message, report it to the Adobe SDK
		 */
		[ADBMobile trackPushMessageClickThrough:userInfo];
        /*
         * Handle custom payload
         */
        UIColor *customColor = [self extractColorFromData:userInfo];
        [self customizeUsingPushData:customColor];
	}
}

// app target >= iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	// only send the hit if the app is not active
	if (application.applicationState != UIApplicationStateActive) {
		/* Adobe Analytics
		 *
		 * 1. when the user opens your app by clicking through your push message, report it to the Adobe SDK
		 */
		[ADBMobile trackPushMessageClickThrough:userInfo];
        
        /*
         * Handle custom payload
         */
        UIColor *customColor = [self extractColorFromData:userInfo];
        [self customizeUsingPushData:customColor];
	}
	completionHandler(UIBackgroundFetchResultNoData);
}

- (void)customizeUsingPushData:(UIColor *)customColor{
    
    if (!customColor){
        return;
    }
    
    UIViewController *mainViewController = self.window.rootViewController;
    if ([mainViewController isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *profileViewController = (ProfileViewController *)mainViewController;
        profileViewController.txtName.textColor = customColor;
        profileViewController.txtCreditCard.textColor = customColor;
    }
}

- (UIColor *)extractColorFromData:(NSDictionary *)data{
    UIColor *customColor = nil;
    NSString *customColorString = [data objectForKey:@"color"];
 
    if (customColorString != nil && customColorString.length > 0){
        NSDictionary *allColors = TEXT_COLOR_NAMES;
        customColor = allColors[customColorString];
    }
    
    return customColor;
}

#pragma mark - Class methods
+ (NSDictionary *) destinations {
	AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return sharedDelegate.destinations;
}

+ (NSDictionary *) transportationModes {
	AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return sharedDelegate.transportationModes;
}

+ (BOOL) hasSpecialOffer {
	AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return sharedDelegate.hasSpecialOffer;
}

#pragma mark - Initialization methods
- (void) loadDestinations {
	// load the destinations from the plist
    _destinations = [@{} mutableCopy];
    NSString *destinationsFile = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"plist"];
    
    for (NSDictionary *d in [NSArray arrayWithContentsOfFile:destinationsFile]) {
        NSString *name = d[@"name"];
        NSDictionary *locations = d[@"locations"];
        NSNumber *lat = d[@"lat"];
        NSNumber *lon = d[@"lon"];
		NSNumber *mapX = d[@"mapX"];
		NSNumber *mapY = d[@"mapY"];
        
        NSMutableDictionary *tempDestinations = [NSMutableDictionary dictionary];
        for (NSString *locationName in [locations allKeys]) {
            [tempDestinations setObject:locations[locationName] forKey:locationName];
        }
        
        [_destinations setObject:[Destination destinationWithName:name destinations:tempDestinations
															  lat:[lat floatValue] lon:[lon floatValue]
															 mapX:[mapX floatValue] mapY:[mapY floatValue]] forKey:name];
    }
}

- (void) loadTransportationModes {
	// load transportation modes from the plist
    _transportationModes = [@{} mutableCopy];
    NSString *transportationModesFile = [[NSBundle mainBundle] pathForResource:@"transportationModes" ofType:@"plist"];
    
    for (NSDictionary *d in [NSArray arrayWithContentsOfFile:transportationModesFile]) {
        TransportationMode *currentTransportationMode = [TransportationMode transporationModeWithName:d[@"name"]
                                                                                          description:d[@"description"]
                                                                                  costPerUnitTraveled:d[@"costPerUnitTraveled"]
                                                                                                image:d[@"image"]
																							 duration:d[@"duration"]];
        
        [_transportationModes setObject:currentTransportationMode forKey:currentTransportationMode.name];
    }
}

@end
