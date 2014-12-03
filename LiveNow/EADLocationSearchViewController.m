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
    NSMutableArray *marketLocations = [[NSMutableArray alloc]init];
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
               
                
                
            }
       
    }];
    [self.locationsTableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.matchingItems.count < 1)
    {
        return  1;
    }
    else
    {
        return [self.matchingItems count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"checkListItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *currentItem = nil;
    
        currentItem  = self.matchingItems[indexPath.row];
    
    
    if(currentItem != nil)
    {
        cell.textLabel.text = [currentItem valueForKey:@"Name"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIdx = nil;
            currentIdx = indexPath;
    
    
    
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
