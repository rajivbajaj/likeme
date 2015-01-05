//
//  EADInterestsViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 9/23/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADInterestsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) NSArray *interestsData;
@property (weak, nonatomic) IBOutlet UITableView *interestsTableView;
@property (nonatomic, strong) NSMutableArray *searchResult;
@end
