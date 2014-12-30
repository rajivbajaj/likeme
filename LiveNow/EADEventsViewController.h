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
<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;

@property (nonatomic, strong) NSArray *eventsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property BOOL isNewEventAdded;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myEvents;
@property BOOL isMyEvent;


@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
