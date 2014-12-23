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

- (void)zoomToAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    //[_mapView setVisibleMapRect:zoomRect animated:YES];
    [_mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
}
-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView
{
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MKPointAnnotation *_annotationId in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, _annotationId.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, _annotationId.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, _annotationId.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, _annotationId.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
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
    [_mapView showAnnotations:marketLocations animated:YES];
    //[self zoomToAnnotations];
    //[self zoomToFitMapAnnotations:_mapView];
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 200000, 200000);
    
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
    [_mapView removeAnnotations:[_mapView annotations]];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
   // NSString *latitudeString = [[NSNumber numberWithDouble:userInfo.Latitude] stringValue];
    //NSString *longitudeString = [[NSNumber numberWithDouble:_longitude] stringValue];
    
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = [[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"Latitude"]] doubleValue ];
    ctrpoint.longitude =[[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"Longitude"]] doubleValue ];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(ctrpoint, 20000, 20000);

    [_mapView setRegion:region animated:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    if (_loadEvents)
    {
        [self drawEvents];
    }
    else if (_loadUsers)
    {
        [self drawUsers];
    }
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

-(void)drawEvents
{
    NSMutableArray *marketLocations = [[NSMutableArray alloc]init];
    
    for (NSDictionary *currentObject in self.matchingItems)
    {
        
        CLLocationCoordinate2D  ctrpoint;
        ctrpoint.latitude = [[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Latitude"]] doubleValue ];
        ctrpoint.longitude =[[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Longitude"]] doubleValue ];
        // EADMKPointAnnotation *annotation =
        // [[EADMKPointAnnotation alloc]init];
        EADMKPointAnnotation *annotation = [[EADMKPointAnnotation alloc] initWithName:[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EventId"]] entityType:@"Event" coordinate:ctrpoint] ;
        //annotation.coordinate=ctrpoint;
        annotation.title = [NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EventName"]];
        
        annotation.subtitle=[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"EventType"]];
       
        
        [marketLocations addObject:annotation];
        //[_mapView addAnnotation:annotation];
    }
    [_mapView addAnnotations:marketLocations];
    
    [self zoomToAnnotations];
    //[_mapView showAnnotations:marketLocations animated:YES];
}
-(void)drawUsers
{
    NSMutableArray *marketLocations = [[NSMutableArray alloc]init];
    
    for (NSDictionary *currentObject in self.matchingItems)
    {
        
        CLLocationCoordinate2D  ctrpoint;
        ctrpoint.latitude = [[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Latitude"]] doubleValue ];
        ctrpoint.longitude =[[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"Longitude"]] doubleValue ];
        // EADMKPointAnnotation *annotation =
        // [[EADMKPointAnnotation alloc]init];
        EADMKPointAnnotation *annotation = [[EADMKPointAnnotation alloc] initWithName:[NSString stringWithFormat:@"%@",[currentObject valueForKey:@"UserId"]] entityType:@"User" coordinate:ctrpoint] ;
        //annotation.coordinate=ctrpoint;
        annotation.title = [NSString stringWithFormat:@"%@",[currentObject valueForKey:@"FirstName"]];
        
        annotation.subtitle=@"User";
        
        [marketLocations addObject:annotation];
        //[_mapView addAnnotation:annotation];
    }
    [_mapView addAnnotations:marketLocations];
    
 //[self zoomToAnnotations];
    [_mapView showAnnotations:marketLocations animated:YES];
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
