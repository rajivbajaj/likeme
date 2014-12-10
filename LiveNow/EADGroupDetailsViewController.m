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

- (void)viewDidLoad
{
    [super viewDidLoad];
    Postman* postman = [Postman alloc];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"EventRestrictions", @"LKGroupName",
                                      nil];
    
    self.pickerData = [postman Get:@"utility/get?jsonParams=%@" :paramsDictionary];
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
            _launchCamera = true;
            [self performSegueWithIdentifier:@"imagePicker" sender:self];
            break;
        case 1:
            _launchCamera = false;
            [self performSegueWithIdentifier:@"imagePicker" sender:self];
            break;
        default:
            break;
    }
}
- (IBAction)newGroupSave:(id)sender
{
    NSDateFormatter *foramtter = [[NSDateFormatter alloc] init];
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
                                         nil];
    
    [postMan Post:@"groups/post?value=%@" :groupDataDictionary];
    
    EADGroupsViewController *groupViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
    
    groupViewController.isNewGroupAdded = true;
    
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (IBAction)allOtherEditingBegin:(id)sender
{
    [self.restrictionsPicker setHidden:true];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"imagePicker"])
    {
        EADImagePickerViewController *destinationVC = [segue destinationViewController];
        
        destinationVC.shouldLaunchCamera=_launchCamera;
        
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
