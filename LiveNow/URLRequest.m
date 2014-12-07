//
//  URLRequest.m
//  LiveNow
//
//  Created by Pravin Khabile on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.

#import "URLRequest.h"
#import "Constants.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

@implementation URLRequest

-(NSData*)GetRequest :(NSString*)urlString
{
    NSURL *formattedServiceURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:formattedServiceURL];
    //TODO: Need to do the actual certificate verification
    //[NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[formattedServiceURL host]];
    NSError *connectionError;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&connectionError];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         return data;
//     }];
    
}
@end
