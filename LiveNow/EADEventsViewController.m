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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    // Do any additional setup after loading the view.
    [self loadEvents];
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
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
//                                        [postman GetValueOrEmpty:@"false"], @"IsAttending",
                                        nil];
    
    self.eventsArray = [postman Get:@"events/getbyradius?paramsJson=%@" :userDataDictionary];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{   
    if ([self.searchDisplayController.searchBar.text  isEqualToString:@""])
    {
        return [self.eventsArray count];
    }
    else
    {
        return [self.filteredArray count];
    }

    //return _eventsArray.count;
}
- (IBAction)filterEvents:(UITextField *)sender  {
    
    [self.filteredArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", sender.text];
    
    self.filteredArray = [NSMutableArray arrayWithArray: [self.eventsArray filteredArrayUsingPredicate:resultPredicate]];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.filteredArray = [NSMutableArray arrayWithArray: [self.eventsArray filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EADCollectionViewCell *myCell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:@"eventCell"
                                     forIndexPath:indexPath];
    
    NSString *cellText;
    long row = [indexPath row];
    //UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSURL *imageURL = [NSURL URLWithString:[_eventsArray[row] valueForKey:@"FBProfileURL"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    //image = [UIImage imageNamed:_carImages[row]];
    cellText=[_eventsArray[row] valueForKey:@"EventName"];
    myCell.imageView.image = image;
    myCell.eventName.text=cellText;
    myCell.labelView.text=[_eventsArray[row] valueForKey:@"EventDescription"];
      myCell.eventCreatedBy.text=[_eventsArray[row] valueForKey:@"UserName"];
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedCellIndex = indexPath.row;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
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
 
 }

 // Pass the selected object to the new view controller.
 


@end
