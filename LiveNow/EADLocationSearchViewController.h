//
//  EADLocationSearchViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 12/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EADLocationSearchViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchPlace;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
-(IBAction)textFieldReturn:(id)sender;

@end
