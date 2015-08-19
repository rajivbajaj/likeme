//
//  EADGroupDetailsViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 10/16/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADGroupDetailsViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADImagePickerViewController.h"
#import "EADGroupsViewController.h"
#import "EADLocationSearchViewController.h"

@interface EADGroupDetailsViewController ()

@end

@implementation EADGroupDetailsViewController
@synthesize groupName;
@synthesize groupDescription;
@synthesize restrictionsText;
@synthesize groupStatusLabel;
//@synthesize groupId;
@synthesize groupLocationName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"EventRestrictions", @"LKGroupName",
                                      nil];

    [[Postman sharedManager] Get:@"utility/get?jsonParams=%@" :paramsDictionary :^(NSArray *result) {
        self.pickerData =result;
    }];

    if (_groupId != nil)
    {
        [self loadGroupDetails];
    }
    self.groupLocationName.enabled = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    if(![self.locationName isEqualToString:@""])
    {
        self.groupLocationName.text = self.locationName;
        self.groupLocationName.enabled =NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionInitiatorTouched:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Take a Picture"];
    [actionSheet addButtonWithTitle:@"Camera Roll"];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            _launchCamera = true;
            [self performSegueWithIdentifier:@"imagePicker" sender:self];
            break;
        case 2:
            _launchCamera = false;
            [self performSegueWithIdentifier:@"imagePicker" sender:self];
            break;
        default:
            break;
    }
}
- (IBAction)newGroupSave:(id)sender
{
    if ([[self.groupName text]  isEqual:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"please fill the Group name first"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        
        
    }
    else
    {

    NSDateFormatter *foramtter = [[NSDateFormatter alloc] init];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.7);
    [foramtter setDateFormat:@"mm/dd/yyyy"];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    Postman *postman = [Postman sharedManager];
        NSString *latitudeString = [[NSNumber numberWithDouble:self.latitude] stringValue];
        NSString *longitudeString = [[NSNumber numberWithDouble:self.longitude] stringValue];

    NSDictionary *groupDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [postman GetValueOrEmpty:groupName.text], @"GroupName",
                                         [postman GetValueOrEmpty:groupDescription.text], @"GroupDescription",
                                         [postman GetValueOrEmpty:userInfo.userId], @"GroupCreatedBy",
                                         [foramtter stringFromDate:[NSDate date]], @"GroupCreatedDate",
                                         [postman GetValueOrEmpty:restrictionsText.text], @"Restriction",
                                         [postman GetValueOrEmpty:groupStatusLabel.text], @"GroupStatus",
                                         _groupId, @"GroupId",
                                         latitudeString, @"Latitude",
                                         longitudeString, @"Longitude",
                                         [postman GetValueOrEmpty:groupLocationName.text], @"GroupAddress",
                                         nil];
    
    [postman PostWithFileData:@"groups/post" :groupDataDictionary :imageData];
   
    if (_groupId == nil)
    {
    EADGroupsViewController *groupViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
        groupViewController.isNewGroupAdded = true;
    }
    else
    {
        EADGroupsViewController *groupViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3];
        groupViewController.isNewGroupAdded = true;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    }
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

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *currentObject = [self.pickerData objectAtIndex:row];
    NSString *title;
    
    if(currentObject != nil)
    {
        title = [currentObject valueForKey:@"DisplayValue"];
    }
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSDictionary *currentObject = _pickerData[row];
    
    if(currentObject != nil)
    {
        self.restrictionsText.text = [currentObject valueForKey:@"DisplayValue"];
    }
}


- (IBAction)restrictionsEditingBegin:(id)sender
{
    [self.restrictionsPicker setHidden:false];
    [sender resignFirstResponder];
}

- (IBAction)allOtherEditingBegin:(id)sender
{
    [self.restrictionsPicker setHidden:true];
}
-(void)loadGroupDetails
{
    Postman *postman = [Postman sharedManager];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:_groupId], @"GroupId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    [postman GetAsync:@"groups/getbygroupid?jsonParams=%@" :userDataDictionary
           completion:^(NSArray *dataArray)
     {
         self.self.groupDetailsArray = dataArray;
         [self populateGroupData];
     }];
}

-(void)populateGroupData
{
    if(self.groupDetailsArray != nil && self.groupDetailsArray.count > 0)
    {
        NSDictionary *currentObject = [self.groupDetailsArray objectAtIndex:0];
        
        if(currentObject != nil)
        {
            self.groupName.text = [currentObject valueForKey:@"GroupName"];
            self.groupDescription.text = [currentObject valueForKey:@"GroupDescription"];
            self.restrictionsText.text = [currentObject valueForKey:@"Restriction"];
            self.groupLocationName.text =[currentObject valueForKey:@"GroupAddress"];
            self.locationName =[currentObject valueForKey:@"GroupAddress"];
            // NSString *latitudeString = [[NSNumber numberWithDouble:self.latitude] stringValue];
            //NSString *longitudeString = [[NSNumber numberWithDouble:self.longitude] stringValue];
            self.longitude =[[currentObject valueForKey:@"Longitude" ] doubleValue];
            self.latitude =[[currentObject valueForKey:@"Latitude"] doubleValue];
            
            NSString *imageStringData = [currentObject valueForKey:@"GroupPic"];
            
            if(imageStringData != nil && ![imageStringData isEqualToString:@""])
            {
                NSData *imageData;
                
                if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
                {
                    imageData = [[NSData alloc] initWithBase64EncodedString:imageStringData options:kNilOptions];  // iOS 7+
                }
                
                if(imageData != nil)
                {
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.imageView.image = image;
                    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }
            
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable;
    if (textField == groupLocationName) {
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"imagePicker"])
    {
        EADImagePickerViewController *destinationVC = [segue destinationViewController];
        
        destinationVC.shouldLaunchCamera=_launchCamera;
        destinationVC.launchedFrom =@"Groups";
        
    }
    else if([segue.identifier isEqualToString:@"GroupToPickLocation"])
    {
        EADLocationSearchViewController *locationSearchController = segue.destinationViewController;
        
        locationSearchController.initiatingController = @"group";
    }

}

- (IBAction)groupStatusChanged:(id)sender
{
    if(self.groupStatusSwitch.isOn == true)
    {
        self.groupStatusLabel.text = @"Active";
    }
    else if(self.groupStatusSwitch.isOn == false)
    {
        self.groupStatusLabel.text = @"Inactive";
    }
}

@end
