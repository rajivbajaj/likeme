//
//  EADReportAbuseViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 12/13/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADReportAbuseViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *entityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *entityTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionLabel;

@property NSString* entityType;
@property NSString* entityName;
@property NSString* entityId;
@property NSString* authenticationToken;
@end
