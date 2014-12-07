//
//  EADAppDelegate.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/8/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface EADAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) UIWindow *window;
//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
//- (void)userLoggedIn;
//- (void)userLoggedOut;
@property (nonatomic, retain) NSString* userLocation;
@end
