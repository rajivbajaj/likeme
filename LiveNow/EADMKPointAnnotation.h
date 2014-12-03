//
//  EADMKPointAnnotation.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/30/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EADMKPointAnnotation : NSObject<MKAnnotation>{
    NSString *_entityId;
    NSString *_entityType;
    CLLocationCoordinate2D _coordinate;
}


@property (copy) NSString *entityId;
@property (copy) NSString *entityType;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
- (id)initWithName:(NSString*)entityId entityType:(NSString*)entityType coordinate:(CLLocationCoordinate2D)coordinate;

@end
