//
//  EADMessageDetailsViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 10/1/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "jSQMessages.h"
#import "MessagesData.h"
#import "NSUserDefaults+DemoSettings.h"

@class EADMessageDetailsViewController;
@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(EADMessageDetailsViewController *)vc;
@end


@interface EADMessageDetailsViewController : JSQMessagesViewController<UIActionSheetDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
//@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
//
//@property (nonatomic, retain) NSString *from;
//@property (nonatomic, retain) NSString *subject;
//@property (nonatomic, retain) NSString *message;


@property (nonatomic, retain) NSString *senderName;
@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) MessagesData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *messangerType;
@end
