//
//  EADLocationPickerViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 12/3/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADLocationPickerViewController.h"

@interface EADLocationPickerViewController ()

@end

@implementation EADLocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneTouched:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end