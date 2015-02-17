//
//  EADImagePickerViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/25/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADImagePickerViewController.h"
#import "EADGroupDetailsViewController.h"
#import "EADEventsCreateViewController.h"
#import "MessagesData.h"
#import "HumanInterfaceUtility.h"
#import "EADMessageDetailsViewController.h"
@interface EADImagePickerViewController ()

@end

@implementation EADImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) launchCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}
-(void) launchCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    if ([self.launchedFrom isEqualToString:@"Groups"])
    {
        EADGroupDetailsViewController *groupViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
        
        groupViewController.imageView.image = image;
        
        
    }
    else if ([self.launchedFrom isEqualToString:@"Event"])
    {
            EADEventsCreateViewController *eventViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
            
            eventViewController.imageView.image = image;
        
//            [eventViewController.cameraButton setImage:image forState:UIControlStateNormal];
//        [eventViewController.cameraButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        EADMessageDetailsViewController *msgViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
        
        msgViewController.imageMessage = image;
        //[msgViewController addPhotoMediaMessage];
    }
        [self.navigationController popViewControllerAnimated:YES];
    }
//    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        // Code here to support video if enabled
//    }
}
- (IBAction)actionInitiatorTouched:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
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
            [self launchCamera];
            break;
        case 1:
            [self launchCameraRoll];
            break;
        default:
            break;
    }
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
     [self.view setBackgroundColor:[HumanInterfaceUtility colorWithHexString:@"C0CFD6"]];
    // Do any additional setup after loading the view.
    if (_shouldLaunchCamera)
    {
    [self launchCamera];
    }
    else
    {
        [self launchCameraRoll];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
