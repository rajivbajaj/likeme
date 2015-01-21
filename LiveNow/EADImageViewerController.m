//
//  EADImageViewerController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 1/19/15.
//  Copyright (c) 2015 EliteAppDesigner. All rights reserved.
//

#import "EADImageViewerController.h"

@interface EADImageViewerController ()

@end

@implementation EADImageViewerController

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
    _imageViewData.image=_imageData;
    _imageViewData.contentMode = UIViewContentModeScaleAspectFill;
    // Do any additional setup after loading the view.
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
