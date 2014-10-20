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

- (IBAction)updateIntrests:(id)sender {
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:interestsText.text], @"UserInterests",
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
    
//    Postman* postMan = [Postman alloc];
//    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    self.interestsData = [[NSArray alloc] initWithObjects:@"Football",@"Basketball",@"Tennis", @"Boardgames",@"Shop",@"Films",@"Food",@"Travel",@"Books", nil];

    
//    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken", nil];
//    
//    NSDictionary *interestsData = [postMan Get:[NSString stringWithFormat:@"users/getuserinterests?id=%@", userInfo.userId]];
//    
//    interestsText.text = [interestsData valueForKey:@"UserInterests"];
    
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.interestsData filteredArrayUsingPredicate:resultPredicate]];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return YES;
//}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkListItem" forIndexPath:indexPath];
    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkListItem"];
//    }
    
    if(cell != nil)
    {
        
        NSString *title = [self.interestsData objectAtIndex:indexPath.row];
        cell.textLabel.text = title;
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
        }
        else
        {
            cell.textLabel.text = self.interestsData[indexPath.row];
        }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}



@end
