//
//  EADProfileViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *displayNameText;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *statusText;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *Interests;

@end
