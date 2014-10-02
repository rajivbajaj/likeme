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

@interface EADInboxViewController ()

@end

@implementation EADInboxViewController

@synthesize inboxTablView;

-(void)setDictData:(NSDictionary *)dictData
{
    _dictData = dictData;
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    //inboxTablView.delegate = self;
    //inboxTablView.dataSource = self;
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
    
    self.dictData = [postman Get:@"messages/get?value=%@" :userDataDictionary];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxItemCell" forIndexPath:indexPath];
    
    if(cell != nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", @"from somebody man"];
        cell.detailTextLabel.text = @"test body";
    }
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
