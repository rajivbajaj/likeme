//
//  EADLocationSearchViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 12/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADLocationSearchViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADEventsCreateViewController.h"
#import "EADProfileViewController.h"

@interface EADLocationSearchViewController ()

@end

@implementation EADLocationSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationsTableView.dataSource = self;
    self.locationsTableView.delegate = self;
    
}
- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    
    [self performSearch];
}
-(void) performSearch
{
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchPlace.text;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userinfo.userLocation.coordinate, 2000, 2000);
    
    //request.region = region;
   
    _matchingItems = [[NSMutableArray alloc] init];
    //NSMutableArray *marketLocations = [[NSMutableArray alloc]init];
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
        {
            NSPredicate *noBusiness = [NSPredicate predicateWithFormat:@"business.uID == 0"];
            NSMutableArray *itemsWithoutBusinesses = [response.mapItems mutableCopy];
            [itemsWithoutBusinesses filterUsingPredicate:noBusiness];
            for (MKMapItem *item in itemsWithoutBusinesses)
            {
                [_matchingItems addObject:item];
               
                
                
            }
        }
    [self.locationsTableView reloadData];
    }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return [self.matchingItems count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"checkListItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MKMapItem *currentItem = nil;
    
      currentItem  = self.matchingItems[indexPath.row];
    
    
    if(currentItem != nil)
    {
        NSDictionary *itemAddressDictionary = currentItem.placemark.addressDictionary;
        cell.textLabel.text = [itemAddressDictionary valueForKey:@"Name"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIdx = nil;
            currentIdx = indexPath;
    
    MKMapItem *selectedItem = self.matchingItems[indexPath.row];

    
    if(selectedItem != nil)
    {
        if(selectedItem.placemark != nil)
        {
                if([self.initiatingController isEqualToString:@"profile"])
                {
                    
                  EADProfileViewController *profileViewController =  [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    
                    profileViewController.location.text = selectedItem.name;
                    profileViewController.latitude = selectedItem.placemark.coordinate.latitude;
                    profileViewController.longitude = selectedItem.placemark.coordinate.longitude;
                }
                else if([self.initiatingController isEqualToString:@"event"])
                {
                    EADEventsCreateViewController *eventViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
                    
                    eventViewController.locationName = selectedItem.name;
                    eventViewController.latitude = selectedItem.placemark.coordinate.latitude;
                    eventViewController.longitude = selectedItem.placemark.coordinate.longitude;
                }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [tableView deselectRowAtIndexPath:currentIdx animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
