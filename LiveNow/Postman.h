//
//  Postman.h
//  LiveNow
//
//  Created by Pravin Khabile on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Postman : NSObject
-(NSDictionary*) UserGet :(NSString*)userId;
-(void) UserUpdate :(NSDictionary*)userData;
-(NSString*)GetValueOrEmpty :(NSString*)inputValue;
-(void) UserInterestsUpdate :(NSDictionary*)interestsData;
-(void) Post :(NSString*)actionURLWithPlaceHolder :(NSDictionary*)dicData;
-(NSArray*) Get :(NSString*)urlWithParams :(NSDictionary*)paramData;
-(NSDictionary*) Get :(NSString*)urlWithParams;
-(void)PostWithFileData :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)fileData;
-(void)GetAsync :(NSString*)urlParams :(NSDictionary*)paramData completion:(void (^)(NSArray *dataArray))callBack;
//-(void)PostAync :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData;
-(void)PostAync :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSString*)postParamName completion:(void (^)(id response))callBack;
-(void)PostFile :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)imageData;
@end
