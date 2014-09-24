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

-(void) UserUpdate :(NSDictionary*)userData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *userInfoUpdate = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlParams = [NSString stringWithFormat:@"users/post?value=%@", userInfoUpdate];
    [self ServiceCall:urlParams];
}


-(NSData *) ServiceCall :(NSString*)dataParams
{
    NSString *formattedServiceURLString = [BaseServiceURL  stringByAppendingString:dataParams];
    URLRequest *requestHelper = [URLRequest alloc];
    return [requestHelper GetRequest:formattedServiceURLString];
}

-(NSString*)GetValueOrEmpty :(NSString*)inputValue
{
    return inputValue == nil ? @"" : inputValue;
}
@end
