//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "MessagesData.h"
#import "UserInfo.h"
#import "Postman.h"


#import "NSUserDefaults+DemoSettings.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation MessagesData

@synthesize messangerType;
@synthesize authorId;
@synthesize eventId;

- (instancetype)init
{
    self = [super init];
    if (self) {

        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        else {
            [self loadMessages];
        }
        
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        
        NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];

        
        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *jobsImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]
                                                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
                          kJSQDemoAvatarIdCook : cookImage,
                          kJSQDemoAvatarIdJobs : jobsImage, 
                          kJSQDemoAvatarIdWoz : wozImage };
        
        
        self.users = @{ kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
                        kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
                        kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        self.outgoingBubbleImageData = [JSQMessagesBubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        
        self.incomingBubbleImageData = [JSQMessagesBubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
    }
    
    return self;
}

- (void)loadMessages
{
    
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSArray *dataArray = nil;
    
    if([self.messangerType isEqualToString:@"User"])
    {
        NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [postman GetValueOrEmpty:userInfo.userId], @"RecipientAuthenticationToken",
                                            self.authorId, @"AuthorAuthToken",
                                            nil];
        
        dataArray = [postman Get:@"messages/getbyauthor?jsonParams=%@" :paramsDictionary];
    }
    else if([self.messangerType isEqualToString:@"Event"])
    {
        NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [postman GetValueOrEmpty:userInfo.userId], @"RecipientAuthenticationToken",
                                          self.eventId, @"EventId",
                                          nil];
        
        dataArray = [postman Get:@"messages/getbyevent?jsonParams=%@" :paramsDictionary];
    }
    
    if(dataArray != nil)
    {
        NSMutableArray *jsqMessagesArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<dataArray.count; i++)
        {
            
            NSDictionary *currentItem = [dataArray objectAtIndex:i];
            
          JSQTextMessage *msg =  [[JSQTextMessage alloc] initWithSenderId:[currentItem valueForKey:@"SenderId"]
                                   senderDisplayName:[currentItem valueForKey:@"FirstName"]
                                                date:[NSDate distantPast]
                                                text:[currentItem valueForKey:@"Message"]];
            

            
            [jsqMessagesArray addObject:msg];
        }
        
        self.messages = jsqMessagesArray;
    }
    
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                            senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                         date:[NSDate distantPast]
//                                                         text:@"Welcome to LiveNow: A Social Connecting app."],
//                     
//                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdWoz
//                                            senderDisplayName:kJSQDemoAvatarDisplayNameWoz
//                                                         date:[NSDate distantPast]
//                                                         text:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy."],
//                     
//                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                            senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                         date:[NSDate distantPast]
//                                                         text:@"It has features like live connection."],
//                     
//                     
//                     
//                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                            senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                         date:[NSDate date]
//                                                         text:@"You can send media messages as well!"],
//                     nil];
//    
//    //[self addPhotoMediaMessage];
//    
//    /**
//     *  Setting to load extra messages for testing/demo
//     */
//    if ([NSUserDefaults extraMessagesSetting]) {
//        NSArray *copyOfMessages = [self.messages copy];
//        for (NSUInteger i = 0; i < 4; i++) {
//            [self.messages addObjectsFromArray:copyOfMessages];
//        }
//    }
//    
//    
//    /**
//     *  Setting to load REALLY long message for testing/demo
//     *  You should see "END" twice
//     */
//    if ([NSUserDefaults longMessageSetting]) {
//        JSQTextMessage *reallyLongMessage = [JSQTextMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                                    displayName:kJSQDemoAvatarDisplayNameSquires
//                                                                           text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
//        
//        [self.messages addObject:reallyLongMessage];
//    }
}

- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[self.imageView image]];
    JSQMediaMessage *photoMessage = [JSQMediaMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                             displayName:kJSQDemoAvatarDisplayNameSquires
                                                                   media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMediaMessage *locationMessage = [JSQMediaMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                                displayName:kJSQDemoAvatarDisplayNameSquires
                                                                      media:locationItem];
    [self.messages addObject:locationMessage];
}

@end
