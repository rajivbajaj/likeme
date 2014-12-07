//
//  EADMapViewViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/13/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADMapViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADUserListProfileViewController.h"
#import "EADMKPointAnnotation.h"
#import "EADEventDetailViewController.h"

@interface EADMapViewController ()

@end

@implementation EADMapViewController

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self searchAll];
}

- (IBAction)searchText:(id)sender {
}

-(void)searchAll
{
    Postman* postMan = [Postman alloc];
    //UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                [postMan GetValueOrEmpty:_searchText.text], @"searchstring", nil];
    self.matchingItems = [[postMan Get:@"utility/search?jsonParams=%@" :paramsData] mutableCopy];
    
   NSMutableArray *marketLocations = [[NSMutableArray alloc]init];
    
    for (NSDictionary *currentObject in self.matchingItems)
    {
        
        CLLocationCoordinate2D  ctrpoint;
        ctrpoint.latitude = [[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Latitude"]] doubleValue ];
        ctrpoint.longitude =[[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Longitude"]] doubleValue ];
       // EADMKPointAnnotation *annotation =
       // [[EADMKPointAnnotation alloc]init];
    EADMKPointAnnotation *annotation = [[EADMKPointAnnotation alloc] initWithName:[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityId"]] entityType:[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityType"]] coordinate:ctrpoint] ;
        //annotation.coordinate=ctrpoint;
        annotation.title = [NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityName"]];
        
        annotation.subtitle=[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityType"]];
        //annotation. =[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityId"]];
        //annotation.entityType =[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityType"]];
        //annotation.entityId = [NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EntityId"]];

        [marketLocations addObject:annotation];
        //[_mapView addAnnotation:annotation];
    }
    [_mapView addAnnotations:marketLocations];

    //AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:ctrpoint];
    //[mapview addAnnotation:addAnnotation];
    //[addAnnotation release];
    
//    NSString *location = @"piscataway,nj";
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder geocodeAddressString:location
//                 completionHandler:^(NSArray* placemarks, NSError* error){
//                     if (placemarks && placemarks.count > 0) {
//                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
//                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
//                         
//                         MKCoordinateRegion region = self.mapView.region;
//                         region.center = placemark.region.center;
//                         //region.span.longitudeDelta /= 8.0;
//                         //region.span.latitudeDelta /= 8.0;
//                        
//                         [self.mapView setRegion:region animated:YES];
//                         [self.mapView addAnnotation:placemark];
//                     }
//                 }
//     ];

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
        EADMKPointAnnotation *annotation1 =annotation;
      

        pinView=(MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:nil];
        if(pinView==nil)
            pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        if ([annotation1.subtitle  isEqual: @"User"])
        {
            pinView.pinColor=MKPinAnnotationColorPurple;
        }
        else
        {
            pinView.pinColor=MKPinAnnotationColorGreen;
        }
                pinView.canShowCallout=YES;
        pinView.animatesDrop=YES;
        pinView.rightCalloutAccessoryView= [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }
    else
    {
        [self.mapView.userLocation setTitle:@"You are Here!"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (view.selected == YES )
    {
        //TODO segue to event/person
        
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    EADMKPointAnnotation *location = view.annotation;
    
    if (view.selected)
    {
        _annotationId = location.entityId;
        _annotationType = location.entityType;
        if ([_annotationType isEqualToString:@"User"])
        {
            [self performSegueWithIdentifier:@"mapToProfileDetail" sender:view];
        }
        else
        {
             [self performSegueWithIdentifier:@"mapToEventDetail" sender:view];
        }
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"mapToProfileDetail"])
    {
        EADUserListProfileViewController *destinationVC = [segue destinationViewController];
        
        destinationVC.userId = _annotationId;
        
        
    }
    else if ([segue.identifier isEqualToString:@"mapToEventDetail"])
    {
        EADEventDetailViewController *destinationDetailVC = [segue destinationViewController];
        
        destinationDetailVC.eventId = _annotationId;
    }
}


@end
