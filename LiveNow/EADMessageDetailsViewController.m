//
//  EADMessageDetailsViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 10/1/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADMessageDetailsViewController.h"

@interface EADMessageDetailsViewController ()

@end

@implementation EADMessageDetailsViewController

@synthesize fromLabel;
@synthesize subjectLabel;
@synthesize messageLabel;

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
    self.fromLabel.text = [self from];
    self.subjectLabel.text = [self subject];
    self.messageLabel.text = [self message];
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
}
*/

@end
