//
//  Postman.h
//  LiveNow
//
//  Created by Pravin Khabile on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^dictionary_block_t)(NSDictionary *result);
typedef void (^array_block_t)(NSArray *result);

@interface Postman : NSObject

+ (id)sharedManager;

- (void)GetUser:(NSString*)userId callback:(dictionary_block_t)callback;
- (NSString*)GetValueOrEmpty:(NSString*)inputValue;
- (void)Get :(NSString*)urlWithParams :(NSDictionary*)paramData :(array_block_t)callback;
- (void)GetAsync:(NSString*)urlParams :(NSDictionary*)paramData completion:(void (^)(NSArray *dataArray))callBack;
//-(NSDictionary*)Get:(NSString*)urlWithParams;
-(void)UserUpdate:(NSDictionary*)userData;
-(void)UserInterestsUpdate :(NSDictionary*)interestsData;
-(void)Post:(NSString*)actionURLWithPlaceHolder :(NSDictionary*)dicData;
-(void)PostWithFileData :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)fileData;
-(void)PostAsync:(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSString*)postParamName completion:(void (^)(id response))callBack;
-(void)PostFile :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSData*)imageData;

-(NSArray*) Get :(NSString*)urlWithParams :(NSDictionary*)paramData;
-(void)PostAync :(NSString*)actionUrlWithPlaceHolder :(NSDictionary*)paramData :(NSString*)postParamName completion:(void (^)(id response))callBack;


@end
