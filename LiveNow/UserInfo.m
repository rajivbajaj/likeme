//
//  UserInfo.m
//  LiveNow
//
//  Created by Pravin Khabile on 9/20/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(id)sharedUserInfo
{
    static UserInfo *userInfo = nil;
    
    @synchronized(self)
    {
        if(userInfo == nil)
        {
            userInfo = [[self alloc] init];
        }
    }
    
    return userInfo;
}

@end
