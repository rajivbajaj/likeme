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
-(void) UserUpdate :(NSString*)userData;
@end
