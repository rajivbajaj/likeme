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

@interface EADViewController ()

@end

@implementation EADViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 450);
    //[self.view addSubview:loginView];
	// Do any additional setup after loading the view, typically from a nib.
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    
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
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Messages"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:1 withTitle:@"Inbox" andIcon:@"Inbox.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Events"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:2 withTitle:@"Events" andIcon:@"icon1b.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Groups"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:3 withTitle:@"Groups" andIcon:@"Groups.png"];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    NSURL *profilePicURL = [NSURL URLWithString:[userInfo profileImageURL]];
    [self.slideoutController addViewControllerToLastSection:controller tagged:4 withTitle:@"Profile" andIcon:profilePicURL];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"Map"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:5 withTitle:@"Events Map" andIcon:@"map.png"];
    
    controller = [storyboard instantiateViewControllerWithIdentifier:@"UserInterests"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:5 withTitle:@"Interests" andIcon:@"favorite.png"];
    
    [self.slideoutController addActionToLastSection:^{} tagged:6 withTitle:@"Logout" andIcon:@"logout.png"];
    
    EADAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
                 
                 // update user information
                 Postman *postMan = [Postman alloc];
                 NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                                     [postMan GetValueOrEmpty:userInfo.firstName], @"FirstName",
                                                     [postMan GetValueOrEmpty:userInfo.lastName], @"LastName",nil];

                 [postMan UserUpdate:userDataDictionary];
                 
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
