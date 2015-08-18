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
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface Postman () {
    
    NSOperationQueue *main_queue;
}

@end

@implementation Postman

static Postman *instance = nil;

+ (id)sharedManager
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        main_queue = [[NSOperationQueue alloc] init];
        [main_queue setMaxConcurrentOperationCount:10.f];
    }
    return self;
}

- (void)GetUser:(NSString*)userId callback:(dictionary_block_t)callback
{
    NSString *urlParams = [NSString stringWithFormat:@"%@users/get/%@", BaseServiceURL, userId];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlParams]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:main_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSMutableDictionary *userDataDictionary = nil;
        
        if (data != nil)
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(userDataDictionary);
        });
    }];
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

- (void)Get :(NSString*)urlWithParams :(NSDictionary*)paramData :(array_block_t)callback
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonParams = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *completeUrlWIthParams = [NSString stringWithFormat:urlWithParams, jsonParams];
    
    NSString *urlParams = [[NSString stringWithFormat:@"%@%@", BaseServiceURL, completeUrlWIthParams] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlParams];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    DLog(@"get url - %@", [url absoluteString]);
    
//    NSURLResponse * response = nil;
//    NSError * error = nil;
//    NSData * data = [NSURLConnection sendSynchronousRequest:request
//                                          returningResponse:&response
//                                                      error:&error];
//    if (error == nil)
//    {
//    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:main_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSArray *dataArray = nil;
        
        if (data != nil)
        {
            NSDictionary *masterDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (masterDictionary != nil && masterDictionary.count > 0)
            {
                dataArray = (NSArray *)masterDictionary;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(dataArray);
        });
    }];
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

-(void)PostAync :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSString*)postParamName completion:(void (^)(id response))callBack
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *completeServiceUrl = [BaseServiceURL stringByAppendingString:actionUrlWithPlaceHolder];
    completeServiceUrl = [completeServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *updatedParamsData = [NSDictionary dictionaryWithObjectsAndKeys:updateJsonData, postParamName, nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:completeServiceUrl parameters:updatedParamsData
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         callBack(responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (NSDictionary*) Get :(NSString*)urlWithParams
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

-(void)PostWithFileData :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)fileData
{
    // Create json data from the dictionary parameters
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *completeServiceUrl = [BaseServiceURL stringByAppendingString:actionUrlWithPlaceHolder];
    
    //completeServiceUrl = [BaseServiceURL stringByAppendingFormat:actionUrlWithPlaceHolder, updateJsonData];
    
    NSDictionary *updatedParamsData = [NSDictionary dictionaryWithObjectsAndKeys:updateJsonData, @"value", nil];
    
    //completeServiceUrl =  [completeServiceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if(fileData != nil)
    {
        [manager POST:completeServiceUrl parameters:updatedParamsData constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:fileData name:@"entityImage" fileName:@"attendees.png"  mimeType:@"image/png"];
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"Success: %@", responseObject);
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    }
    else
    {
        [manager POST:completeServiceUrl parameters:updatedParamsData
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"Success: %@", responseObject);
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    }
}

-(void)GetAsync :(NSString*)urlParams :(NSDictionary*)paramData completion:(void (^)(NSArray *dataArray))callBack
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonParams = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *completeUrlWIthParams = [NSString stringWithFormat:urlParams, jsonParams];
    completeUrlWIthParams = [BaseServiceURL stringByAppendingString:completeUrlWIthParams];
    
    completeUrlWIthParams = [completeUrlWIthParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:completeUrlWIthParams parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *dataArray = responseObject;
         callBack(dataArray);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

-(void)PostAsync:(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSString*)postParamName completion:(void (^)(id response))callBack {
    
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *completeServiceUrl = [BaseServiceURL stringByAppendingString:actionUrlWithPlaceHolder];
    //    completeServiceUrl = [completeServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary *updatedParamsData = [NSDictionary dictionaryWithObjectsAndKeys:updateJsonData, postParamName, nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *completeServiceUrl = [NSString stringWithFormat:actionUrlWithPlaceHolder, updateJsonData];
    completeServiceUrl = [completeServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DLog(@"post url - %@", completeServiceUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:completeServiceUrl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         callBack(responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

-(void)PostFile :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)imageData
{
    NSString* boundary = @"test";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *completeServiceUrl = [BaseServiceURL stringByAppendingString:actionUrlWithPlaceHolder];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"value"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", updateJsonData] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image.png"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURL* url = [NSURL URLWithString:completeServiceUrl];
    // set URL
    [request setURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:nil];
    
}

@end
