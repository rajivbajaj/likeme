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

@interface EADGroupDetailsViewController ()

@end

@implementation EADGroupDetailsViewController
@synthesize groupName;
@synthesize groupDescription;
@synthesize restrictionsText;
@synthesize groupStatusLabel;
//@synthesize groupId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Postman* postman = [Postman alloc];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"EventRestrictions", @"LKGroupName",
                                      nil];
    
    self.pickerData = [postman Get:@"utility/get?jsonParams=%@" :paramsDictionary];
    if (_groupId != nil)
    {
        [self loadGroupDetails];
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
    Postman *postMan = [Postman alloc];
    NSDictionary *groupDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [postMan GetValueOrEmpty:groupName.text], @"GroupName",
                                         [postMan GetValueOrEmpty:groupDescription.text], @"GroupDescription",
                                         [postMan GetValueOrEmpty:userInfo.userId], @"GroupCreatedBy",
                                         [foramtter stringFromDate:[NSDate date]], @"GroupCreatedDate",
                                         [postMan GetValueOrEmpty:restrictionsText.text], @"Restriction",
                                         [postMan GetValueOrEmpty:groupStatusLabel.text], @"GroupStatus",
                                         _groupId, @"GroupId",
                                         nil];
    
    [postMan PostWithFileData:@"groups/post" :groupDataDictionary :imageData];
   
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
    Postman *postman = [Postman alloc];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"imagePicker"])
    {
        EADImagePickerViewController *destinationVC = [segue destinationViewController];
        
        destinationVC.shouldLaunchCamera=_launchCamera;
        destinationVC.launchedFrom =@"Groups";
        
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
