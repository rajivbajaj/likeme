//
//  EADInterestsViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 9/23/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADInterestsViewController.h"
#import "Postman.h"
#import "UserInfo.h"

@interface EADInterestsViewController ()

@end



@implementation EADInterestsViewController

@synthesize selectedRows;
@synthesize interestsText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateIntrests
{
    
    NSString *userInterestsString = nil;
    for(int i =0; i<self.selectedRows.count;i++)
    {
        NSIndexPath *currentSelectionIndex = [self.selectedRows objectAtIndex:i];
        NSDictionary *currentSelection = [self.interestsData objectAtIndex:currentSelectionIndex.row];
        
        if(currentSelection != nil)
        {
            NSString *currentSelectedString = @"";
            for(int j=0;j<currentSelection.allKeys.count;j++)
            {
                
                if([currentSelection.allKeys[j] isEqualToString:@"DisplayValue"])
                {
                    currentSelectedString = currentSelection.allValues[j];
                }
            }
            
            if(userInterestsString != nil)
            {
                userInterestsString = [userInterestsString stringByAppendingString:@";"];
                userInterestsString = [userInterestsString stringByAppendingString:currentSelectedString];
            }
            else
            {
                userInterestsString = currentSelectedString;
            }
            
        }
        
    }
    
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:userInterestsString], @"UserInterests",
                                        nil];
    
    //[postMan UserInterestsUpdate:userDataDictionary];
    [postMan Post:@"users/postintrests?value=%@" :userDataDictionary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interestsTableView.dataSource = self;
    self.interestsTableView.delegate = self;
    selectedRows = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    // Do any additional setup after loading the view.
    
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Interests", @"LKGroupName",
                                        nil];
    
    self.interestsData = [postMan Get:@"utility/get?jsonParams=%@" :paramsDictionary];
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken", nil];
    
    NSArray *userInterestsData = [postMan Get:@"users/getuserinterests?jsonParams=%@" :paramsData];

    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.interestsData count]];
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
}*/

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"DisplayValue == %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.interestsData filteredArrayUsingPredicate:resultPredicate]];
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
        return [self.interestsData count];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
         NSDictionary *currentItem  = self.interestsData[indexPath.row];
        cell.textLabel.text = [currentItem valueForKey:@"DisplayValue"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedRows addObject:indexPath];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedRows removeObject:indexPath];
    }
    
    [self updateIntrests];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
