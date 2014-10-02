//
//  EADMessageDetailsViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 10/1/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADMessageDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *message;
@end
