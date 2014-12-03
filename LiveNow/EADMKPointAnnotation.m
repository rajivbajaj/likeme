//
//  EADMKPointAnnotation.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/30/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADMKPointAnnotation.h"

@implementation EADMKPointAnnotation


- (id)initWithName:(NSString*)entityId entityType:(NSString *)entityType coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _entityId = [entityId copy];
        _entityType = [entityType copy];
        _coordinate = coordinate;
    }
    return self;
}
@end
