//
//  Postman.m
//  LiveNow
//
//  Created by Pravin Khabile on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "Postman.h"
#import "URLRequest.h"
#import "Constants.h"

@implementation Postman
-(NSDictionary*) UserGet :(NSString*)userId
{
    NSString *urlParams = [NSString stringWithFormat:@"users/get/%@", userId];
    NSData *data = [self ServiceCall:urlParams];
    NSMutableDictionary *userDataDictionary = nil;
    
    if(data != nil)
    {
        NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(userDictionary != nil && userDictionary.count > 0)
        {
            NSArray *userArrayData = (NSArray *)userDictionary;
            
            if(userArrayData != nil && [userArrayData isKindOfClass:[NSArray class]] && userArrayData.count > 0)
            {
                userDataDictionary = [userArrayData objectAtIndex:0];
            }
        }
    }
    
    return userDataDictionary;
}

-(void) UserUpdate :(NSString*)userData
{
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDataDictionary options:0 error:nil];
    //NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSString *urlParams = [NSString stringWithFormat:@"users/post?value=%@", userData];
    [self ServiceCall:urlParams];
    //NSDictionary *userDataDictionary =
    //    "{  AuthenticationToken: "jamesfbauth",
    //        Email : "james@kmail.com",
    //        UserStatus : "A",
    //        AuthenticationProvider : "FB" }
    
    
    
}


-(NSData *) ServiceCall :(NSString*)dataParams
{
    NSString *formattedServiceURLString = [BaseServiceURL  stringByAppendingString:dataParams];
    URLRequest *requestHelper = [URLRequest alloc];
    return [requestHelper GetRequest:formattedServiceURLString];
}
@end
