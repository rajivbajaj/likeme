//
//  EADAppDelegate.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/8/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADAppDelegate.h"
#import "UserInfo.h"
@implementation EADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [FBProfilePictureView class];
//    [FBLoginView class];

    if ([[FBSession.activeSession permissions] count] && !FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithAllowLoginUI:YES];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|
                                                                               UIRemoteNotificationTypeSound|
                                                                               UIRemoteNotificationTypeAlert)];
    }

    
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
//                                                                                         |UIUserNotificationTypeSound
//                                                                                         |UIUserNotificationTypeAlert) categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [self CurrentLocationIdentifier];
   // UserInfo *userInfo = [UserInfo sharedUserInfo];
//    if(userInfo.userLocation == nil && ![userInfo.userLocation isEqualToString:@""])
//    {
//
//    double delayInSeconds = 0.0; // number of seconds to wait
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//    // Override point for customization after application launch.
//    
//    });
//    }
//    else
//    {
//        [FBLoginView class];
//
//    }
    NSSetUncaughtExceptionHandler(&customExceptionHandler);
    return YES;
}
void customExceptionHandler(NSException *exception)
{
    NSArray *stack = [exception callStackReturnAddresses];
    NSLog(@"Stack trace: %@", stack);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    
//    [FBAppEvents activateApp];
    
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
//    [FBAppCall handleDidBecomeActive];
    
    [[FBSession activeSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
//    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    BOOL wasHandled = [FBSession.activeSession handleOpenURL:url];
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.userDeviceToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        
    } else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}
#endif

- (void)CurrentLocationIdentifier {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    currentLocation = [locations objectAtIndex:0];
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             UserInfo *userInfo = [UserInfo sharedUserInfo];

             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             //NSString *Address = [[NSString alloc]initWithString:locatedAt];
             userInfo.userLocation = [[NSString alloc]initWithString:placemark.locality];
             userInfo.Latitude=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
             userInfo.Longitude=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
             //NSString *Country = [[NSString alloc]initWithString:placemark.country];
             //NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             //NSLog(@"%@",CountryArea);
         }
         else
         {
             UIAlertView *errorAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Error" message:@"Failed to Get Your Location"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
             [errorAlert show];
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
    //}
   
}

@end
