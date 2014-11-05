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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interestsTableView.dataSource = self;
    self.interestsTableView.delegate = self;
    selectedRows = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    // Do any additional setup after loading the view.
    
    Postman* postMan = [Postman alloc];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Interests", @"LKGroupName",
                                        nil];
    
    self.interestsData = [postMan Get:@"utility/get?jsonParams=%@" :paramsDictionary];

    self.searchResult = [NSMutableArray arrayWithCapacity:[self.interestsData count]];
    
    [self loadUserInterests];
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
                    break;
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
    
    [postMan Post:@"users/postintrests?value=%@" :userDataDictionary];
}

-(void)loadUserInterests
{
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken", nil];
    
    NSArray *userInterestsData = [postMan Get:@"users/getuserinterests?jsonParams=%@" :paramsData];
    
    if(userInterestsData != nil && userInterestsData.count > 0)
    {
        NSDictionary *selectedValDictionary = userInterestsData[0];
        NSString *selectedItemsString = [selectedValDictionary objectForKey:@"UserInterests"];
        
        if(selectedItemsString != nil && ![selectedItemsString isEqualToString:@""])
        {
            NSArray *selectedItemsArray = [selectedItemsString componentsSeparatedByString:@";"];
            
            for(int i=0; i<selectedItemsArray.count; i++)
            {
                int selectedItem = [self getIndexOfItem:selectedItemsArray[i]];
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:selectedItem inSection:0];
                
                [self.selectedRows addObject:idxPath];
                
                [self.interestsTableView selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                UITableViewCell *cell = [self.interestsTableView cellForRowAtIndexPath:idxPath];
                if(cell.accessoryType == UITableViewCellAccessoryNone) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
                }

            }
        }
    }
}

- (int)getIndexOfItem:(NSString*)str
{
    for(int i=0;i<self.interestsData.count;i++)
    {
        NSDictionary *nsDict  = self.interestsData[i];
        
        if(nsDict != nil && [[nsDict objectForKey:@"DisplayValue"] isEqualToString:str])
        {
            return i;
            break;
        }
    }
    
    return 0;
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"DisplayValue beginswith[c] %@", searchText];
    
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

    NSDictionary *currentItem = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        currentItem = self.searchResult[indexPath.row];
    }
    else
    {
        currentItem  = self.interestsData[indexPath.row];
    }
    
    if(currentItem != nil)
    {
        cell.textLabel.text = [currentItem valueForKey:@"DisplayValue"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIdx = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        NSDictionary *selectedItem = [self.searchResult objectAtIndex:indexPath.row];
        if(selectedItem != nil)
        {
            int selectedIndex = [self getIndexOfItem:[selectedItem objectForKey:@"DisplayValue"]];
            currentIdx = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        }
    }
    else
    {
        currentIdx = indexPath;
    }
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedRows addObject:currentIdx];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedRows removeObject:currentIdx];
        }
        
        [self updateIntrests];
    
    [tableView deselectRowAtIndexPath:currentIdx animated:YES];
}





@end
