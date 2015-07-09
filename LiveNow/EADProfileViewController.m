//
//  EADProfileViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADProfileViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADLocationSearchViewController.h"
#import "HumanInterfaceUtility.h"
#import "EADImageViewerController.h"

@interface EADProfileViewController ()

@end

@implementation EADProfileViewController

@synthesize ageText;
@synthesize statusText;
@synthesize displayNameText;
@synthesize profilePicImageView;
@synthesize location;
@synthesize genderText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    location.delegate = self;
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    self.navigationController.navigationBar.barTintColor = [HumanInterfaceUtility colorWithHexString:@"C0CFD6"];
    //self.toolbar.barTintColor = [HumanInterfaceUtility colorWithHexString:@"3E5561"];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    [imageTap setNumberOfTapsRequired:1];
    
    [profilePicImageView addGestureRecognizer:imageTap];

    Postman* postman = [Postman sharedManager];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"GenderList", @"LKGroupName",
                                      nil];
    
    [postman Get:@"utility/get?jsonParams=%@" :paramsDictionary :^(NSArray *result) {
        self.pickerData = result;
        [self.genderPickerView setHidden:YES];
    }];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    [postman GetUser:userInfo.userId callback:^(NSDictionary *result) {

        NSDictionary *userDataDictionary = result;
        NSInteger age = [[userDataDictionary objectForKey:@"Age"] integerValue];
        ageText.text = [NSString stringWithFormat:@"%ld", (long)age];
        statusText.text = [userDataDictionary valueForKey:@"ProfileStatus"];
        displayNameText.text = [userDataDictionary valueForKey:@"UserName"];
        genderText.text = [userDataDictionary valueForKey:@"Gender"];
        [self.interestsButton setTitle:[userDataDictionary valueForKey:@"UserInterests"] forState:UIControlStateNormal];
        userInfo.Latitude =[userDataDictionary valueForKey:@"Latitude"];
        userInfo.Longitude= [userDataDictionary valueForKey:@"Longitude"];
        
        if(userInfo.userLocation != nil && ![userInfo.userLocation isEqualToString:@""])
        {
            location.text = userInfo.userLocation;
        }
        else
        {
            location.text = [userDataDictionary valueForKey:@"City"];
        }
        
        NSString *radiusString = [userDataDictionary valueForKey:@"Radius"];
        if(radiusString != nil)
        {
            [self.radiusSlider setValue:[radiusString floatValue] animated:YES];
            self.milesLabel.text = [[NSString stringWithFormat:@"%li", (long)[radiusString integerValue]] stringByAppendingString:@" miles"];
        }

        NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0);
        [image drawInRect:CGRectMake(0,0,36,36)];
        UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        profilePicImageView.image = im2;
        profilePicImageView.contentMode = UIViewContentModeTop;
        
        userInfo.interestedRadius = [[NSNumber numberWithFloat:self.radiusSlider.value] intValue];
    }];
    

}

-(void)handleImageTap:(id)sender {
    // push you view here
    //code for full screen image
    //[profilePicImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [self performSegueWithIdentifier:@"profileToImageViewer" sender:sender];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.locationName != nil && ![self.locationName isEqualToString:@""])
    {
        self.location.text = self.locationName;
    }

    Postman* postman = [Postman sharedManager];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    [postman GetUser:userInfo.userId callback:^(NSDictionary *result) {
        [self.interestsButton setTitle:[result valueForKey:@"UserInterests"] forState:UIControlStateNormal];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allOtherEditingBegin:(id)sender
{
    [self.genderPickerView setHidden:true];
}

- (IBAction)genderEditingBegin:(id)sender
{
    [self.genderPickerView setHidden:false];
    [sender resignFirstResponder];
}

- (IBAction)updateProfileTouch:(id)sender
{
    Postman* postMan = [Postman sharedManager];;
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    _latitude = [userInfo.Latitude doubleValue];
    _longitude = [userInfo.Longitude doubleValue];

    NSString *latitudeString = [[NSNumber numberWithDouble:_latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:_longitude] stringValue];
    NSString *alertMessage, *alertTitle;
    alertTitle = @"Location error";
    alertMessage = @"Select location using map icon";
    if ([latitudeString  isEqualToString:@"0"]) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }

    // update user information
    NSDictionary *userDataDictionaryUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:ageText.text], @"Age",
                                        [postMan GetValueOrEmpty:statusText.text], @"ProfileStatus",
                                        [postMan GetValueOrEmpty:displayNameText.text], @"UserName",
                                        [postMan GetValueOrEmpty:location.text], @"City",
                                        latitudeString, @"Latitude",
                                        longitudeString, @"Longitude",
                                         [postMan GetValueOrEmpty:userInfo.userDeviceToken], @"DeviceToken",
                                        [postMan GetValueOrEmpty:self.genderText.text], @"Gender",
                                        [NSString stringWithFormat:@"%i", userInfo.interestedRadius], @"Radius",
                                        nil];
    
    [postMan Post:@"users/post?value=%@" :userDataDictionaryUpdate];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

//- (IBAction)locationEditingDidBegin:(id)sender
//{
//    [self performSegueWithIdentifier:@"segueLocationPicker" sender:self];
//}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *genderValue;
    NSDictionary *currentObject = _pickerData[row];
    
    if(currentObject != nil)
    {
        genderValue = [currentObject valueForKey:@"DisplayValue"];
    }
    
    return genderValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSDictionary *selectedGenderItem = _pickerData[row];
    if(selectedGenderItem != nil)
    {
        self.genderText.text = [selectedGenderItem valueForKey:@"DisplayValue"];
    }
}

- (IBAction)radiusSliderValueChanged:(id)sender
{
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.interestedRadius = [[NSNumber numberWithFloat:self.radiusSlider.value] intValue];
    userInfo.isRadiusChanged = true;
    NSString *interestedMiles = [NSString stringWithFormat:@"%i", userInfo.interestedRadius];
    self.milesLabel.text = [interestedMiles stringByAppendingString:@" miles"];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
     BOOL editable;
    if (textField == location) {
        editable = NO;
    }
    else
    {
        editable = YES;
    }
    return editable;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueLocationPicker"])
    {
        EADLocationSearchViewController *locationSearchController = [segue destinationViewController];
        
        locationSearchController.initiatingController = @"profile";
    }
    else if([segue.identifier isEqualToString:@"profileToLocation"])
             {
                 EADLocationSearchViewController *locationSearchController = [segue destinationViewController];
                 
                 locationSearchController.initiatingController = @"profile";
             }
    else if([segue.identifier isEqualToString:@"profileToImageViewer"])
    {
        EADImageViewerController *imageViewerController = [segue destinationViewController];
        
        imageViewerController.imageData = profilePicImageView.image;
    }
    
    
    
}


@end
