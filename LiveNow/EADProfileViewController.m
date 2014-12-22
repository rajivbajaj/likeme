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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    Postman* postman = [Postman alloc];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"GenderList", @"LKGroupName",
                                      nil];
    
    self.pickerData = [postman Get:@"utility/get?jsonParams=%@" :paramsDictionary];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary* userDataDictionary = [postman UserGet:userInfo.userId];
    
    NSInteger age = [[userDataDictionary objectForKey:@"Age"] integerValue];
    ageText.text = [NSString stringWithFormat:@"%ld", (long)age];
    statusText.text = [userDataDictionary valueForKey:@"ProfileStatus"];
    displayNameText.text = [userDataDictionary valueForKey:@"UserName"];
    genderText.text = [userDataDictionary valueForKey:@"Gender"];
    [self.interestsButton setTitle:[userDataDictionary valueForKey:@"UserInterests"] forState:UIControlStateNormal];
    
    
    if(userInfo.userLocation != nil && ![userInfo.userLocation isEqualToString:@""])
    {
        location.text = userInfo.userLocation;
    }
    else
    {
        location.text = [userDataDictionary valueForKey:@"City"];
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
    
    NSString *radiusString = [userDataDictionary valueForKey:@"Radius"];
    if(radiusString != nil)
    {
        [self.radiusSlider setValue:[radiusString floatValue] animated:YES];
        self.milesLabel.text = [[NSString stringWithFormat:@"%i", [radiusString integerValue]] stringByAppendingString:@" miles"];
        
    }
    
    userInfo.interestedRadius = [[NSNumber numberWithFloat:self.radiusSlider.value] integerValue];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.locationName != nil && ![self.locationName isEqualToString:@""])
    {
        self.location.text = self.locationName;
    }
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
}

- (IBAction)updateProfileTouch:(id)sender
{
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    NSString *latitudeString = [[NSNumber numberWithDouble:_latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:_longitude] stringValue];
    
    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:ageText.text], @"Age",
                                        [postMan GetValueOrEmpty:statusText.text], @"ProfileStatus",
                                        [postMan GetValueOrEmpty:displayNameText.text], @"UserName",
                                        [postMan GetValueOrEmpty:location.text], @"City",
                                        latitudeString, @"Latitude",
                                        longitudeString, @"Longitude",
                                        [postMan GetValueOrEmpty:self.genderText.text], @"Gender",
                                        [NSString stringWithFormat:@"%i", userInfo.interestedRadius], @"Radius",
                                        nil];
    
    [postMan Post:@"users/post?value=%@" :userDataDictionary];
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
    userInfo.interestedRadius = [[NSNumber numberWithFloat:self.radiusSlider.value] integerValue];
    userInfo.isRadiusChanged = true;
    NSString *interestedMiles = [NSString stringWithFormat:@"%i", userInfo.interestedRadius];
    self.milesLabel.text = [interestedMiles stringByAppendingString:@" miles"];
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
}


@end
