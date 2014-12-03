//
//  EADViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/8/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>
#import "AMSlideOutNavigationController.h"
#import "EADAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface EADViewController : UIViewController <FBLoginViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) AMSlideOutNavigationController*  slideoutController;
@property (nonatomic, retain) NSString* userLocation;
@property  BOOL *logout;
@end
