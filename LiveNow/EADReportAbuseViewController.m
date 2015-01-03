//
//  EADReportAbuseViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 12/13/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADReportAbuseViewController.h"
#import "Postman.h"
#import "UserInfo.h"

@interface EADReportAbuseViewController ()

@end

@implementation EADReportAbuseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.entityTypeLabel.text = self.entityType;
    self.entityNameLabel.text = self.entityName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveTouched:(id)sender
{
    if ([[self.descriptionLabel text]  isEqual:@""])
    {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                            message:@"please fill the description first"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //[alert release];
        
        
    }
    else
    {
    Postman *postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    
    NSDictionary *reportAbuseDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.entityId, @"EntityId",
                                        self.entityType, @"EntityType",
                                        userInfo.userId, @"ReportedBy",
                                        [self.descriptionLabel text], @"ReportDescription",
                                        nil];
    
    [postman Post:@"reportabuse/post?value=%@" :reportAbuseDataDictionary];
    [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
