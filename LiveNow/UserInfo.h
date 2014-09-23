//
//  UserInfo.h
//  LiveNow
//
//  Created by Pravin Khabile on 9/20/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* profileImageURL;

+(id)sharedUserInfo;
@end
