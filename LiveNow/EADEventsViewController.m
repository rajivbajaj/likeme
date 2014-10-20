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

@interface EADEventsViewController ()

@end

@implementation EADEventsViewController

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
    // Do any additional setup after loading the view.
    [self loadEvents];
//    _eventsArray = @[@"test1",
//                     @"test2",
//                     @"test3",
//                     @"test4",
//                     ] ;
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
                                        [postman GetValueOrEmpty:@"false"], @"IsAttending",
                                        nil];
    
    self.eventsArray = [postman Get:@"events/get?id=%@" :userDataDictionary];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _eventsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EADCollectionViewCell *myCell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:@"eventCell"
                                     forIndexPath:indexPath];
    
    NSString *cellText;
    long row = [indexPath row];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    //image = [UIImage imageNamed:_carImages[row]];
    cellText=[_eventsArray[row] valueForKey:@"EventName"];
    myCell.imageView.image = image;
    myCell.eventName.text=cellText;
    myCell.labelView.text=[_eventsArray[row] valueForKey:@"EventDescription"];
      myCell.eventCreatedBy.text=[_eventsArray[row] valueForKey:@"EventCreatedBy"];
    return myCell;
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
