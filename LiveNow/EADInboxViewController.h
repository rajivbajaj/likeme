//
//  EADInboxViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EADInboxViewController : UITableViewController<UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *inboxTablView;
@property BOOL newMedia;
@property (nonatomic, strong) NSDictionary *dictData;
@end
