//
//  URLRequest.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.

#import <UIKit/UIKit.h>

@interface URLRequest : NSURLRequest
-(NSData*)GetRequest :(NSString*)urlString;
//+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;
@end
