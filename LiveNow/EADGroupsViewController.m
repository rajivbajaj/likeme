//
//  EADGroupsViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) @ 2014 EliteAppDesigner. All rights reserved.
//

#import "EADGroupsViewController.h"
#import "UserInfo.h"
#import "Postman.h"
#import "EADGroupReadOnlyViewController.h"

@interface EADGroupsViewController ()

@end

@implementation EADGroupsViewController

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
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    //self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    
    [self loadUserGroups];
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.dataArray count]];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.isNewGroupAdded == true)
    {
        [self loadUserGroups];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUserGroups
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    self.dataArray = [postman Get:@"groups/getbyuser?jsonParams=%@" :userDataDictionary];
    
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"GroupName == %@", searchText];
    
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.dataArray filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.dataArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"groupSummaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        NSDictionary *currentObject = [self.searchResult objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentObject valueForKey:@"GroupName"];
        cell.detailTextLabel.text = [currentObject valueForKey:@"GroupDescription"];
    }
    else
    {
        NSDictionary *currentObject = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentObject valueForKey:@"GroupName"];
        cell.detailTextLabel.text = [currentObject valueForKey:@"GroupDescription"];
    }
    
    return cell;

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"groupsReadonlyViewSegue"])
    {
        NSIndexPath *selectedIndexPath = [self.groupsTableView indexPathForSelectedRow];
        NSDictionary *currentObject;
        
        
        if(self.searchResult != nil && self.searchResult.count > 0)
        {
            currentObject = [self.searchResult objectAtIndex:selectedIndexPath.row];
        }
        else
        {
            currentObject = [self.dataArray objectAtIndex:selectedIndexPath.row];
        }
        
        if(currentObject != nil)
        {
            EADGroupReadOnlyViewController *groupReadOnlyView = [segue destinationViewController];
            
            if(groupReadOnlyView != nil)
            {
              groupReadOnlyView.groupId = [currentObject valueForKey:@"GroupId"];
            }
        }
    }
}


@end
