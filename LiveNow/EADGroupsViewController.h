//
//  EADGroupsViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADGroupsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) IBOutlet UITableView *groupsTableView;
@property bool isNewGroupAdded;
@end
