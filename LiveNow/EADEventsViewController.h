//
//  EADEventsViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EADCollectionViewCell.h"
@interface EADEventsViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *eventsArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@end
