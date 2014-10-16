//
//  EADGroupsViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADGroupsViewController : UITableViewController
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *groupsTableView;
@end
