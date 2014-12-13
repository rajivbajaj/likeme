//
//  EADMapViewViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/13/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EADMapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property NSString *annotationId;
@property NSString *annotationType;
@property BOOL loadEvents;
@property BOOL loadUsers;
-(IBAction)textFieldReturn:(id)sender;
@end
