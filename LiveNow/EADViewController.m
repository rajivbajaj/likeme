//
//  EADViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/8/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADViewController.h"
#import "UserInfo.h"
#import "Constants.h"
#import "Postman.h"
#import "EADEventsViewController.h"
#import "HumanInterfaceUtility.h"
#import "EADGroupsViewController.h"
@interface EADViewController ()

@end

@implementation EADViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewloaded = true;
    if (_logout)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                           message:@"Are you sure to logout?"
                                                          delegate:self
                                
                                                  cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK", nil];
        
        [alertView show];
       
        
    }
    else
    {
        //[self CurrentLocationIdentifier];
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.delegate = self;
        [self.view addSubview:loginView];
        // Align the button in the center horizontally
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 450);
        
        //[self.view addSubview:loginView];
        // Do any additional setup after loading the view, typically from a nib.
        loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    }
    [self.view setBackgroundColor:[HumanInterfaceUtility colorWithHexString:@"C0CFD6"]];
}
- (void) viewDidAppear:(BOOL)animated
{
    if (_logout && _viewloaded == false)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:@"Are you sure to logout?"
                                                           delegate:self
                                  
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
        
    }
    else
    {
        //[self CurrentLocationIdentifier];
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.delegate = self;
        [self.view addSubview:loginView];
        // Align the button in the center horizontally
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 450);
        
        //[self.view addSubview:loginView];
        // Do any additional setup after loading the view, typically from a nib.
        loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    }

   
}
- (void)alertView:(UIAlertView *)alertView
willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        _logout = false;
        [self navigateToMainPage];

    }
    else
    {
       
        [FBSession.activeSession closeAndClearTokenInformation];
        _logout = false;
    }
}
//-(void)CurrentLocationIdentifier
//{
//    //---- For getting current gps location
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = 100;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    //------
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
//    CLLocation *newLocation = locations.lastObject;
//    
//    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 5.0) return;
//    
//    if (newLocation.horizontalAccuracy < 0) return;
//    
//    // Needed to filter cached and too old locations
//    //NSLog(@"Location updated to = %@", newLocation);
//    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    double distance = [loc1 distanceFromLocation:loc2];
//    currentLocation = newLocation;
//    
//    if(distance > 20)
//    {
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             //NSString *Address = [[NSString alloc]initWithString:locatedAt];
             self.userLocation = [[NSString alloc]initWithString:placemark.locality];
             //NSString *Country = [[NSString alloc]initWithString:placemark.country];
             //NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             //NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             
             
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

- (IBAction)guestLoginTouch:(id)sender {
    [self navigateToMainPage];
}

- (void)navigateToMainPage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController* controller;
    
    self.slideoutController = [AMSlideOutNavigationController slideOutNavigation];
    [self.slideoutController setSlideoutOptions:[AMSlideOutGlobals defaultFlatOptions]];
    [self.slideoutController addSectionWithTitle:@""];

    UserInfo *userInfo = [UserInfo sharedUserInfo];

    NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:1 withTitle:userInfo.firstName andIcon:image];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"UserInterests"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:2 withTitle:@"Interests" andIcon:@"img_interesticon.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"userList"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:3 withTitle:@"Search People" andIcon:@"img_searchpeople.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Map"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:4 withTitle:@"Live Search" andIcon:@"img_livesearch.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:5 withTitle:@"Inbox" andIcon:@"img_inbox.png"];
    
    EADEventsViewController *eventController;
    eventController = [storyboard instantiateViewControllerWithIdentifier:@"Events"];
    eventController.isMyEvent = false;
    [self.slideoutController addViewControllerToLastSection:eventController tagged:6 withTitle:@"Events" andIcon:@"img_events.png"];
    

    eventController = [storyboard instantiateViewControllerWithIdentifier:@"Events"];
    eventController.isMyEvent = true;
    [self.slideoutController addViewControllerToLastSection:eventController tagged:7 withTitle:@"My Events" andIcon:@"MyEvents.png"];
    EADGroupsViewController *groupController;
    groupController = [storyboard instantiateViewControllerWithIdentifier:@"Groups"];
    groupController.isMyGroup = false;
    [self.slideoutController addViewControllerToLastSection:groupController tagged:8 withTitle:@"Groups" andIcon:@"img_group.png"];
    
    groupController = [storyboard instantiateViewControllerWithIdentifier:@"Groups"];
    groupController.isMyGroup = true;
    [self.slideoutController addViewControllerToLastSection:groupController tagged:9 withTitle:@"My Groups" andIcon:@"MyGroups.png"];
    
    EADViewController *loginController;
    loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    loginController.logout = true;
    [self.slideoutController addViewControllerToLastSection:loginController tagged:10 withTitle:@"Logout" andIcon:@"img_logout.png"];
    

    
    EADAppDelegate *appDelegate = (EADAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window setRootViewController:self.slideoutController];
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    if (FBSession.activeSession.isOpen) {
        
      
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 userInfo.firstName = user.first_name;
                 userInfo.lastName = user.last_name;
                 userInfo.userId = user.objectID;
                 userInfo.email = [user objectForKey:@"email"];
                 userInfo.profileImageURL = [[NSString alloc] initWithFormat: FacebookProfilePicURL, userInfo.userId];
                 //userInfo.userLocation=self.userLocation;
                 // update user information
                 Postman *postMan = [Postman alloc];
                 NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                                     [postMan GetValueOrEmpty:userInfo.firstName], @"FirstName",
                                                     [postMan GetValueOrEmpty:userInfo.lastName], @"LastName",
                                                     [postMan GetValueOrEmpty:userInfo.profileImageURL], @"FBProfileURL",
                                                     //[postMan GetValueOrEmpty:userInfo.Latitude], @"Latitude",
                                                    // [postMan GetValueOrEmpty:userInfo.Longitude], @"Longitude",
                                                     nil];

                 //[postMan UserUpdate:userDataDictionary];
                 [postMan Post:@"users/post?value=%@" :userDataDictionary];
                 
                 [self navigateToMainPage];
             }
         }];
    }
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //self.profilePictureView.profileID = nil;
    //self.nameLabel.text = @"";
    //self.statusLabel.text= @"You're not logged in!";
  
    
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
