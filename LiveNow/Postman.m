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

-(void) UserInterestsUpdate :(NSDictionary*)interestsData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:interestsData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStringToUpdate = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlParams = [NSString stringWithFormat:@"users/postinterests?value=%@", jsonStringToUpdate];
    [self ServiceCall:urlParams];
}

-(void) Post :(NSString*)actionURLWithPlaceHolder :(NSDictionary*)dicData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlParams = [NSString stringWithFormat:actionURLWithPlaceHolder, updateJsonData];
    [self ServiceCall:urlParams];
}

-(NSArray*) Get :(NSString*)urlWithParams :(NSDictionary*)paramData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonParams = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *completeUrlWIthParams = [NSString stringWithFormat:urlWithParams, jsonParams];
    NSData *data = [self ServiceCall:completeUrlWIthParams];
    NSArray *dataArray;
    
    if(data != nil)
    {
        NSDictionary *masterDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(masterDictionary != nil && masterDictionary.count > 0)
        {
             dataArray = (NSArray *)masterDictionary;
        }
    }
    
    return dataArray;
}

-(NSDictionary*) Get :(NSString*)urlWithParams 
{
    NSData *data = [self ServiceCall:urlWithParams];
    NSDictionary *dataDictionary = nil;
    
    if(data != nil)
    {
        NSDictionary *masterDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(masterDictionary != nil && masterDictionary.count > 0)
        {
            NSArray *dataArray = (NSArray *)masterDictionary;
            
            for (int i=0; i<dataArray.count; i++) {
                dataDictionary = [dataArray objectAtIndex:i];
            }
        }
    }
    
    return dataDictionary;
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
