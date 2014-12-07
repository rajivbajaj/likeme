//
//  EADUserListTableViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/4/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADUserListTableViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADUserListProfileViewController.h"

@interface EADUserListTableViewController ()

@end

@implementation EADUserListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUsers];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) loadUsers
{
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken", nil];
    self.userListData = [postMan Get:@"users/getall?jsonParams=%@" :paramsData];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.userListData count]];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.userListData count];
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        NSDictionary *currentItem  = self.searchResult[indexPath.row];
        cell.textLabel.text = [currentItem valueForKey:@"FirstName"];
        
        NSURL *imageURL = [NSURL URLWithString:[currentItem valueForKey:@"FBProfileURL"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image=image;
    }
    else
    {
        NSDictionary *currentItem  = self.userListData[indexPath.row];
        cell.textLabel.text = [currentItem valueForKey:@"FirstName"];
        NSURL *imageURL = [NSURL URLWithString:[currentItem valueForKey:@"FBProfileURL"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image=image;
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
            int selectedIndex = [self getIndexOfItem:[selectedItem objectForKey:@"FirstName"]];
            currentIdx = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        }
    }
    else
    {
        currentIdx = indexPath;
    }

           [tableView deselectRowAtIndexPath:currentIdx animated:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"FirstName beginswith[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.userListData filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}
- (int)getIndexOfItem:(NSString*)str
{
    for(int i=0;i<self.userListData.count;i++)
    {
        NSDictionary *nsDict  = self.userListData[i];
        
        if(nsDict != nil && [[nsDict objectForKey:@"FirstName"] isEqualToString:str])
        {
            return i;
            break;
        }
    }
    
    return 0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ShowUserProfileDetail"])
    {
        EADUserListProfileViewController *destinationVC = [segue destinationViewController];
        //NSIndexPath *selectedRowIndex = [self indexPathForSelectedRow];
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        long row = [myIndexPath row];        //
        destinationVC.userId = [_userListData[row] valueForKey:@"UserId"];
        
    }

}


@end
