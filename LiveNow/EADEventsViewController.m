//
//  EADEventsViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADEventsViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADEventDetailViewController.h"
#import "EADMapViewController.h"

@interface EADEventsViewController ()

@end

@implementation EADEventsViewController

NSInteger selectedCellIndex;
//@synthesize searchBar;
@synthesize filteredArray;

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
    //self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    // Do any additional setup after loading the view.
    [self loadEvents];
}

-(void)viewDidAppear:(BOOL)animated
{
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    if(self.isNewEventAdded == true || userInfo.isRadiusChanged == true)
    {
        [self loadEvents];
        [self.eventsCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEvents
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    if (_isMyEvent)
    {
        NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [NSString stringWithFormat:@"%i", userInfo.interestedRadius], @"RadiusDistance",
                                        @"true", @"IsAttending",
                                        nil];
        self.eventsArray = [postman Get:@"events/getbyradius?paramsJson=%@" :userDataDictionary];
    }
    else
    {
        NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                            [NSString stringWithFormat:@"%i", userInfo.interestedRadius], @"RadiusDistance",
                                            @"false", @"IsAttending",
                                            nil];
        
        self.eventsArray = [postman Get:@"events/getbyradius?paramsJson=%@" :userDataDictionary];

    }
    
    [self.eventsCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{   
    if ([self.searchBar.text isEqualToString:@""])
    {
        return [self.eventsArray count];
    }
    else
    {
        return [self.filteredArray count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EADCollectionViewCell *myCell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:@"eventCell"
                                     forIndexPath:indexPath];
    
    NSString *cellText;
    NSDictionary *currentItem = nil;
    
    if([self.searchBar.text isEqualToString:@""])
    {
        currentItem = self.eventsArray[indexPath.row];
    }
    else
    {
        currentItem = self.filteredArray[indexPath.row];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[currentItem valueForKey:@"FBProfileURL"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    cellText=[currentItem valueForKey:@"EventName"];
    myCell.imageView.image = image;
    myCell.eventName.text=cellText;
    myCell.labelView.text=[currentItem valueForKey:@"EventDescription"];
    myCell.eventCreatedBy.text=[currentItem valueForKey:@"UserName"];
    
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedCellIndex = indexPath.row;
    [self performSegueWithIdentifier:@"eventDetail" sender:self];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.eventsCollectionView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"EventName contains[c] %@", searchText];
    
    self.filteredArray = [NSMutableArray arrayWithArray: [self.eventsArray filteredArrayUsingPredicate:resultPredicate]];
    [self.eventsCollectionView reloadData];
}

-(IBAction) filterEvents
{
    [self.filteredArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"IsOwner=", @"Yes"];
    
    self.filteredArray = [NSMutableArray arrayWithArray: [self.eventsArray filteredArrayUsingPredicate:resultPredicate]];
    [self.eventsCollectionView reloadData];
    NSLog(@"my events ...");
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
    [self performSegueWithIdentifier:@"eventToMap" sender:searchBar];

}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     if([segue.identifier isEqualToString:@"eventDetail"])
     {
              EADEventDetailViewController *destinationVC = [segue destinationViewController];
             //NSIndexPath *selectedRowIndex = [self indexPathForSelectedRow];
             NSDictionary *selectedItem = [self.eventsArray objectAtIndex:selectedCellIndex];
            // 
            destinationVC.eventId = [selectedItem valueForKey:@"EventId"];
     }
     else if ([segue.identifier isEqualToString:@"eventToMap"])
     {
      
         EADMapViewController *destinationVC = [segue destinationViewController];
         //NSIndexPath *selectedRowIndex = [self indexPathForSelectedRow];
         //NSDictionary *selectedItem = [self.eventsArray objectAtIndex:selectedCellIndex];
         //
         destinationVC.loadEvents = true;
         destinationVC.matchingItems = [[NSMutableArray alloc] initWithArray:self.eventsArray];
     }
 }

 // Pass the selected object to the new view controller.
 -(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}


@end
