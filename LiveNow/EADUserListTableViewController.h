//
//  EADUserListTableViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/4/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADUserListTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *userListData;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property NSMutableArray *selectedRows;
@property (strong, nonatomic) IBOutlet UITableView *usersTableView;
@end
