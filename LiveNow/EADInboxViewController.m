//
//  EADInboxViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADInboxViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADMessageDetailsViewController.h"
#import "HumanInterfaceUtility.h"
@interface EADInboxViewController ()

@end

@implementation EADInboxViewController


@synthesize inboxTablView;

-(void)setDictData:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.inboxTablView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    inboxTablView.delegate = self;
    inboxTablView.dataSource = self;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (IBAction)actionsSelectorTriggered:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Compose"];
    [actionSheet addButtonWithTitle:@"Add Pic"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = 2;
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            //[self launchCamera];
            break;
        case 1:
            //[self launchCameraRoll];
            
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
     [self.view setBackgroundColor:[HumanInterfaceUtility colorWithHexString:@"C0CFD6"]];
    // Do any additional setup after loading the view.
    [self loadInbox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInbox
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    self.dataArray = [postman Get:@"messages/get?jsonParams=%@" :userDataDictionary];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxItemCell" forIndexPath:indexPath];
    
    if(cell != nil)
    {
        NSDictionary *currentObject = [self.dataArray objectAtIndex:indexPath.row];
        //NSString *objectKey =
        cell.textLabel.text = [currentObject valueForKey:@"SenderName"];
        NSInteger numberOfUnreadmessages = [[currentObject objectForKey:@"UnreadMsgCount"] integerValue];

        if(numberOfUnreadmessages > 0)
        {
            cell.detailTextLabel.text =  [[NSString stringWithFormat:@"%ld", (long)numberOfUnreadmessages] stringByAppendingString:@" new message(s)"];
        }
        
        if( [indexPath row] % 2){
            cell.backgroundColor = [HumanInterfaceUtility colorWithHexString:@"C0CFD6"];
            
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
            
        }

    }
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"messageDetails"])
    {
        EADMessageDetailsViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NSDictionary *selectedItem = [self.dataArray objectAtIndex:selectedRowIndex.row];
        
        destinationVC.senderName = [selectedItem valueForKey:@"SenderName"];
        if([[selectedItem valueForKey:@"SenderType"] isEqualToString:@"User"])
        {
            destinationVC.authorId = [selectedItem valueForKey:@"SenderId"];
            destinationVC.messangerType = @"User";
        }
        else if([[selectedItem valueForKey:@"SenderType"] isEqualToString:@"Event"])
        {
            destinationVC.eventId = [selectedItem valueForKey:@"SenderId"];
            destinationVC.messangerType = @"Event";
        }
        else if([[selectedItem valueForKey:@"SenderType"] isEqualToString:@"Group"])
        {
            destinationVC.groupId = [selectedItem valueForKey:@"SenderId"];
            destinationVC.messangerType = @"Group";
        }
        
    }
//    destinationVC
}


@end
