//
//  EADMapViewViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/13/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADMapViewController.h"

@interface EADMapViewController ()

@end

@implementation EADMapViewController

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self performSearch];
}

- (IBAction)searchText:(id)sender {
}
-(void) performSearch
{
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchText.text;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);
    
    request.region = region;
    [_mapView setRegion:region animated:YES];
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
                [_matchingItems addObject:item.placemark];
                MKPointAnnotation *annotation =
                [[MKPointAnnotation alloc]init];
                //annotation.image = [UIImage imageNamed:@"something"];
               // MKPinAnnotationView *annotation = [[MKPinAnnotationView alloc] init];
                
                annotation.coordinate = item.placemark.coordinate;
                
                annotation.title = item.name;
                [marketLocations addObject:annotation];
                //[_mapView addAnnotation:annotation];
                //

            }
        [_mapView addAnnotations:marketLocations];
        //[self.view addSubview:self.mapView];

        //[_mapView removeAnnotations:[_mapView annotations]];
       [_mapView showAnnotations:_matchingItems animated:YES];
    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    
    MKPinAnnotationView*pinView=nil;
    if(annotation!=self.mapView.userLocation)
    {
        
        pinView=(MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:nil];
        if(pinView==nil)
            pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pinView.pinColor=MKPinAnnotationColorPurple;
        pinView.canShowCallout=YES;
        pinView.animatesDrop=YES;
    }
    else
    {
        [self.mapView.userLocation setTitle:@"You are Here!"];
    }
    return pinView;
}
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
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);

    [_mapView setRegion:region animated:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
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
